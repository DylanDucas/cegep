<?php

$teacherId = get_session('user_id');

$semesters = load_select('02-teacher-semesters' , [
                            'teacher_id' => ['i' => $teacherId]
                        ])['result'];

$currentSemester = get_param('semester') ?? safe_array_get(safe_array_get($semesters, 0), 'identifier');

$groups = load_select('03-teacher-semester-groups' , [
                        'teacher_id' => ['i' => $teacherId],
                        'semester' => ['s' => $currentSemester],
                      ])['result'];
?>

<?php if (empty($groups)): ?>

    <p>Aucuns groupes...</p>

<?php else: ?>

<div>
    <h2 style="display: inline-block;">Groupes</h2>
    
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

    <table>
        <?php 
        $currentCode = null;

        foreach($groups as $group): 
        ?>
            <?php if ($group['code'] != $currentCode): 
                $currentCode = $group['code'];      
                
            ?>
                <tr>
                    <td colspan="5" style="padding: 16px 0px;">
                        <h3><?= $group['code'] ?></h3>
                        <?= $group['name']?>
                    </td>
                </tr>
            <?php endif; ?>

            <tr>
                <td>
                    <a href="/pages/teachers/assignments?semester=<?= $currentSemester ?>&code=<?= $group['code'] ?>&group=<?= $group['number'] ?>">
                        Groupe <?= $group['number']?></a>,

                    <?= $group['students']?> étudiants
                </td>
            </tr>

        <?php endforeach; ?>
    </table>

<?php endif; ?>
