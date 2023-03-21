-- LOGIN /pages/login
--
-- Récupérer l'employé correspondant au id et password fourni.
-- 
-- +-----------------+-------+------------------------------------------------------------------+
-- | employee_number | name  | password                                                         |
-- +-----------------+-------+------------------------------------------------------------------+
-- |               1 | Alice | ac1c20c508aa6dcbed13391b2758d18ce73ff0470a6fa10c3a677f3c5346ab83 |
-- +-----------------+-------+------------------------------------------------------------------+
--
SET @id = 1;
SET @pass = 'pwda';

SELECT *
FROM teachers
WHERE employee_number = @id && password = SHA2(@pass, 256);