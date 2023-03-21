<?php

define('CONFIG', include('config.php'));

function server_setup() {
    ini_set('display_errors', 'Off');   // Do not show errors on HTML page
    ini_set("log_errors", 1);           // But log them to console
    ini_set("session.use_strict_mode", 1);


    session_start();    
}

function server_teardown() {
    set_session('session_flash', NULL);
}

function d($value) {
    var_dump($value);
}

function dd($value) {
    d($value);
    die;
}

function e($value) {
    echo($value);
}

function ed($value) {
    e($value);
    die;
}

function p($format, ...$value) {
    printf($format, ...$value);
}

function error_message() {
    $flash = get_flash('error');

    if ($flash && get_config('DEBUG')) {
        echo("<div class='error-flash'>$flash</div>");
    }
}

function safe_array_get($array, $key) {
    return (is_array($array) && array_key_exists($key, $array)) ? $array[$key] : NULL;
}

function get_config($key) {
    return safe_array_get(CONFIG, $key);
}

function request_uri() {
    $uri = explode('?', $_SERVER["REQUEST_URI"])[0];

    return get_config($uri) ?? $uri;
}

function params() {
    return ($_GET + $_POST); // Use + so array is not reindexed VS array_merge
}

function get_param($key) {
    return safe_array_get(params(), $key);
}

function redirect($url) {
    header("Location: $url");
    exit;
}

function redirect_error($url, $message) {
    set_flash('redirect', ['message' => $message, 'isError' => true]);
    redirect($url);
}

function redirect_success($url, $message) {
    set_flash('redirect', ['message' => $message, 'isError' => false]);
    redirect($url);
}

function redirect_message() {
    $flash = get_flash('redirect');

    if ($flash) {
        $message = $flash['message'];
        $backgroundColor = $flash['isError']? 'lightpink' : 'lightgreen';

        echo("<div style='background-color: $backgroundColor;  margin: 8px 0px; padding: 8px; text-align: center;'>$message</div>");
    }
}

function get_session($key) {
    return safe_array_get($_SESSION, $key);
}

function set_session($key, $value) {
    $_SESSION[$key] = $value;
}

function get_flash($key) {
    return safe_array_get(safe_array_get($_SESSION, 'session_flash'), $key);
}

function set_flash($key, $value) {
    return $_SESSION['session_flash'][$key] = $value;
}