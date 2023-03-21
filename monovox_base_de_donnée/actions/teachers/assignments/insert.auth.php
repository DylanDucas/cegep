<?php

$teacherId = get_session('user_id');

$semester = get_param('semester');
$code = get_param('code');
$group = get_param('group');

$name = get_param('name');
$weight = get_param('weight');
$points = get_param('points');
$date = get_param('date');

$insert = load_select('09-assignment-insert', [
                            'name' => [ 's' => $name],
                            'weight' => [ 'i' => $weight],
                            'points' => [ 'i' => $points],
                            'date' => [ 's' => $date],
                            'group' => [ 'i' => $group],
                            'semester' => [ 's' => $semester],
                            'code' => [ 's' => $code],
                            'teacher_id' => [ 'i' => $teacherId]
                        ]);

if ($insert['success'] && count($insert['result'] ?? []) == 1) {
    $assignmentsUrl = "/pages/teachers/grades?assignment={$insert['result'][0]['id']}&semester={$semester}&code={$code}&group={$group}";

    redirect_success($assignmentsUrl, 'Sauvegardé');
} else if ($insert['result'] != null) {
    $assignmentUrl = "/pages/teachers/assignment?semester={$semester}&code={$code}&group={$group}";

    set_flash('inputs', compact('name', 'weight', 'points', 'date'));

    redirect_error($assignmentUrl, empty($insert['result']) ? 'La sauvegarde à échouée' : $insert['result']);
}
