<?php

if (is_teacher()) {
    redirect('/actions/auth/home');
} else {
    $studentId = get_session('user_id');

    $semesters = load_select('12-student-semesters', [
                                 'student_id' => ['i' => $studentId]
                             ])['result'];
    

    $currentSemester = get_param('semester') ?? safe_array_get(safe_array_get($semesters, 0), 'identifier');
}

?>

<?php if (empty($semesters)): ?>

    <p>Aucunes notes...</p>

<?php else: ?>

    <div>
        <h2 style="display: inline-block;">Notes</h2>
        
        <form id="semesterForm" style="display: inline-block;">
            <select name="semester" onchange="document.querySelector('#semesterForm').submit();">
                <?php foreach($semesters as $semester): ?>
                    <option <?= e($semester['identifier'] == $currentSemester ? 'selected' : '') ?> >
                        <?= $semester['identifier'] ?>
                    </option>
                <?php endforeach; ?>
            </select>
        </form>
    </div>

    <?php
        $grades = load_select('13-student-semester-grades', [
                                  'student_id' => [ 'i' => $studentId],
                                  'semester' => [ 's' => $currentSemester]
                              ])['result'];
    ?>

    <?php if (empty($grades)): ?>

        <p>Aucunes notes pour cette session...</p>

    <?php else: ?>

        <table>
            <?php 
            $currentCode = null;
            
            foreach($grades as $grade): 
            ?>
                
                <?php if ($grade['code'] != $currentCode): 
                    $currentCode = $grade['code'];      
                ?>
                    <tr>
                        <td colspan="5">
                            <h3><?= $grade['code'] ?></h3>
                            <?= $grade['course_name']?>
                            -
                            <span style="font-style: italic;"><?= $grade['teacher_name']?></span>
                        </td>
                    </tr>
                <?php endif; ?>

                <tr>
                    <td><?= $grade['date'] ?></td>            
                    <td><?= $grade['name'] ?></td>            
                    <td><?= $grade['weight'] ?> %</td>
                    <td>
                        <?php if ($grade['grade']): ?>
                            <?= $grade['grade'] ?> / <?= $grade['points'] ?>,
                            <?= $grade['percent'] ?>%
                        <?php else: ?>
                            <b>N/A</b> / <?= $grade['points'] ?>
                        <?php endif; ?>
                    </td>  
                    <td>
                        <?php 
                            $hue = percent_color_scale($grade['average']);
                        ?>
                        <span style="font-weight: bold; color: hsl(<?= $hue ?>, 100%, 35%)">
                            <?= $grade['average'] ?>%
                        </span>
                    </td>            
                </tr>
            <?php endforeach; ?>
        </table>

    <?php endif; ?>
<?php endif; ?>
