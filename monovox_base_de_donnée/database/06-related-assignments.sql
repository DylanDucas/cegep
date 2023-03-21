-- ENSEIGNANT NOTES /pages/teachers/grades
-- Liste deroulante des autres travaux du groupe-cours
--
-- Récupérer les travaux de l'enseignant @teacher_id 
-- dans le même groupe-cours-session que le travail @assignment_id
-- Ajouter les colonnes
--      average qui calcule la moyenne des resultats pour ce travail en %
--      course est le nom du cours(sera toujours le même car on ne récupère que les travaux d'un seul cours)
--
-- Trier par date croissante
--
-- +----+-----------+--------+--------+---------+-----------------------------+
-- | id | name      | points | weight | average | course                      |
-- +----+-----------+--------+--------+---------+-----------------------------+
-- |  1 | TP 1      |     10 |     40 | 57.78   | Initiation à la profession  |
-- |  2 | Final     |    100 |     60 | 70.40   | Initiation à la profession  |
-- +----+-----------+--------+--------+---------+-----------------------------+
--
SET @assignment_id = 3;
SET @teacher_id = 1;

WITH the_assignment AS (
    SELECT *
    FROM assignments
    WHERE id = @assignment_id
)
SELECT
    assignments.id AS "id",
    assignments.name AS "name",
    assignments.points AS "points",
    assignments.weight AS "weight",
    FORMAT(AVG(grades.points / assignments.points * 100), 2) AS "average",
    courses.name AS "course"
FROM the_assignment
LEFT JOIN assignments ON assignments.group_semester = the_assignment.group_semester && assignments.group_number = the_assignment.group_number && assignments.group_course = the_assignment.group_course
LEFT JOIN grades ON assignment_id = assignments.id
LEFT JOIN groups ON assignments.group_semester = semester && assignments.group_number = number && assignments.group_course = course_code && teacher_employee_number = @teacher_id
LEFT JOIN courses ON code = course_code
WHERE assignments.group_semester = semester && assignments.group_number = number && assignments.group_course = course_code && teacher_employee_number
GROUP BY assignments.id;

