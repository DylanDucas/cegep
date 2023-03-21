-- ENSEIGNANT SUPPRESSION TRAVAIL
--
-- Supprimer le travail identifié par @assignment_id et appartenant à l'enseignant @teacher_id
--
SET @assignment_id = 1;
SET @teacher_id = 1;


DELETE assign.* FROM assignments AS assign
LEFT JOIN groups AS gro ON group_course = course_code && group_number = number && group_semester = semester
WHERE assign.id = @assignment_id && teacher_employee_number = @teacher_id;