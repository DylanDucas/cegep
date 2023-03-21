# MariaPHP

A micro PHP framework to build web apps with a MySQL/MariaDB database. Use at your own risk  on the world wide web.

- File-based routing
- Session/auth
- Database queries

## Starting a projet

Simply download sources and make yourself at home

- https://bitbucket.org/jameshoffman/mariaphp/downloads/

Or setup and git repo with allow to easily fetch updates

```
git init my-project
```

Then get framework's code 
```
git pull https://jameshoffman@bitbucket.org/jameshoffman/mariaphp.git --allow-unrelated-histories
```
Use the same command to fetch updated framework's code. Make sure to review potential conflicts when merging.

## Project structure

```bash
├── _assets # Static assets here: css, js, images, etc.
│   │
│   └── style.css
│
├── actions # PHP files to do application logic only, do NOT render HTML. ex: form action
│   │
│   └── _helpers.php # Put global variables and functions here
│
├── pages   # PHP files doing HTML rendering
│   │
│   └── home.php # Example page, open http://localhost:8080/pages/home
│
├── webroot
│   ├── assets    # ../_assets is symlinked here
│   │
│   ├── includes  # Framework's helpers
│   │   │
│   │   ├── 404.php     # File render when an URL does not references a valid file
│   │   │
│   │   ├── config.php  # ../../CONFIG.php is symlinked here
│   │   │
│   │   ├── footer.php  # HTML body tag close
│   │   │
│   │   ├── header.php  # HTML head/body open
│   │   │
│   │   ├── helpers.php # ../../actions/_helpers.php is symlinked here
│   │   │
│   │   ├── mariadb.php # Framework's database helper
│   │   │
│   │   └── server.php  # Framework's http/web helper
│   │
│   └── index.php # Entry point, Framework's routing helper
│
├── CONFIG.php # Configuration variables: Database credentials, Redirects
│
└── README.md  # This file
```

## Getting started

- Do NOT modify files/folders hierarchy, except within `_assets/`, `actions/` and `pages/`
- Set configuration variables in `CONFIG.php`
- Static assets(images, css, js, etc.) must be in the `_assets` folder. They are accessed from the URL `/assets/...`
- Create `.php` files in the *pages* and *actions* folders
  - *pages* should be files that render HTML
  - *actions* should be files that provide application logic
  - You can also organize files in subfolders within these directories
  - The URL `/{ pages | actions }/[ subfolder, ... ]/{filename}`, ex: `/pages/login` will references the file `/pages/login.php`
- `webroot/includes/` contains `header.php` and `footer.php` to build the pages' HTML structure. It can be useful to edit these file to add items that repeats on every page footer/header.
- `actions/_helpers` allows to declare global variables and functions

## Session

A session is a datastore created for every browser connecting to the app. The session is valid until the user closes the browser window. A session is useful to keep data between pages refresh or redirect.

```php
// Storing data in the Session
set_session('key', 'value');
set_session('request_timestamp', time());

// Read from Session
get_session('key'); // Returns NULL if 'key' does not exists
get_session('request_time');
```

**Flash**

A flash is a special kind of data can be stored which is valid only for the current request cycle. Once the response is sent to the browser, the flash is cleared. It's useful to store data contextual to the current request, for example, an error message to display on a redirected page.

```php
// Storing data in the Flash
set_flash('key', 'value');
set_flash('error_message', 'Invalid username/password!');

// Read from Flash
get_flash('key'); // Returns NULL if 'key' does not exists
get_flash('error_message');
```

## Authentication

The function `auth_valid()` in `/actions/_helpers.php` returns a boolean indicating if a user is currently authenticated. For example, you could store the username in the Session upon login, then `return get_session('username');` in the function.

To identify **privileged pages** of the app, insert `.auth` in the filename, ex: `profile.auth.php`. If auth_valid() returns false when accessing the page, the user will be redirected to the URL provided in CONFIG.php

If a page should not be available **when already authenticated**, such as login or sign up, you can insert `.auth-redirect` in the filename ex: `login.auth-redirect.php`, the user will be redirected to the URL provided in CONFIG.php

If a page should be accessed wether auth is valid or not, don't add anything to filename, ex: `about.php`.

## SQL Queries helpers

2 utility functions are available to run SQL queries: `sql_statement()` and `sql_select()`. Use statement when you don't need the query results set, otherwise use select.

```php
sql_statement("INSERT INTO users VALUES (DEFAULT, 'dave');");

sql_select("DELETE FROM users WHERE id = 1 RETURNING name;");
sql_select("SELECT * FROM users;");
```

No matter which function you use, the return value format is the following

```
[
  'success' => boolean,
  'result'  => string | []
]
```

`success` will be *false* if there is an error running the query and `result` will contain a the error string(syntax or constraints/pk/fk error).

When `success` is true and select was used, result will contain an array of all rows, ex:

```
[
  'success' => true,
  'result'  => [
    ['id' => 1, 'name' => 'alice'],
    ['id' => 2, 'name' => 'bob'],
    ['id' => 3, 'name' => 'charlie']
  ]
]
```

When you need to customize a query with parameters from PHP, you should use *parameterized queries* allowing to embed PHP variables in a query without being vulnerable to SQL injections.

```php
$firstname = get_param('firstname');
$lastname = get_param('lastname');
$age = get_param('age');

sql_statement("INSERT INTO users VALUES (DEFAULT, ?, ?, ?);", [
  ['s' => $firstname], 
  ['s' => $lastname], 
  ['i' => $age]
]);
```

You must specify the type of each parameter using

- `i` for integer
- `d` for double floating point
- `s` for string

Then in the query every question mark `?` will be replaced with the corresponding item in the array. It's important to use a nested array to allow duplicated values for the types.


## Server helpers

Only redirect from actions/...


## Dev server

Start local PHP server
```
php -S localhost:8080 webroot/index.php
```

If you want auto-reload with [browser-sync](https://browsersync.io/), also run
```
browser-sync start --proxy "localhost:8080" --files "**/*"
```

## Prod server

Set Apache DocumentRoot to `webroot`