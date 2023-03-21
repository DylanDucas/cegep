require "sinatra"
require "sinatra/reloader" if development?
require "openssl"
require "securerandom"
require "date"

USER_FILE = "users.json"
FILE_FILE = "files.json"
SHA_KEY = "th3Superkey!"

helpers do
    def guard!
      auth_required = [
        401,
        {
          "WWW-Authenticate" => "Basic"
        },
        "Invalid credentials"
      ]
      halt auth_required unless authorized?
    end
  
    def authorized?
      @auth ||=  Rack::Auth::Basic::Request.new(request.env) 
  
      return unless @auth.provided? && @auth.basic? && @auth.credentials
  
      username, password = @auth.credentials
  
      users = load_user

      user_index = users.find_index {|user| username == user[:name] && sha256(password) == user[:password]}
      
      @user = users[user_index] unless user_index.nil?
    end
end

def sha256(value)
    nil if value.nil? || value.empty?
  
    OpenSSL::HMAC.hexdigest("sha256", SHA_KEY, value)
end

def load_user
    return JSON.parse(File.read(USER_FILE), {symbolize_names: true}) rescue []
end

def load_files
    return JSON.parse(File.read(FILE_FILE), {symbolize_names: true}) rescue []
end

get "/loadingInfo" do
  authorized?

  return [200,@user&.fetch(:name)]
end


get "/login" do
    guard!

    redirect "/"
    return [303, {"Location" => "/"}]
end

get "/" do
    send_file("gallery.html")

    return [200, File.read("gallery.html")]
end

get "/files" do
  authorized?

  files = load_files

  files.each do |file| 
    file[:mine] = false
    file[:mine] = (@user[:id] == file[:user_id]) unless @user.nil?
    file[:private] = (file[:pass] != "" && !file[:pass].nil?)
    file.delete(:pass)
    file.delete(:user_id)
  end

  files.sort_by! {|file| [file[:mine]?0:1,file[:timestamp],file[:name]]}.reverse

  return [200,files.to_json]
end

get "/files/:hash/download" do
  authorized?

  pass = params["pass"] rescue ""
  hash = params["hash"] rescue ""

  files = load_files

  file_index = files.find_index {|file| file[:hash] == hash}
  return [404, "File not found"] if file_index.nil?

  unless files[file_index][:pass].nil?
    return [401, "Authentication required"] unless (files[file_index][:pass] == pass) || (@user[:id] == files[file_index][:user_id] || files[file_index][:pass].nil? || files[file_index][:pass] == "")
  end
  
  return [200,{"name" => files[file_index][:name], "content" => File.read("cowsay_stock/#{hash}.txt")}.to_json]
end

get "/files/:hash" do
  authorized?

  @user = {} if @user.nil?

  pass = params["pass"] rescue ""
  hash = params["hash"] rescue ""

  files = load_files

  file_index = files.find_index {|file| file[:hash] == hash}
  return [404, "File not found"] if file_index.nil?

  unless files[file_index][:pass].nil?
    return [401, "Authentication required"] unless (files[file_index][:pass] == pass) || (@user[:id] == files[file_index][:user_id] || files[file_index][:pass].nil? || files[file_index][:pass] == "")
  end

  unless File.exists?("cowsay_stock/#{files[file_index][:hash]}.txt")
    files.delete_at(file_index)
    File.write(FILE_FILE, files.to_json)
    return [404, "File exist in record but not in stockage. Record deleted"]
  end

  send_file "cowsay_stock/#{files[file_index][:hash]}.txt"
  return 200
end

patch "/files/:hash" do
  authorized?
  return [401, "Authentication required"] if @user.nil?
  pass = request.body.read rescue nil
  hash = params["hash"] rescue ""
  return [400, "Error with new password"] if pass.nil?
  files = load_files
  file_index = files.find_index {|file| file[:hash] == hash}
  return [404, "File not found"] if file_index.nil?

  return [401, "Authentication required"] unless @user[:id] == files[file_index][:user_id]

  files[file_index][:pass] = pass
  File.write(FILE_FILE, files.to_json)

  return 204
end

delete "/files/:hash" do
  authorized?
  return [401, "Authentication required"] if @user.nil?
  hash = params["hash"] rescue ""
  files = load_files
  file_index = files.find_index {|file| file[:hash] == hash}
  return [404, "File not found"] if file_index.nil?

  return [401, "Authentication required"] unless @user[:id] == files[file_index][:user_id]

  File.delete("cowsay_stock/#{files[file_index][:hash]}.txt") if File.exists?("cowsay_stock/#{files[file_index][:hash]}.txt")

  files.delete_at(file_index)

  File.write(FILE_FILE, files.to_json)


  return 204
end

post "/files" do
  authorized?
  return [401, "Authentication required"] if @user.nil?
  pass = params["password"]
  options = JSON.parse(params["options"], {symbolize_names: true}) rescue {}

  cow_file = params["cow_talk_file"]
  return [400, "No file given"] if cow_file.nil? || cow_file["filename"].nil?
  return [400, "File is not a txt"] if cow_file["filename"][-4..-1] != ".txt"

  cow_shape = options[:cow_shape]
  cow_eyes = options[:cow_eyes]
  cow_talk = cow_file["tempfile"].read rescue ""
  files = load_files

  cow_shape = "-f " + cow_shape unless cow_shape.nil? || cow_shape == ""
  cow_shape = "" if cow_shape.nil?

  cow_talk = "" if cow_talk.nil?

  cow_eyes = "" if cow_talk.nil?

  hash = SecureRandom.alphanumeric(6)

  output = "cowsay_stock/#{hash}.txt"

  p cow_shape

  system("cowsay #{cow_eyes} #{cow_shape} '#{cow_talk}' > #{output}")
  # Eyes and tongue only compatible with normal cow (no shape)

  new_file = {
    "hash" => hash,
    "name" => cow_file['filename'],
    "timestamp" => DateTime.now().strftime("%F %T"),
    "private" => !(pass == "" || pass.nil?),
    "mine" => false,
    "user_id" => @user[:id],
    "pass" => pass
  }
  files << new_file

  File.write(FILE_FILE, files.to_json)

  return [201, {"Content-Location" => "/files/#{hash}"},File.read(output)]

end

get "/generate_users" do

    users = [{"id"=> 1,"name" => "Dylan","password" => sha256("123456")},
    {"id"=> 2,"name" => "Bob","password" => sha256("654321")},
    {"id"=> 3,"name" => "Average Franque","password" => sha256("uwu")}]

    File.write(USER_FILE, users.to_json)

    return 200
end