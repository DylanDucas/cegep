-- LOGIN /pages/login
--
-- Récupérer l'étudiant correspondant au id et password fourni.
-- 
-- +-------+------+------------------------------------------------------------------+
-- | id    | name | password                                                         |
-- +-------+------+------------------------------------------------------------------+
-- | 20201 | AAA  | ac1c20c508aa6dcbed13391b2758d18ce73ff0470a6fa10c3a677f3c5346ab83 |
-- +-------+------+------------------------------------------------------------------+
--
SET @id = 20201;
SET @pass = 'pwda';

SELECT *
FROM students
WHERE id = @id && password = SHA2(@pass, 256);
