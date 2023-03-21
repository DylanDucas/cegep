-- ETUDIANT NOTES
-- Liste deroulante des sessions
--
-- Récupérer les sessions pour lesquelles l'etudiant @student_id a suivi des cours
--
-- Trier en ordre décroissant
--
-- +------------+
-- | identifier |
-- +------------+
-- | A2021      |
-- | A2020      |
-- +------------+
--
SET @student_id = 20201;

SELECT DISTINCT group_semester AS "identifier"
FROM classes
WHERE student_id = @student_id
ORDER BY group_semester DESC;
