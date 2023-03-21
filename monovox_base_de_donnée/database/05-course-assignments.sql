-- ENSEIGNANT TRAVAUX /pages/teachers/assignments
-- Liste des travaux et statistiques
--
-- Récupérer les travaux du groupe @group pour le cours @code durant la session @semester
-- de l'enseignant @teacher_id
-- Ajouter les colonnes pour chaque travail
--      average calcule les moyenne des notes en % 
--      failed indique le nombre de notes en échec(< 60%)
--      filled indique le nombre de notes saisies(pas NULL) 
--      total indique le nombre total de notes saisies ou non
--
-- Trier par date croissante
--
-- +----+-----------+--------+--------+------------+---------+--------+--------+-------+
-- | id | name      | weight | points | date       | average | failed | filled | total |
-- +----+-----------+--------+--------+------------+---------+--------+--------+-------+
-- |  1 | TP 1      |     40 |     10 | 2020-10-01 | 57.78   |      4 |      9 |    10 |
-- |  3 | Formatif  |      0 |      0 | 2020-11-03 | NULL    |      0 |      0 |     0 |
-- |  2 | Final     |     60 |    100 | 2020-12-11 | 70.40   |      3 |     10 |    10 |
-- +----+-----------+--------+--------+------------+---------+--------+--------+-------+
--
SET @semester = "A2020";
SET @group = 1;
SET @code = '420-0Q4-SW';
SET @teacher_id = 1;

SELECT id,
    name,
    weight,
    assignments.points,
    date,
    FORMAT(AVG(grades.points / assignments.points * 100),2) AS 'average',
    COUNT(if((grades.points / assignments.points * 100) < 60,1,NULL)) AS 'failed',
    COUNT(grades.points) AS 'filled',
    COUNT(grades.student_id) AS 'total'
FROM assignments LEFT JOIN grades ON assignments.id = assignment_id
LEFT JOIN groups ON group_semester = semester && group_course = course_code && number = group_number
WHERE group_semester = @semester && @group = group_number && @code = group_course && teacher_employee_number = @teacher_id
GROUP BY assignments.id;
