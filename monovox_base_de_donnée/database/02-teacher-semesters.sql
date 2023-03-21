-- ENSEIGNANT GROUPES /pages/teachers/groups
-- Liste déroulante des sessions
--
-- Récupérer les sessions associées à l'enseignant @teacher_id
--
-- Trier en ordre decroissant
--
-- +------------+
-- | identifier |
-- +------------+
-- | H2021      |
-- | A2021      |
-- | A2020      |
-- +------------+
--
SET @teacher_id = 1;

SELECT DISTINCT semester AS 'identifier'
FROM groups
WHERE teacher_employee_number = @teacher_id
ORDER BY semester DESC;
