CREATE DATABASE IF NOT EXISTS monovox;

USE monovox;

DROP TABLE IF EXISTS grades, assignments, classes, groups, students, courses, teachers; 

-- TEACHERS
CREATE OR REPLACE TABLE teachers (
	employee_number INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  	name VARCHAR(100) NOT NULL,
  	password VARCHAR(64) NOT NULL
);

INSERT INTO teachers(name, password) 
VALUES ('Alice', SHA2('pwda', 256)), ('Bob', SHA2('pwdb', 256)), ('Charlie', SHA2('pwdc', 256));

-- COURSES
CREATE OR REPLACE TABLE courses (
  	code CHAR(10) NOT NULL PRIMARY KEY,
	name VARCHAR(100) NOT NULL
);

INSERT INTO courses(code, name)
VALUES ('420-0Q4-SW', 'Initiation à la profession'), ('420-0SU-SW', 'Web Client 1'), ('420-1SU-SW', 'Web Client 2');


-- STUDENTS
CREATE OR REPLACE TABLE students (
	id INT UNSIGNED PRIMARY KEY,
  	name VARCHAR(100) NOT NULL,
  	password VARCHAR(64) NOT NULL
);

INSERT INTO students(id, name, password)
VALUES 	(20201, 'AAA', SHA2('pwda', 256)), (20202, 'BBB', SHA2('pwdb', 256)), (20203, 'CCC', SHA2('pwdc', 256)), (20204, 'DDD', SHA2('pwdd', 256)), (20205, 'EEE', SHA2('pwde', 256)), 
		(20206, 'FFF', SHA2('pwdf', 256)), (20207, 'GGG', SHA2('pwdg', 256)), (20208, 'HHH', SHA2('pwdh', 256)), (20209, 'III', SHA2('pwdi', 256)), (20200, 'JJJ', SHA2('pwdj', 256)), 
		(20211, 'KKK', SHA2('pwdk', 256)), (20212, 'LLL', SHA2('pwdl', 256)), (20213, 'MMM', SHA2('pwdm', 256)), (20214, 'NNN', SHA2('pwdn', 256)), (20215, 'OOO', SHA2('pwdo', 256)), 
		(20216, 'PPP', SHA2('pwdp', 256)), (20217, 'QQQ', SHA2('pwdq', 256)), (20218, 'RRR', SHA2('pwdr', 256)), (20219, 'SSS', SHA2('pwds', 256)), (20210, 'TTT', SHA2('pwdt', 256)), 
		(20221, 'UUU', SHA2('pwdu', 256)), (20222, 'VVV', SHA2('pwdv', 256)), (20223, 'WWW', SHA2('pwdw', 256)), (20224, 'XXX', SHA2('pwdx', 256)), (20225, 'YYY', SHA2('pwdy', 256)), (20226, 'ZZZ', SHA2('pwdz', 256));

-- GROUPS
CREATE OR REPLACE TABLE groups (
	number TINYINT UNSIGNED NOT NULL DEFAULT 0, -- set BEFORE INSERT
  	semester CHAR(5) NOT NULL,
  	teacher_employee_number INT UNSIGNED NOT NULL,
  	course_code CHAR(10) NOT NULL,
  
  	UNIQUE(number, semester, course_code),
  	PRIMARY KEY(number, semester, teacher_employee_number, course_code),
  	FOREIGN KEY(teacher_employee_number) REFERENCES teachers(employee_number),
  	FOREIGN KEY(course_code) REFERENCES courses(code)
);

INSERT INTO groups(semester, teacher_employee_number, course_code, number)
VALUES 	('A2020', 1, '420-0Q4-SW', 1), ('A2021', 1, '420-0Q4-SW', 1), ('A2021', 1, '420-0SU-SW', 2), ('H2021', 1, '420-1SU-SW', 1), ('H2021', 1, '420-1SU-SW', 2),
		('A2020', 2, '420-0SU-SW', 1), ('A2021', 2, '420-0SU-SW', 1), ('H2021', 2, '420-1SU-SW', 3);


CREATE OR REPLACE TABLE classes (
  	student_id INT UNSIGNED NOT NULL,
	group_number TINYINT UNSIGNED NOT NULL,
  	group_semester CHAR(5) NOT NULL,
  	group_teacher INT UNSIGNED NOT NULL,
  	group_course CHAR(10) NOT NULL,
  
  	UNIQUE(student_id, group_semester, group_course),
  	PRIMARY KEY(student_id, group_number, group_semester, group_teacher, group_course),
  	FOREIGN KEY(student_id) REFERENCES students(id),
  	FOREIGN KEY(group_number, group_semester, group_teacher, group_course) 
  		REFERENCES groups(number, semester, teacher_employee_number, course_code)
);

INSERT INTO classes (group_semester, group_teacher, group_course, group_number, student_id)
VALUES 	('A2020', 1, '420-0Q4-SW', 1, 20201),
		('A2020', 1, '420-0Q4-SW', 1, 20202), 
		('A2020', 1, '420-0Q4-SW', 1, 20203), 
		('A2020', 1, '420-0Q4-SW', 1, 20204), 
		('A2020', 1, '420-0Q4-SW', 1, 20205), 
		('A2020', 1, '420-0Q4-SW', 1, 20206), 
		('A2020', 1, '420-0Q4-SW', 1, 20207), 
		('A2020', 1, '420-0Q4-SW', 1, 20208), 
		('A2020', 1, '420-0Q4-SW', 1, 20209), 
		('A2020', 1, '420-0Q4-SW', 1, 20200), 
        ('A2021', 1, '420-0Q4-SW', 1, 20201), 
        ('A2021', 1, '420-0Q4-SW', 1, 20211), 
        ('A2021', 1, '420-0Q4-SW', 1, 20212), 
        ('A2021', 1, '420-0Q4-SW', 1, 20213), 
        ('A2021', 1, '420-0Q4-SW', 1, 20214), 
        ('A2021', 1, '420-0Q4-SW', 1, 20215), 
        ('A2021', 1, '420-0Q4-SW', 1, 20216), 
        ('A2021', 1, '420-0Q4-SW', 1, 20217), 
        ('A2021', 1, '420-0Q4-SW', 1, 20218), 
        ('A2021', 1, '420-0Q4-SW', 1, 20219), 
        ('A2021', 1, '420-0Q4-SW', 1, 20210), 
        ('A2020', 2, '420-0SU-SW', 1, 20201), 
        ('A2020', 2, '420-0SU-SW', 1, 20202), 
        ('A2020', 2, '420-0SU-SW', 1, 20203), 
        ('A2020', 2, '420-0SU-SW', 1, 20204), 
        ('A2020', 2, '420-0SU-SW', 1, 20205), 
        ('A2020', 2, '420-0SU-SW', 1, 20206), 
        ('A2020', 2, '420-0SU-SW', 1, 20207), 
        ('A2020', 2, '420-0SU-SW', 1, 20208), 
        ('A2020', 2, '420-0SU-SW', 1, 20209), 
        ('A2020', 2, '420-0SU-SW', 1, 20200), 
        ('A2021', 2, '420-0SU-SW', 1, 20211),
        ('A2021', 2, '420-0SU-SW', 1, 20212),
        ('A2021', 2, '420-0SU-SW', 1, 20213),
        ('A2021', 2, '420-0SU-SW', 1, 20214),
        ('A2021', 2, '420-0SU-SW', 1, 20215),
        ('A2021', 2, '420-0SU-SW', 1, 20216),
        ('A2021', 2, '420-0SU-SW', 1, 20217),
        ('A2021', 2, '420-0SU-SW', 1, 20218),
        ('A2021', 2, '420-0SU-SW', 1, 20219),
        ('A2021', 2, '420-0SU-SW', 1, 20210);

delimiter ;;
CREATE OR REPLACE TRIGGER group_number_before_insert BEFORE INSERT ON groups FOR EACH ROW
BEGIN
    -- https://mariadb.com/kb/en/selectinto/
    -- https://mariadb.com/kb/en/set-variable/

	SELECT IFNULL(MAX(number), 0) + 1 INTO @num 
    FROM groups 
    WHERE semester = NEW.semester && course_code = NEW.course_code;
    
    SET NEW.number = @num;
END;;

delimiter ;
