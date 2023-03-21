--
-- VOTRE NOM: Dylan Ducas
--

CREATE TABLE IF NOT EXISTS assignments (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    weight TINYINT UNSIGNED NOT NULL CHECK(weight >= 0 && weight <= 100),
    points TINYINT UNSIGNED NOT NULL CHECK(points > 0),
    date DATE NOT NULL,
    group_semester CHAR(5) NOT NULL,
    group_course CHAR(10) NOT NULL,
    group_number TINYINT UNSIGNED NOT NULL,

    FOREIGN KEY (group_number,group_semester,group_course) 
    REFERENCES groups(number,semester,course_code)
);

CREATE TABLE IF NOT EXISTS grades(
    student_id INT UNSIGNED NOT NULL,
    assignment_id INT UNSIGNED NOT NULL,
    points TINYINT UNSIGNED CHECK(points >= 0 || points IS NULL),

    PRIMARY KEY (student_id, assignment_id),
    FOREIGN KEY (student_id) REFERENCES students(id),
    FOREIGN KEY (assignment_id) REFERENCES assignments(id) ON DELETE CASCADE
);

delimiter ;;

CREATE OR REPLACE TRIGGER create_empty_note AFTER INSERT 
ON assignments FOR EACH ROW
BEGIN
    INSERT INTO grades
    SELECT classes.student_id,
        NEW.id,
        NULL
    FROM classes
    WHERE classes.group_semester = NEW.group_semester && classes.group_course = NEW.group_course && classes.group_number = NEW.group_number;
END;;

delimiter ;


INSERT INTO assignments
VALUES 	(DEFAULT, "quiz 33", 19, 99, "2020-09-12", "A2020", '420-0Q4-SW', 1),
(DEFAULT, "exam 7.9", 19, 99, "2020-10-12", "A2021", '420-0Q4-SW', 1),
(DEFAULT, "epreuve final (franque)", 19, 99, "2020-08-12", "A2020", '420-0Q4-SW', 1),
(DEFAULT, "dictée texte yoshikage kira", 19, 99, "2020-11-12", "A2020", '420-0SU-SW', 1);

delimiter ;;

CREATE OR REPLACE TRIGGER weight_sum_trigger BEFORE INSERT 
ON assignments FOR EACH ROW
BEGIN
    SELECT IFNULL(SUM(weight),0) INTO @weight_sum
    FROM assignments WHERE assignments.group_semester = NEW.group_semester && assignments.group_course = NEW.group_course && assignments.group_number = NEW.group_number;
    IF (@weight_sum + NEW.weight > 100) THEN
        SELECT CONCAT("Can't insert total weight above 100. ",@weight_sum) INTO @test_string;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT =  @test_string;
    END IF;
END;;

CREATE OR REPLACE TRIGGER date_above_today BEFORE INSERT
ON assignments FOR EACH ROW 
BEGIN
    IF (NEW.date <= CURDATE()) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Can't insert date below or equal to today.";
    END IF;
END;;

delimiter ;

UPDATE grades
SET
    points = (
        CASE WHEN student_id = "20201" && assignment_id = 1 THEN 50
            WHEN student_id = "20206" && assignment_id = 1 THEN 30
            WHEN student_id = "20211" && assignment_id = 2 THEN 20
            WHEN student_id = "20211" && assignment_id = 4 THEN 69
            WHEN student_id = "20206" && assignment_id = 4 THEN 55 
            WHEN student_id = "20200" && assignment_id = 1 THEN 50
            WHEN student_id = "20205" && assignment_id = 1 THEN 23
            WHEN student_id = "20200" && assignment_id = 2 THEN 65
            WHEN student_id = "20200" && assignment_id = 3 THEN 98
            WHEN student_id = "20205" && assignment_id = 4 THEN 45 
            WHEN student_id = "20207" && assignment_id = 4 THEN 25
            WHEN student_id = "20208" && assignment_id = 4 THEN 97
            WHEN student_id = "20209" && assignment_id = 4 THEN 1
            WHEN student_id = "20210" && assignment_id = 2 THEN 3
            WHEN student_id = "20212" && assignment_id = 2 THEN 83 
            WHEN 1 THEN 50
    END);

CREATE OR REPLACE VIEW students_grades AS
    SELECT 
        student_id,
        semester,
        grades.points AS "grade",
        assignments.name,
        assignments.points,
        weight,
        date,
        FORMAT(grades.points / assignments.points * 100,2) AS "percent",
        code,
        courses.name AS "course_name",
        teachers.name AS "teacher_name",
        FORMAT(AVG(grades.points / assignments.points * 100),2) AS "average"
    FROM groups
    LEFT JOIN teachers ON teacher_employee_number = employee_number
    LEFT JOIN courses ON code = course_code
    LEFT JOIN assignments ON course_code = group_course && number = group_number && semester = group_semester
    LEFT JOIN grades ON assignment_id = assignments.id
    WHERE student_id IS NOT NULL
    GROUP BY student_id, course_code ,  teacher_employee_number,assignments.id
    ORDER BY code, date ASC;
