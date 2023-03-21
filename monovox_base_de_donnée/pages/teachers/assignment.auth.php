<?php

$teacherId = get_session('user_id');

$assignmentId = get_param('assignment');

$semester = get_param('semester');
$code = get_param('code');
$group = get_param('group');

$assignment = load_select('08-assignment-details', [
                            'group' => ['i' => $group],
                            'semester' => ['s' => $semester],
                            'code' => ['s' => $code],
                            'teacher_id' => ['i' => $teacherId],
                            'assignment_id' => ['i' => $assignmentId]
                        ])['result'];

$assignment = safe_array_get($assignment, 0);
?>

<?php if (empty($assignmentId)): ?>
    <a href="/pages/teachers/assignments?semester=<?= $semester ?>&code=<?= $code ?>&group=<?= $group ?>"> &lsaquo; Travaux</a>
<?php else: ?>
    <a href="/pages/teachers/grades?assignment=<?= $assignment['id'] ?>&semester=<?= $semester ?>&code=<?= $code ?>&group=<?= $group ?>"> &lsaquo; Notes, <?= $assignment['name'] ?></a>
<?php endif; ?>

<?php if ((!empty($assignmentId) && empty($assignment['id']))): ?>

    <p>Aucun travail correspondant...</p>

<?php else: ?>
    
    <h2>Détails du travail</h2>

    <h3>
        <?= $code ?>,
        <span style="font-weight: lighter;"><?= $semester ?>, Groupe <?= $group ?></span>
    </h3>
    
    <p>
        <?php 
            $hue = percent_color_scale_inverted($assignment['remaining_weight']);
        ?>
        <span style="font-weight: bold; color: hsl(<?= $hue ?>, 100%, 35%)">
            <?= $assignment['remaining_weight'] ?>%
        </span> restant
    </p>

    <?php redirect_message() ?>

    <?php
        if (!empty($assignmentId)) {
            // update
            $action = "/actions/teachers/assignments/update?assignment={$assignment['id']}&semester={$semester}&code={$code}&group={$group}";
        } else {
            // insert
            $action = "/actions/teachers/assignments/insert?semester={$semester}&code={$code}&group={$group}";
        }
    ?>
    <form action="<?= $action ?>" method="POST">

        <div style="display: flex;">
            <div style="flex: 1; padding-right: 8px;">
                <label>
                    Nom
                    <input name="name" type="text" value="<?= $assignment['name'] ?? get_flash('inputs')['name'] ?>">
                </label>
            </div>

            <div style="flex: 1; padding-left: 8px;">
                <label>
                    Date
                    <input name="date" type="date" value="<?= ($assignment['date'] ?? get_flash('inputs')['date']) ?>">
                </label>
            </div>
        </div>

        <div style="display: flex;">
            <div style="flex: 1; padding-right: 8px;">
                <label>
                    Poids, <span id="weight"><?= ($assignment['weight'] ?? get_flash('inputs')['weight']) ?? 0 ?></span>%
                    <input  name="weight"
                            type="range" min="0" max="100" value="<?= ($assignment['weight'] ?? get_flash('inputs')['weight']) ?? 0 ?>"
                            style="display: block; width: 100%; margin-top: 10px;"
                            oninput="document.querySelector('#weight').innerHTML = this.value;">
                </label>
            </div>

            <div style="flex: 1; padding-left: 8px;">
                <label>
                    Points
                    <input  name="points" type="number" value="<?= ($assignment['points'] ?? get_flash('inputs')['points']) ?? 0 ?>">
                </label>
            </div>
        </div>

        <button type="reset" style="margin-right: 16px;">Annuler</button>

        <button type="submit" style="color: green;">Sauvegarder</button>

        <?php if (!empty($assignmentId)): ?>
            <a  href="/actions/teachers/assignments/delete?assignment=<?= $assignment['id'] ?>&semester=<?= $semester ?>&code=<?= $code ?>&group=<?= $group ?>" 
                style="color: red; float: right; margin-top: 6px;"
                onclick="if (!confirm('Supprimer le travail: <?= $assignment['name'] ?>?')) { event.preventDefault(); }; ">Supprimer</a>
        <?php endif; ?>

    </form>

<?php endif; ?>
