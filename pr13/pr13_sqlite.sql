-- ============================================================================
-- Practical 13: ER Diagrams and Normalization
-- Database: SQLite
-- ============================================================================
-- This practical demonstrates:
-- 1. University Database - ER Diagram implementation with normalized schema
-- 2. Library Management System - Normalized schema (1NF, 2NF, 3NF)
-- ============================================================================

-- Enable foreign key support
PRAGMA foreign_keys = ON;

-- ============================================================================
-- PART 1: UNIVERSITY DATABASE MANAGEMENT SYSTEM
-- ============================================================================

-- Clean up existing tables
DROP TABLE IF EXISTS assignment_submissions;
DROP TABLE IF EXISTS assignments;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS faculty;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS departments;

-- Departments table
CREATE TABLE departments (
    dept_id         INTEGER PRIMARY KEY,
    dept_name       TEXT NOT NULL UNIQUE,
    dept_head       TEXT,
    building        TEXT,
    budget          REAL CHECK (budget >= 0),
    created_date    TEXT DEFAULT (date('now'))
);

-- Students table (Entity: STUDENT)
CREATE TABLE students (
    student_id      INTEGER PRIMARY KEY,
    first_name      TEXT NOT NULL,
    last_name       TEXT NOT NULL,
    email           TEXT NOT NULL UNIQUE,
    phone           TEXT,
    date_of_birth   TEXT NOT NULL,
    enrollment_date TEXT DEFAULT (date('now')),
    dept_id         INTEGER,
    semester        INTEGER CHECK (semester BETWEEN 1 AND 8),
    cgpa            REAL CHECK (cgpa BETWEEN 0 AND 10),
    address         TEXT,
    city            TEXT,
    state           TEXT,
    postal_code     TEXT,
    
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON DELETE SET NULL
);

-- Faculty table (Entity: FACULTY)
CREATE TABLE faculty (
    faculty_id      INTEGER PRIMARY KEY,
    first_name      TEXT NOT NULL,
    last_name       TEXT NOT NULL,
    email           TEXT NOT NULL UNIQUE,
    phone           TEXT,
    dept_id         INTEGER NOT NULL,
    designation     TEXT CHECK (designation IN ('Professor', 'Associate Professor', 'Assistant Professor', 'Lecturer')),
    hire_date       TEXT DEFAULT (date('now')),
    salary          REAL CHECK (salary > 0),
    qualification   TEXT,
    
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON DELETE CASCADE
);

-- Courses table (Entity: COURSE)
CREATE TABLE courses (
    course_id       TEXT PRIMARY KEY,
    course_name     TEXT NOT NULL,
    course_code     TEXT NOT NULL UNIQUE,
    dept_id         INTEGER NOT NULL,
    credits         INTEGER CHECK (credits BETWEEN 1 AND 6),
    semester        INTEGER CHECK (semester BETWEEN 1 AND 8),
    faculty_id      INTEGER,
    max_students    INTEGER DEFAULT 60 CHECK (max_students > 0),
    description     TEXT,
    
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON DELETE CASCADE,
    FOREIGN KEY (faculty_id) REFERENCES faculty(faculty_id) ON DELETE SET NULL
);

-- Enrollments table (Relationship: Student ENROLLS IN Course)
-- Many-to-Many relationship between Students and Courses
CREATE TABLE enrollments (
    enrollment_id   INTEGER PRIMARY KEY,
    student_id      INTEGER NOT NULL,
    course_id       TEXT NOT NULL,
    enrollment_date TEXT DEFAULT (date('now')),
    semester        TEXT NOT NULL,
    academic_year   TEXT NOT NULL,
    grade           TEXT CHECK (grade IN ('AA', 'AB', 'BB', 'BC', 'CC', 'CD', 'DD', 'FF', 'II')),
    attendance_pct  REAL CHECK (attendance_pct BETWEEN 0 AND 100),
    status          TEXT DEFAULT 'Active' CHECK (status IN ('Active', 'Completed', 'Dropped', 'Failed')),
    
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    UNIQUE (student_id, course_id, semester, academic_year)
);

-- Assignments table (Entity: ASSIGNMENT)
CREATE TABLE assignments (
    assignment_id   INTEGER PRIMARY KEY,
    course_id       TEXT NOT NULL,
    title           TEXT NOT NULL,
    description     TEXT,
    max_marks       INTEGER CHECK (max_marks > 0),
    due_date        TEXT NOT NULL,
    assigned_date   TEXT DEFAULT (date('now')),
    
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE
);

-- Assignment Submissions table (Relationship: Student SUBMITS Assignment)
CREATE TABLE assignment_submissions (
    submission_id   INTEGER PRIMARY KEY,
    assignment_id   INTEGER NOT NULL,
    student_id      INTEGER NOT NULL,
    submission_date TEXT DEFAULT (date('now')),
    marks_obtained  INTEGER CHECK (marks_obtained >= 0),
    remarks         TEXT,
    status          TEXT DEFAULT 'Submitted' 
                    CHECK (status IN ('Submitted', 'Graded', 'Late', 'Not Submitted')),
    
    FOREIGN KEY (assignment_id) REFERENCES assignments(assignment_id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    UNIQUE (assignment_id, student_id)
);

-- ============================================================================
-- Sample Data for University Database
-- ============================================================================

-- Insert Departments
INSERT INTO departments VALUES (1, 'Computer Engineering', 'Dr. Rakesh Sharma', 'IT Building', 5000000, '2026-02-26');
INSERT INTO departments VALUES (2, 'Electronics Engineering', 'Dr. Priya Patel', 'EC Building', 4500000, '2026-02-26');
INSERT INTO departments VALUES (3, 'Mechanical Engineering', 'Dr. Amit Kumar', 'Mech Building', 4000000, '2026-02-26');
INSERT INTO departments VALUES (4, 'Civil Engineering', 'Dr. Sneha Singh', 'Civil Building', 3500000, '2026-02-26');

-- Insert Faculty
INSERT INTO faculty VALUES (101, 'Rajesh', 'Mehta', 'rajesh.mehta@univ.edu', '9876543210', 1, 'Professor', '2010-07-15', 95000, 'Ph.D. in Computer Science');
INSERT INTO faculty VALUES (102, 'Kavita', 'Shah', 'kavita.shah@univ.edu', '9876543211', 1, 'Associate Professor', '2015-08-20', 75000, 'Ph.D. in Software Engineering');
INSERT INTO faculty VALUES (103, 'Vijay', 'Desai', 'vijay.desai@univ.edu', '9876543212', 2, 'Assistant Professor', '2018-01-10', 60000, 'M.Tech in VLSI');
INSERT INTO faculty VALUES (104, 'Anita', 'Joshi', 'anita.joshi@univ.edu', '9876543213', 3, 'Professor', '2008-06-01', 100000, 'Ph.D. in Mechanical Engineering');

-- Insert Students
INSERT INTO students VALUES (2021001, 'Rahul', 'Sharma', 'rahul.sharma@student.edu', '9876501001', '2003-05-15', '2021-07-01', 1, 4, 8.5, 'Mumbai', 'Mumbai', 'Maharashtra', '400001');
INSERT INTO students VALUES (2021002, 'Priya', 'Verma', 'priya.verma@student.edu', '9876501002', '2003-08-20', '2021-07-01', 1, 4, 9.2, 'Pune', 'Pune', 'Maharashtra', '411001');
INSERT INTO students VALUES (2021003, 'Arjun', 'Patel', 'arjun.patel@student.edu', '9876501003', '2003-03-10', '2021-07-01', 2, 4, 7.8, 'Ahmedabad', 'Ahmedabad', 'Gujarat', '380001');
INSERT INTO students VALUES (2022001, 'Neha', 'Singh', 'neha.singh@student.edu', '9876502001', '2004-11-25', '2022-07-01', 1, 2, 8.0, 'Delhi', 'Delhi', 'Delhi', '110001');
INSERT INTO students VALUES (2022002, 'Karan', 'Jain', 'karan.jain@student.edu', '9876502002', '2004-02-14', '2022-07-01', 3, 2, 7.5, 'Bangalore', 'Bangalore', 'Karnataka', '560001');

-- Insert Courses
INSERT INTO courses VALUES ('CS401', 'Database Management Systems', 'DBMS-401', 1, 4, 4, 101, 60, 'Learn about databases, SQL, normalization, and transactions');
INSERT INTO courses VALUES ('CS402', 'Data Structures', 'DS-402', 1, 4, 4, 102, 60, 'Study of arrays, linked lists, trees, graphs, and algorithms');
INSERT INTO courses VALUES ('CS201', 'Programming in C', 'C-201', 1, 4, 2, 102, 70, 'Introduction to C programming language');
INSERT INTO courses VALUES ('EC301', 'Digital Electronics', 'DE-301', 2, 4, 3, 103, 50, 'Logic gates, flip-flops, and digital circuits');
INSERT INTO courses VALUES ('ME301', 'Thermodynamics', 'THERMO-301', 3, 4, 3, 104, 50, 'Study of heat and energy transfer');

-- Insert Enrollments
INSERT INTO enrollments VALUES (1, 2021001, 'CS401', '2024-07-15', 'Fall', '2024-25', 'AA', 95, 'Completed');
INSERT INTO enrollments VALUES (2, 2021002, 'CS401', '2024-07-15', 'Fall', '2024-25', 'AB', 92, 'Completed');
INSERT INTO enrollments VALUES (3, 2021001, 'CS402', '2024-07-15', 'Fall', '2024-25', 'BB', 88, 'Completed');
INSERT INTO enrollments VALUES (4, 2022001, 'CS201', '2024-07-15', 'Fall', '2024-25', NULL, 85, 'Active');
INSERT INTO enrollments VALUES (5, 2021003, 'EC301', '2024-07-15', 'Fall', '2024-25', 'BC', 82, 'Completed');

-- Insert Assignments
INSERT INTO assignments VALUES (1, 'CS401', 'ER Diagram Design', 'Design an ER diagram for a hospital management system', 20, '2024-08-30', '2024-08-15');
INSERT INTO assignments VALUES (2, 'CS401', 'SQL Queries', 'Write SQL queries for normalization', 25, '2024-09-15', '2024-09-01');
INSERT INTO assignments VALUES (3, 'CS402', 'Binary Tree Implementation', 'Implement binary tree in C', 30, '2024-09-20', '2024-09-05');
INSERT INTO assignments VALUES (4, 'CS201', 'C Programming Lab', 'Write programs for arrays and pointers', 20, '2024-08-25', '2024-08-10');

-- Insert Assignment Submissions
INSERT INTO assignment_submissions VALUES (1, 1, 2021001, '2024-08-29', 19, 'Excellent work', 'Graded');
INSERT INTO assignment_submissions VALUES (2, 1, 2021002, '2024-08-30', 20, 'Perfect submission', 'Graded');
INSERT INTO assignment_submissions VALUES (3, 2, 2021001, '2024-09-14', 23, 'Good queries', 'Graded');
INSERT INTO assignment_submissions VALUES (4, 3, 2021001, '2024-09-19', 28, 'Well implemented', 'Graded');
INSERT INTO assignment_submissions VALUES (5, 4, 2022001, '2024-08-24', 18, 'Good effort', 'Graded');

-- ============================================================================
-- PART 2: LIBRARY MANAGEMENT SYSTEM (Normalized Schema)
-- ============================================================================

-- Clean up existing tables
DROP TABLE IF EXISTS book_copies;
DROP TABLE IF EXISTS borrowings;
DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS book_authors;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS authors;
DROP TABLE IF EXISTS publishers;
DROP TABLE IF EXISTS branches;

-- Publishers table (1NF: Atomic values, unique rows)
CREATE TABLE publishers (
    publisher_id    INTEGER PRIMARY KEY,
    publisher_name  TEXT NOT NULL UNIQUE,
    address         TEXT,
    city            TEXT,
    phone           TEXT,
    email           TEXT,
    website         TEXT
);

-- Authors table (1NF: Atomic values, unique rows)
CREATE TABLE authors (
    author_id       INTEGER PRIMARY KEY,
    first_name      TEXT NOT NULL,
    last_name       TEXT NOT NULL,
    biography       TEXT,
    country         TEXT,
    birth_date      TEXT
);

-- Books table (2NF: No partial dependencies, all non-key attributes depend on entire primary key)
CREATE TABLE books (
    book_id         INTEGER PRIMARY KEY,
    isbn            TEXT NOT NULL UNIQUE,
    title           TEXT NOT NULL,
    publisher_id    INTEGER,
    publication_year INTEGER CHECK (publication_year BETWEEN 1000 AND 2100),
    edition         TEXT,
    language        TEXT DEFAULT 'English',
    pages           INTEGER CHECK (pages > 0),
    category        TEXT,
    description     TEXT,
    
    FOREIGN KEY (publisher_id) REFERENCES publishers(publisher_id) ON DELETE SET NULL
);

-- Book_Authors junction table (3NF: No transitive dependencies)
-- Many-to-Many relationship between Books and Authors
CREATE TABLE book_authors (
    book_id         INTEGER,
    author_id       INTEGER,
    author_order    INTEGER DEFAULT 1,  -- For multiple authors
    
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES authors(author_id) ON DELETE CASCADE
);

-- Branches table (Library branches)
CREATE TABLE branches (
    branch_id       INTEGER PRIMARY KEY,
    branch_name     TEXT NOT NULL UNIQUE,
    address         TEXT,
    city            TEXT,
    phone           TEXT,
    manager_name    TEXT,
    opening_time    TEXT,
    closing_time    TEXT
);

-- Members table (Library members)
CREATE TABLE members (
    member_id       INTEGER PRIMARY KEY,
    first_name      TEXT NOT NULL,
    last_name       TEXT NOT NULL,
    email           TEXT NOT NULL UNIQUE,
    phone           TEXT,
    address         TEXT,
    city            TEXT,
    membership_date TEXT DEFAULT (date('now')),
    membership_type TEXT CHECK (membership_type IN ('Student', 'Faculty', 'Public')),
    status          TEXT DEFAULT 'Active' CHECK (status IN ('Active', 'Suspended', 'Expired'))
);

-- Book_Copies table (Physical copies in each branch)
CREATE TABLE book_copies (
    copy_id         INTEGER PRIMARY KEY,
    book_id         INTEGER NOT NULL,
    branch_id       INTEGER NOT NULL,
    copy_number     TEXT NOT NULL,
    status          TEXT DEFAULT 'Available' 
                    CHECK (status IN ('Available', 'Borrowed', 'Reserved', 'Lost', 'Damaged')),
    purchase_date   TEXT DEFAULT (date('now')),
    price           REAL,
    
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id) ON DELETE CASCADE,
    UNIQUE (book_id, branch_id, copy_number)
);

-- Borrowings table (Book borrowing transactions)
CREATE TABLE borrowings (
    borrowing_id    INTEGER PRIMARY KEY,
    copy_id         INTEGER NOT NULL,
    member_id       INTEGER NOT NULL,
    borrow_date     TEXT DEFAULT (date('now')),
    due_date        TEXT NOT NULL,
    return_date     TEXT,
    fine_amount     REAL DEFAULT 0 CHECK (fine_amount >= 0),
    status          TEXT DEFAULT 'Borrowed' 
                    CHECK (status IN ('Borrowed', 'Returned', 'Overdue', 'Lost')),
    
    FOREIGN KEY (copy_id) REFERENCES book_copies(copy_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE
);

-- ============================================================================
-- Sample Data for Library Management System
-- ============================================================================

-- Insert Publishers
INSERT INTO publishers VALUES (1, 'Pearson Education', '123 Education St', 'New York', '1234567890', 'info@pearson.com', 'www.pearson.com');
INSERT INTO publishers VALUES (2, 'McGraw-Hill', '456 Learning Ave', 'Chicago', '2345678901', 'info@mcgrawhill.com', 'www.mheducation.com');
INSERT INTO publishers VALUES (3, 'O''Reilly Media', '789 Tech Blvd', 'Sebastopol', '3456789012', 'info@oreilly.com', 'www.oreilly.com');

-- Insert Authors
INSERT INTO authors VALUES (1, 'Abraham', 'Silberschatz', 'Renowned database expert', 'USA', '1952-01-15');
INSERT INTO authors VALUES (2, 'Henry', 'Korth', 'Database systems professor', 'USA', '1956-03-20');
INSERT INTO authors VALUES (3, 'Herbert', 'Schildt', 'Programming language expert', 'USA', '1951-07-18');
INSERT INTO authors VALUES (4, 'Brian', 'Kernighan', 'Co-creator of C language', 'Canada', '1942-01-01');
INSERT INTO authors VALUES (5, 'Dennis', 'Ritchie', 'Creator of C language', 'USA', '1941-09-09');

-- Insert Books
INSERT INTO books VALUES (1, '978-0073523323', 'Database System Concepts', 1, 2019, '7th Edition', 'English', 1376, 'Database', 'Comprehensive database textbook');
INSERT INTO books VALUES (2, '978-0073523064', 'Fundamentals of Database Systems', 1, 2015, '7th Edition', 'English', 1272, 'Database', 'Database fundamentals');
INSERT INTO books VALUES (3, '978-0072263213', 'The Complete Reference C', 2, 2007, '4th Edition', 'English', 805, 'Programming', 'Complete C programming guide');
INSERT INTO books VALUES (4, '978-0131103627', 'The C Programming Language', 1, 1988, '2nd Edition', 'English', 272, 'Programming', 'Classic C programming book');

-- Insert Book_Authors (Many-to-Many relationship)
INSERT INTO book_authors VALUES (1, 1, 1);  -- Silberschatz is first author
INSERT INTO book_authors VALUES (1, 2, 2);  -- Korth is second author
INSERT INTO book_authors VALUES (3, 3, 1);  -- Schildt is author
INSERT INTO book_authors VALUES (4, 4, 1);  -- Kernighan is first author
INSERT INTO book_authors VALUES (4, 5, 2);  -- Ritchie is second author

-- Insert Branches
INSERT INTO branches VALUES (1, 'Central Library', '123 Main St', 'Mumbai', '9876000001', 'Rajesh Kumar', '09:00 AM', '08:00 PM');
INSERT INTO branches VALUES (2, 'North Branch', '456 North Ave', 'Mumbai', '9876000002', 'Priya Shah', '10:00 AM', '06:00 PM');
INSERT INTO branches VALUES (3, 'East Branch', '789 East Rd', 'Mumbai', '9876000003', 'Amit Patel', '09:00 AM', '07:00 PM');

-- Insert Members
INSERT INTO members VALUES (1001, 'Rahul', 'Mehta', 'rahul.mehta@email.com', '9876111001', 'Mumbai', 'Mumbai', '2023-01-15', 'Student', 'Active');
INSERT INTO members VALUES (1002, 'Sneha', 'Joshi', 'sneha.joshi@email.com', '9876111002', 'Mumbai', 'Mumbai', '2023-02-20', 'Faculty', 'Active');
INSERT INTO members VALUES (1003, 'Karan', 'Desai', 'karan.desai@email.com', '9876111003', 'Mumbai', 'Mumbai', '2023-03-10', 'Public', 'Active');

-- Insert Book Copies
INSERT INTO book_copies VALUES (1, 1, 1, 'COPY-001', 'Borrowed', '2023-01-01', 1200);
INSERT INTO book_copies VALUES (2, 1, 1, 'COPY-002', 'Available', '2023-01-01', 1200);
INSERT INTO book_copies VALUES (3, 1, 2, 'COPY-001', 'Available', '2023-01-01', 1200);
INSERT INTO book_copies VALUES (4, 2, 1, 'COPY-001', 'Available', '2023-01-01', 1100);
INSERT INTO book_copies VALUES (5, 3, 1, 'COPY-001', 'Borrowed', '2023-01-01', 850);
INSERT INTO book_copies VALUES (6, 4, 2, 'COPY-001', 'Available', '2023-01-01', 500);

-- Insert Borrowings
INSERT INTO borrowings VALUES (1, 1, 1001, '2026-02-15', '2026-03-01', NULL, 0, 'Borrowed');
INSERT INTO borrowings VALUES (2, 5, 1002, '2026-02-20', '2026-03-06', NULL, 0, 'Borrowed');
INSERT INTO borrowings VALUES (3, 2, 1003, '2026-01-10', '2026-01-24', '2026-01-22', 0, 'Returned');

-- ============================================================================
-- Display Sample Data
-- ============================================================================

.mode column
.headers on
.width 12 20 30 15 10

SELECT '=== UNIVERSITY DATABASE ===' AS '';

SELECT '=== Students with their enrollments ===' AS '';
SELECT s.student_id, s.first_name || ' ' || s.last_name AS student_name, 
       c.course_code, c.course_name, e.grade, e.attendance_pct
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
ORDER BY s.student_id;

SELECT '=== Faculty teaching courses ===' AS '';
SELECT f.first_name || ' ' || f.last_name AS faculty_name, 
       f.designation, c.course_code, c.course_name
FROM faculty f
LEFT JOIN courses c ON f.faculty_id = c.faculty_id
ORDER BY f.faculty_id;

SELECT '=== LIBRARY DATABASE ===' AS '';

SELECT '=== Books with their authors ===' AS '';
SELECT b.title, a.first_name || ' ' || a.last_name AS author_name, 
       p.publisher_name, b.publication_year
FROM books b
JOIN book_authors ba ON b.book_id = ba.book_id
JOIN authors a ON ba.author_id = a.author_id
LEFT JOIN publishers p ON b.publisher_id = p.publisher_id
ORDER BY b.title, ba.author_order;

SELECT '=== Currently borrowed books ===' AS '';
SELECT m.first_name || ' ' || m.last_name AS member_name, 
       b.title, br.borrow_date, br.due_date, 
       CASE 
           WHEN br.due_date < date('now') THEN 'Overdue'
           ELSE 'On Time'
       END AS status
FROM borrowings br
JOIN book_copies bc ON br.copy_id = bc.copy_id
JOIN books b ON bc.book_id = b.book_id
JOIN members m ON br.member_id = m.member_id
WHERE br.status = 'Borrowed'
ORDER BY br.due_date;

SELECT '=== Book availability by branch ===' AS '';
SELECT br.branch_name, b.title, 
       COUNT(*) AS total_copies,
       SUM(CASE WHEN bc.status = 'Available' THEN 1 ELSE 0 END) AS available_copies
FROM book_copies bc
JOIN books b ON bc.book_id = b.book_id
JOIN branches br ON bc.branch_id = br.branch_id
GROUP BY br.branch_name, b.title
ORDER BY br.branch_name, b.title;
