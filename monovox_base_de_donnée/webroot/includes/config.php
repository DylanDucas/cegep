<?php

return [
    'DEBUG' => true,
    
    //
    // WARNING
    // Make sure you don't commit/share private database credentials
    //
    'DB_HOST' => 'localhost',
    'DB_USER' => 'tux',
    'DB_PASSWORD' => 'freeandopensource',
    'DB_NAME' => 'monovox',
    'DB_PORT' => 3306,

    '/' => '/pages/login', 
    // Default file for url /

    'auth' => '/pages/login',
    // Redirect destination when authentication is required
    // applies to pages ending with .auth.php 	
     
    'already_auth' => '/actions/auth/home',  
    // Redirect destination when already logged in, 
    // applies to pages ending with .auth-redirect.php
];
