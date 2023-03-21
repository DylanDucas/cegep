<?php

$teacherId = get_session('user_id');

$params = params();

$assignmentId = $params['assignment'];
$semester = $params['semester'];
$code = $params['code'];
$group = $params['group'];

unset($params['assignment']);
unset($params['semester']);
unset($params['code']);
unset($params['group']);

$values = '';
$bindings = [];
foreach($params as $studentId => $points) {
    $separator = $values ? ' UNION' : '';

    $values .= "$separator SELECT ? AS `assignment_id`, ? AS `student_id`, ? AS `points`";
    array_push($bindings, ['i' => $assignmentId], ['i' => $studentId], ['i' => ($points == '' ? NULL : $points)]);
}

array_push($bindings, ['i' => $teacherId]);

// https://mariadb.com/kb/en/insert-on-duplicate-key-update/
// https://mariadb.com/kb/en/values-value/
$dupsert = sql_statement("INSERT INTO grades (assignment_id, student_id, points)
                            SELECT *
                            FROM ({$values}) AS GradesData 
                            WHERE GradesData.assignment_id IN ( SELECT id 
                                                                FROM assignments 
                                                                INNER JOIN groups ON group_semester = semester 
                                                                                     && group_number = number 
                                                                                     && group_course = course_code
                                                                                     && teacher_employee_number = ?)
                          ON DUPLICATE KEY UPDATE points = VALUE(points);", $bindings);


$gradesUrl = "/pages/teachers/grades?assignment={$assignmentId}&semester={$semester}&code={$code}&group={$group}";

if ($dupsert['success']) {
    redirect_success($gradesUrl, 'Sauvegardé!');
} else {
    redirect_error($gradesUrl, $dupsert['result']);
}