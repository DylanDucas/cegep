-- ENSEIGNANT NOUVEAU TRAVAIL
--
-- Insérer un travail avec les données @name, @weight, @points, @date 
-- pour le groupe @group, @semester, @code et enseigné par @teacher_id
-- en retournant le id du nouveau travail
--
-- Il est suggéré d'utiliser la syntaxe INSERT ... SELECT pour valider le liens avec l'enseignant
-- https:--mariadb.com/kb/en/insert-select/
--
-- +----+
-- | id |
-- +----+
-- |  1 |
-- +----+
--
SET @name = "exam test";
SET @weight = 69;
SET @points = 99;
SET @date = "2023-09-12";
SET @group = 1;
SET @semester = "H2021";
SET @code = "420-1SU-SW";
SET @teacher_id = 1;

INSERT INTO assignments(name,weight,points,date,group_semester,group_course,group_number)
    SELECT
        @name,
        @weight,
        @points,
        @date,
        @semester,
        @code,
        @group
    FROM groups
    WHERE @teacher_id = teacher_employee_number && @semester = semester && @code = course_code && @group = number
RETURNING assignments.id;
