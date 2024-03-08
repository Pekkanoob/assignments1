create database sisb;
use sisb;
CREATE TABLE IF NOT EXISTS Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE,
    email VARCHAR(100),
    phone_number VARCHAR(15)
);

CREATE TABLE IF NOT EXISTS Teacher (
    teacher_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100)
);
CREATE TABLE IF NOT EXISTS Courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100),
    credits INT,
    teacher_id INT,
    FOREIGN KEY (teacher_id) REFERENCES Teacher(teacher_id)
);


CREATE TABLE IF NOT EXISTS Enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

CREATE TABLE IF NOT EXISTS Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    amount DECIMAL(10, 2),
    payment_date DATE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);

-- Inserting sample values into the Students table
INSERT INTO Students (first_name, last_name, date_of_birth, email, phone_number)
VALUES ('John', 'Doe', '2000-01-15', 'john.doe@example.com', '123-456-7890'),
       ('Alice', 'Smith', '1999-05-20', 'alice.smith@example.com', '987-654-3210'),
       ('Michael', 'Johnson', '2001-08-10', 'michael.johnson@example.com', '555-555-5555'),
       ('Emily', 'Brown', '2002-03-25', 'emily.brown@example.com', '111-222-3333'),
       ('David', 'Williams', '1998-11-02', 'david.williams@example.com', '999-888-7777');

-- Inserting sample values into the Teacher table
INSERT INTO Teacher (first_name, last_name, email)
VALUES ('Professor', 'Smith', 'prof.smith@example.com'),
       ('Dr.', 'Johnson', 'dr.johnson@example.com'),
       ('Ms.', 'Brown', 'ms.brown@example.com');

-- Inserting sample values into the Courses table
INSERT INTO Courses (course_name, credits, teacher_id)
VALUES ('Introduction to Programming', 3, 1),
       ('Database Management', 4, 2),
       ('Web Development', 3, 3),
       ('Data Structures', 4, 1),
       ('Computer Networks', 3, 2);

-- Inserting sample values into the Enrollments table
INSERT INTO Enrollments (student_id, course_id, enrollment_date)
VALUES (1, 1, '2024-01-10'),
       (2, 2, '2024-02-05'),
       (3, 3, '2024-01-15'),
       (4, 4, '2024-02-20'),
       (5, 5, '2024-03-01');

-- Inserting sample values into the Payments table
INSERT INTO Payments (student_id, amount, payment_date)
VALUES (1, 100.00, '2024-01-10'),
       (2, 150.00, '2024-02-05'),
       (3, 100.00, '2024-01-15'),
       (4, 200.00, '2024-02-20'),
       (5, 120.00, '2024-03-01');


-- basic CRUD Operations

INSERT INTO Students (first_name, last_name, date_of_birth, email, phone_number)
VALUES ('John', 'victor', '1997-08-26', 'john.vicotr@example.com', '6382878232');

UPDATE Teacher
SET email = 'alterl@example.com'
WHERE teacher_id = 3;

DELETE FROM Enrollments
WHERE student_id = 5 AND course_id = 5;

UPDATE Courses
SET teacher_id = 5
WHERE course_id = 5;

UPDATE Payments
SET amount = 10000
WHERE payment_id = 3;



-- Using aggregate functions, group by, order by , having

SELECT s.first_name, s.last_name, SUM(p.amount) AS total_payments
FROM Students s
JOIN Payments p ON s.student_id = p.student_id
WHERE s.student_id = 1;

SELECT c.course_name, COUNT(e.student_id) AS enrolled_students
FROM Courses c
LEFT JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id;


SELECT s.first_name, s.last_name
FROM Students s
LEFT JOIN Enrollments e ON s.student_id = e.student_id
WHERE e.student_id IS NULL;

SELECT s.first_name, s.last_name, c.course_name
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id;


SELECT t.first_name, t.last_name, c.course_name
FROM Teacher t
JOIN Courses c ON t.teacher_id = c.teacher_id;


SELECT s.first_name, s.last_name, e.enrollment_date
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Biology';

SELECT s.first_name, s.last_name
FROM Students s
LEFT JOIN Payments p ON s.student_id = p.student_id
WHERE p.student_id IS NULL;

SELECT c.course_name
FROM Courses c
LEFT JOIN Enrollments e ON c.course_id = e.course_id
WHERE e.course_id IS NULL;

SELECT s.first_name, s.last_name
FROM Students s
JOIN Enrollments e1 ON s.student_id = e1.student_id
JOIN Enrollments e2 ON s.student_id = e2.student_id AND e1.enrollment_id <> e2.enrollment_id;

SELECT t.first_name, t.last_name
FROM Teacher t
LEFT JOIN Courses c ON t.teacher_id = c.teacher_id
WHERE c.teacher_id IS NULL;


-- Writing Subqueries


SELECT AVG(enrollment_count) AS average_enrollment
FROM (SELECT COUNT(*) AS enrollment_count
      FROM Enrollments
      GROUP BY course_id) AS course_enrollments;

SELECT student_id
FROM Payments
WHERE amount = (SELECT MAX(amount) FROM Payments);

SELECT course_id
FROM Enrollments
GROUP BY course_id
HAVING COUNT(*) = (SELECT MAX(enrollment_count) FROM (SELECT COUNT(*) AS enrollment_count FROM Enrollments GROUP BY course_id) AS course_enrollments);


SELECT teacher_id, SUM(amount) AS total_payments
FROM (SELECT e.course_id, p.amount
      FROM Enrollments e
      JOIN Payments p ON e.student_id = p.student_id) AS student_payments
JOIN Courses c ON student_payments.course_id = c.course_id
GROUP BY teacher_id;


SELECT student_id
FROM (SELECT student_id, COUNT(DISTINCT course_id) AS course_count
      FROM Enrollments
      GROUP BY student_id) AS student_courses
WHERE course_count = (SELECT COUNT(*) FROM Courses);


SELECT teacher_id, first_name, last_name
FROM Teacher
WHERE teacher_id NOT IN (SELECT DISTINCT teacher_id FROM Courses);


SELECT AVG(DATEDIFF(NOW(), date_of_birth) / 365) AS average_age
FROM Students;

SELECT course_id
FROM Courses
WHERE course_id NOT IN (SELECT DISTINCT course_id FROM Enrollments);


SELECT student_id
FROM Payments
GROUP BY student_id
HAVING COUNT(*) > 1;

SELECT student_id, SUM(amount) AS total_payments
FROM Payments
GROUP BY student_id;

SELECT c.course_name, COUNT(e.student_id) AS enrolled_students
FROM Courses c
LEFT JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id;