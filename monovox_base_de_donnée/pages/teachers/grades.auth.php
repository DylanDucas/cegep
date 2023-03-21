<?php

$teacherId = get_session('user_id');

$assignmentId = get_param('assignment');

$assignments = load_select('06-related-assignments', [
                    'assignment_id' => ['i' => $assignmentId], 
                    'teacher_id' => ['i' => $teacherId]
                ])['result'];

$currentAssignmentId = get_param('assignment') ?? safe_array_get(safe_array_get($assignments, 0), 'id');

$grades = load_select('07-assignment-grades', [
                'assignment_id' => ['i' => $assignmentId], 
                'teacher_id' => ['i' => $teacherId]
            ])['result'];
?>

<a href="/pages/teachers/assignments?semester=<?= get_param('semester') ?>&code=<?= get_param('code') ?>&group=<?= get_param('group') ?>"> &lsaquo; Travaux</a>


<?php if (empty($grades)): ?>
    
    <p>Aucunes notes correspondant...</p>
    
<?php else: ?>
    <?php redirect_message() ?>

    <div>
        <h2 style="display: inline-block;">Notes</h2>
        
        <form id="assignmentForm" style="display: inline-block;">
            <select name="assignment" onchange="document.querySelector('#assignmentForm').submit();">
                <?php foreach($assignments as $assignment): 
                    $selectedAttribute = '';

                    if ($assignment['id'] == $currentAssignmentId) {
                        $currentAssignment = $assignment;
                        $selectedAttribute = 'selected';
                    }
                ?>
                    
                    <option value="<?= $assignment['id'] ?>" <?= $selectedAttribute ?> >
                        <?= $assignment['name'] ?>
                    </option>
                <?php endforeach; ?>
            </select>

            <input type="hidden" name="semester" value="<?= get_param('semester') ?>">
            <input type="hidden" name="code" value="<?= get_param('code') ?>">
            <input type="hidden" name="group" value="<?= get_param('group') ?>">
        </form>

        <a href="/pages/teachers/assignment?assignment=<?= $currentAssignment['id'] ?>&semester=<?= get_param('semester') ?>&code=<?= get_param('code') ?>&group=<?= get_param('group') ?>" style="font-style: italic; color: orange;">Modifier le travail</a>

    </div>

    <div>
        <h3 style="margin-top: 0px;">
            <?= $currentAssignment['course'] ?>
            <br>
            <div style="font-weight: lighter;">
                <?= get_param('code') ?>,
                <?= get_param('semester') ?>
            </div>
        </h3>
    </div>

    <div style="width: fit-content; margin-top: 16px;">
        <table style="width: auto;">

            <tr>
                <td style="border-right: 0;"></td>
                <td style="text-align: center;">
                    <?php 
                        $hue = percent_color_scale($currentAssignment['average']);
                    ?>
                    <span style="font-weight: bold; color: hsl(<?= $hue ?>, 100%, 35%)">
                        <?= $currentAssignment['average'] ?>%
                    </span>

                    <p>
                        / <?= $currentAssignment['points'] ?>
                    </p>
                </td>
            </tr>

            <?php foreach($grades as $grade): ?>
                <tr>
                    <td style="vertical-align: middle;">
                        <?= $grade['student_name']?>
                    </td>
    
                    <td>
                        <input form="gradesForm" type="number" name="<?= $grade['student_id']?>" value="<?= $grade['student_points']?>" min="0">
                    </td>
                </tr>    
            <?php endforeach; ?>

            <tr>
                <td style="border: 0;"></td>
                <td style="text-align: center;  padding-top: 16px; border: 0;">
                    <form action="/actions/teachers/grades/save" id="gradesForm" method="POST">
                        <input type="hidden" name="assignment" value="<?= $assignmentId ?>">
                        
                        <input type="hidden" name="semester" value="<?= get_param('semester') ?>">
                        <input type="hidden" name="code" value="<?= get_param('code') ?>">
                        <input type="hidden" name="group" value="<?= get_param('group') ?>">
                        
                        <button type="submit">Sauvegarder</button>
                    </form>
                </td>
            </tr>
        </table>
    </div>
<?php endif; ?>
