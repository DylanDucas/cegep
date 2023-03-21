-- ENSEIGNANT GROUPES /pages/teachers/groups
-- Liste des groupes pour une session de l'enseignant
--
-- Récupérer les groupes de l'enseignant @teacher_id pour la session @semester
--      Ajouter la colonne students qui indique le nombre d'étudiants du groupe
--
-- Trier par code et number croissant
--
-- +--------+------------+-----------------------------+----------+
-- | number | code       | name                        | students |
-- +--------+------------+-----------------------------+----------+
-- |      1 | 420-0Q4-SW | Initiation à la profession  |       11 |
-- |      2 | 420-0SU-SW | Web Client 1                |        0 |
-- +--------+------------+-----------------------------+----------+
--
SET @teacher_id = 1;
SET @semester = 'A2021';

SELECT number,
    course_code AS 'code',
    courses.name AS 'name',
    COUNT(classes.student_id) AS 'students'
FROM groups
LEFT JOIN courses ON code = course_code
LEFT JOIN classes ON course_code = group_course && group_semester = semester
WHERE @teacher_id = teacher_employee_number AND @semester = semester
GROUP BY course_code;
