-- ENSEIGNANT TRAVAUX /pages/teachers/assignments
-- En-tete affichant le nom du cours et pourcentage restant
--
-- Récupérer le cours identifié par le @group, durant la session @semester, du cours @code par l'enseignant @teacher_id
--      Ajouter la colonne remaining_weight qui calcule le poids restant à allouer sur 100 pour les travaux
--
-- +-----------------------------+------------------+
-- | name                        | remaining_weight |
-- +-----------------------------+------------------+
-- | Initiation à la profession  |                0 |
-- +-----------------------------+------------------+
--
SET @semester = 'A2021';
SET @group = 1;
SET @code = '420-0Q4-SW';
SET @teacher_id = 1;

SELECT courses.name,
    100 - SUM(weight) AS 'remaining_weight'
FROM courses
LEFT JOIN groups ON courses.code = course_code
LEFT JOIN assignments ON group_semester = semester && group_course = course_code && number = group_number
WHERE semester = @semester && number = @group && @teacher_id = teacher_employee_number && course_code = @code
GROUP BY courses.name;

