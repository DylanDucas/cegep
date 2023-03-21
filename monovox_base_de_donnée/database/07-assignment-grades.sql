-- ENSEIGNANT NOTES /pages/teachers/grades
-- Listes des notes des etudiants pour un travail
--
-- Récupérer les notes du travail @assignment_id de l'enseignant @teacher_id
--
-- Trier par nom d'étudiant croissant
-- 
-- +------------+--------------+----------------+
-- | student_id | student_name | student_points |
-- +------------+--------------+----------------+
-- |      20201 | AAA          |           NULL |
-- |      20202 | BBB          |              3 |
-- |      20203 | CCC          |              5 |
-- |      20204 | DDD          |              2 |
-- |      20205 | EEE          |              9 |
-- |      20206 | FFF          |             10 |
-- |      20207 | GGG          |              7 |
-- |      20208 | HHH          |              8 |
-- |      20209 | III          |              2 |
-- |      20200 | JJJ          |              6 |
-- +------------+--------------+----------------+
--
SET @assignment_id = 1;
SET @teacher_id = 1;

SELECT 
    students.id AS "student_id",
    students.name AS "student_name",
    grades.points AS "student_points"
FROM groups
LEFT JOIN assignments ON group_course = course_code && group_number = number && group_semester = semester && assignments.id = @assignment_id
LEFT JOIN grades ON assignments.id = assignment_id
LEFT JOIN students ON student_id = students.id
WHERE teacher_employee_number = @teacher_id && students.id IS NOT NULL
ORDER BY students.name ASC;

