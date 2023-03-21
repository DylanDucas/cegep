<?php

$teacherId = get_session('user_id');

$semester = get_param('semester');
$code = get_param('code');
$group = get_param('group');

$course = load_select('04-assignments-course', [
                'teacher_id' => ['i' => $teacherId],
                'code' => ['s' => $code],
                'group' => ['i' => $group],
                'semester' => ['s' => $semester],
            ])['result'][0];

$assignments = load_select('05-course-assignments', [
                    'teacher_id' => ['i' => $teacherId],
                    'code' => ['s' => $code],
                    'group' => ['i' => $group],
                    'semester' => ['s' => $semester],
                ])['result'];
?>

<a href="/pages/teachers/groups?semester=<?= $semester ?>"> &lsaquo; Groupes</a>

<div>
    <h2 style="display: inline-block;">
        Travaux
    </h2>

    <a href="/pages/teachers/assignment?semester=<?= $semester ?>&code=<?= $code ?>&group=<?= $group ?>" style="font-style: italic; color: green;">Nouveau</a>
</div>

<?php if (empty($assignments)): ?>

    <p>Aucun travaux correspondant...</p>

<?php else: ?>


    <h3>
        <?= $code ?>,
        <span style="font-weight: lighter;"><?= $semester ?>, Groupe <?= $group ?></span>
    </h3>
    
    <p>
        <?= $course['name'] ?>,

        <?php 
            $hue = percent_color_scale_inverted($course['remaining_weight']);
        ?>
        <span style="font-weight: bold; color: hsl(<?= $hue ?>, 100%, 35%)">
            <?= $course['remaining_weight'] ?>%
        </span> restant
    </p>

    <table>
        <?php foreach($assignments as $assignment): ?>

            <tr>
                <td>
                    <a href="/pages/teachers/grades?assignment=<?= $assignment['id'] ?>&semester=<?= $semester ?>&code=<?= $code ?>&group=<?= $group ?>">
                    <?= $assignment['name']?></a>
                    <br>
                    <?= $assignment['date']?>
                </td>

                <td>
                    <span style="font-weight: bold;">
                        <?= $assignment['weight']?>%
                    </span>
                    <br>
                    <?= $assignment['points']?> points
                </td>

                <td>
                    <?php 
                        $hue = percent_color_scale($assignment['average']);
                        $lightness = $assignment['average'] ? 35 : 0;
                    ?>
                    <span style="font-weight: bold; color: hsl(<?= $hue ?>, 100%, <?= $lightness ?>%)">
                        <?= $assignment['average'] ?? 'N/A' ?>%
                    </span>
                    <br>
                    <?= $assignment['failed'] ?> échecs, 
                    <?= $assignment['filled'] ?> / <?= $assignment['total'] ?> saisies
                </td>
            </tr>

        <?php endforeach; ?>
    </table>

<?php endif; ?>
