require "faraday"
require "faraday/multipart"

server = Faraday.new("http://localhost:4567") do |f|
  f.request :multipart
end

puts "get / ---------------------------------------------------------------------------------------------"

response = server.get("/") 

response_header = response.headers

puts response.status

puts response.body

puts "get /files ---------------------------------------------------------------------------------------------"

response = server.get("/files") 

response_header = response.headers

puts response.status

puts response.body

puts "get /files ---------------------------------------------------------------------------------------------"

response = server.get("/files/eXempl") 

response_header = response.headers

puts response.status

puts response.body

response = server.get("/files/SomebodyOnceToldMe") 

response_header = response.headers

puts response.status

puts response.body

puts "get /login ---------------------------------------------------------------------------------------------"

response = server.get("/login", nil, {"Authorization" => "Basic #{Base64.encode64("Dylan:123456")}"}) 

response_header = response.headers

puts response.status

puts response_header["Location"]

puts response.body

response = server.get("/login", nil, {"Authorization" => "Basic #{Base64.encode64("NeverGonna:GiveYouUp")}"}) 

response_header = response.headers

puts response.status

puts response_header["Location"]

puts response.body

puts "post /files/...hash...---------------------------------------------------------------------------------------------"

data = {
  password: "pwdaUWU",
  cow_talk_file: Faraday::Multipart::FilePart.new("postExemple.txt", "text/plain"),
  options: {"cow_shape" => "fox","cow_eyes" => "-t"}.to_json
}

response = server.post("/files", data, {"Authorization" => "Basic #{Base64.encode64("Dylan:123456")}"}) 

response_header = response.headers

puts response.status

puts response_header["Content-Location"]

puts response.body

hash = response_header["Content-Location"][-6..-1]

data = {
  password: "pwdaUWU",
  cow_talk_file: Faraday::Multipart::FilePart.new("postExemple", "text/plain"),
  options: {"cow_shape" => "fox","cow_eyes" => "-t"}.to_json
}

response = server.post("/files", data, {"Authorization" => "Basic #{Base64.encode64("Dylan:123456")}"}) 

response_header = response.headers

puts response.status

puts response_header["Content-Location"]

puts response.body

puts "patch files/...hash... ---------------------------------------------------------------------------------------------"

response = server.patch("/files/#{hash}", "soleil123", {"Authorization" => "Basic #{Base64.encode64("Dylan:123456")}"}) 

response_header = response.headers

puts response.status

puts response.body

response = server.patch("/files/#{hash}", "soleil123", {"Authorization" => "Basic #{Base64.encode64("𓁹‿𓁹:123456")}"}) 

response_header = response.headers

puts response.status

puts response.body

puts "delete files/...hash... ---------------------------------------------------------------------------------------------"

response = server.delete("/files/#{hash}", nil, {"Authorization" => "Basic #{Base64.encode64("Dylan:123456")}"}) 

response_header = response.headers

puts response.status

puts response.body

response = server.delete("/files/#{hash}", nil, {"Authorization" => "Basic #{Base64.encode64("Dylan:123456")}"}) 

response_header = response.headers

puts response.status

puts response.body