-- ENSEIGNANT EDITION TRAVAIL
--
-- Mettre à jour le travail @assignment_id enseigné par @teacher_id 
-- avec les données @name, @weight, @points, @date 
--
-- Pour s'assurer que l'enseignant est bien responsable du cours
-- La syntaxe pour plusieurs table du UPDATE peut être utilisée plutôt qu'une sous-requête
-- https://mariadb.com/kb/en/update/
-- https://www.mysqltutorial.org/mysql-update-join/
--
SET @name = "test";
SET @weight = 3;
SET @points = 3;
SET @date = "2023-04-04";
SET @assignment_id = 1;
SET @teacher_id = 1;

UPDATE assignments, groups
    SET name = @name,
        weight = @weight,
        points = @points,
        date = @date
WHERE @assignment_id = assignments.id && group_course = course_code && group_number = number && group_semester = semester && teacher_employee_number = @teacher_id;
