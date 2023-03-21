<?php

$teacherId = get_session('user_id');

$assignmentId = get_param('assignment');
$semester = get_param('semester');
$code = get_param('code');
$group = get_param('group');

$name = get_param('name');
$weight = get_param('weight');
$points = get_param('points');
$date = get_param('date');

$update = load_statement('10-assignment-update', [
                            'name' => [ 's' => $name],
                            'weight' => [ 'i' => $weight],
                            'points' => [ 'i' => $points],
                            'date' => [ 's' => $date],
                            'assignment_id' => [ 'i' => $assignmentId],
                            'teacher_id' => [ 'i' => $teacherId]
                        ]);

$assignmentUrl = "/pages/teachers/assignment?assignment={$assignmentId}&semester={$semester}&code={$code}&group={$group}";

if ($update['success']) {
    redirect_success($assignmentUrl, 'Sauvegardé');
} else {
    redirect_error($assignmentUrl, $update['result']);
}
