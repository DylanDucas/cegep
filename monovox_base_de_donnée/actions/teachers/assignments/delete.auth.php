<?php


$teacherId = get_session('user_id');

$assignmentId = get_param('assignment');

$delete = load_statement('11-assignment-delete', [
                            'assignment_id' => [ 'i' => $assignmentId],
                            'teacher_id' => [ 'i' => $teacherId]
                        ]);


$semester = get_param('semester');
$code = get_param('code');
$group = get_param('group');

if ($delete['success']) {
    $assignmentsUrl = "/pages/teachers/assignments?semester={$semester}&code={$code}&group={$group}";
    
    redirect_success($assignmentsUrl, 'Supprimé');
} else {
    $assignmentUrl = "/pages/teachers/assignment?assignment={$assignmentId}&semester={$semester}&code={$code}&group={$group}";

    redirect_error($assignmentUrl, $delete['result']);
}
