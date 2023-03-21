<?php
// Put global variables and functions here

function auth_valid() {
    // Return a boolean: true if user is logged in, false otherwise
    // Applied to pages ending with .auth.php and .auth-redirect.php
    return get_session('user_id');
}

function is_teacher() {
    return get_session('user_teacher');
}

function percent_color_scale($percent) {
    // Create 3 color steps: 0 = Red, 31 = Orange, 62 = Yellow, 93 = Green 
    return ((int)( $percent / 33.3)) * 31;
}

function percent_color_scale_inverted($percent) {
    return 93 - percent_color_scale($percent);
}