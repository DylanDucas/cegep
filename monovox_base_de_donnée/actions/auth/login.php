<?php

$username = get_param('username');
$password = get_param('password');
$isTeacher = get_param('teacher') != null;

$table = $isTeacher ? 'teachers' : 'students';
$usernameColumn = $isTeacher ? 'employee_number' : 'id';

$response = load_select("01-login-$table", [
                            'id' => ['i' => $username],
                            'pass' => ['s' => $password]
                        ]);

if ($response['success'] && count($response['result']) == 1) {
    $user = $response['result'][0];
    
    set_session('user_id', $user[$usernameColumn]);
    set_session('user_name', $user['name']);
    set_session('user_teacher', $isTeacher);

    redirect('/actions/auth/home');
} else {
    redirect_error('/pages/login', 'Invalid credentials!');
}
