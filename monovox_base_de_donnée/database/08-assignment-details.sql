-- ENSEIGNANT TRAVAIL /pages/teachers/assignment
-- Affiche les details d'un travail, si existant, ET le pourcentage restant
--
-- Récupérer le travail @assignment_id s'il appartient à l'enseignant @teacher_id
--      Ajouter la colonne remaining_weight qui calcule 
--      le poids restant à allouer sur 100 pour ce @group, durant la session @semester, du cours @code
--
-- ATTENTION cette requete est utilisée pour afficher le poids restant lors de la CRÉATION d'un travail
-- donc il faut gérer la situation où le @assignment_id est null également
--
-- +------------+-------+----------+------+------+--------+--------+------------+------------------+
-- | code       | group | semester | id   | name | weight | points | date       | remaining_weight |
-- +------------+-------+----------+------+------+--------+--------+------------+------------------+
-- | 420-0Q4-SW |     1 | A2020    |    1 | TP 1 |     40 |     10 | 2020-10-01 |                0 |
-- +------------+-------+----------+------+------+--------+--------+------------+------------------+
--
SET @group = 1;
SET @code = "420-0Q4-SW";
SET @semester = "A2020";
SET @assignment_id = null;
SET @teacher_id = 1;

WITH weight_left AS (
    SELECT
        100 - SUM(weight) AS this
    FROM assignments
    WHERE group_course = @code && group_semester = @semester && group_number = @group
)
SELECT
    @code AS "code",
    @group AS "group",
    @semester AS "semester",
    assignments.id AS "id",
    assignments.name AS "name",
    weight,
    points,
    date,
    weight_left.this AS "remaining_weight"
FROM groups
CROSS JOIN weight_left
LEFT JOIN assignments ON group_course = course_code && group_semester = semester && group_number = number && assignments.id = @assignment_id
WHERE @assignment_id IS NULL || assignments.id IS NOT NULL
LIMIT 1;


