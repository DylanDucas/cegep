<?php

include("includes/server.php");
server_setup();

include("includes/mariadb.php");
include("includes/helpers.php");

$uri = request_uri();

$path = pathinfo($uri);
$assetPath = dirname(__FILE__) . $uri;

if (safe_array_get($path, 'extension') && file_exists($assetPath)) {
    header("Content-Type: "); // HACK so the browser automatically select mime type
    readfile($assetPath);
} else {
    $parentFolder = dirname(__DIR__ , 1);
    $path = "${parentFolder}${uri}.php";
    $pathAuth = "${parentFolder}${uri}.auth.php";
    $pathAuthRedirect = "${parentFolder}${uri}.auth-redirect.php";

    if (file_exists($pathAuth)) {
        if ( ! auth_valid()) {
            redirect_error(get_config('auth'), 'Authentication required!');
        } else {
            $path = $pathAuth;
        }
    } else if (file_exists($pathAuthRedirect)) {
        if (auth_valid()) {
            redirect(get_config('already_auth'));
        } else {
            $path = $pathAuthRedirect;
        }
    }

    if ( ! (strpos($uri, '/actions/') === 0)) {
        include("includes/header.php");
    }

    if (file_exists($path)) {
        include($path);
    } else {
        include("includes/404.php");
    }
    if ( ! (strpos($uri, '/actions/') === 0)) {
        include("includes/footer.php");
    }
}

server_teardown();