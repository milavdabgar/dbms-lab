-- ============================================================================
-- Practical 2: ER Diagram to Relational Schema Implementation (Oracle)
-- ============================================================================
-- Systems Implemented:
-- 1. Library Management System (9 tables)
-- 2. College Management System (10 tables)
-- ============================================================================

-- Clear any existing tables
BEGIN
   -- Library Management System tables
   EXECUTE IMMEDIATE 'DROP TABLE FINE CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE RESERVATION CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE BORROWING CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE BOOK_COPY CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE BOOK_AUTHOR CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE BOOK CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE AUTHOR CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE PUBLISHER CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE LIBRARY_BRANCH CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE MEMBER CASCADE CONSTRAINTS';
   
   -- College Management System tables
   EXECUTE IMMEDIATE 'DROP TABLE ATTENDANCE CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE SUBMISSION CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE ASSIGNMENT CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE CLASS_SCHEDULE CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE CLASSROOM CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE ENROLLMENT CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE COURSE CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE STUDENT CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE FACULTY CASCADE CONSTRAINTS';
   EXECUTE IMMEDIATE 'DROP TABLE DEPARTMENT CASCADE CONSTRAINTS';
EXCEPTION
   WHEN OTHERS THEN
      NULL;
END;
/

-- ============================================================================
-- PART 1: LIBRARY MANAGEMENT SYSTEM
-- ============================================================================

-- Table: PUBLISHER
-- Stores information about book publishers
CREATE TABLE PUBLISHER (
    publisher_id NUMBER PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    address VARCHAR2(200),
    phone VARCHAR2(20),
    email VARCHAR2(100),
    CONSTRAINT uk_publisher_name UNIQUE (name),
    CONSTRAINT chk_publisher_email CHECK (email LIKE '%@%')
);

-- Table: AUTHOR
-- Stores information about book authors
CREATE TABLE AUTHOR (
    author_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    biography VARCHAR2(1000),
    birth_date DATE,
    nationality VARCHAR2(50),
    CONSTRAINT chk_author_birthdate CHECK (birth_date < SYSDATE)
);

-- Table: BOOK
-- Stores book catalog information
CREATE TABLE BOOK (
    book_id NUMBER PRIMARY KEY,
    isbn VARCHAR2(20) NOT NULL,
    title VARCHAR2(200) NOT NULL,
    publisher_id NUMBER NOT NULL,
    publication_date DATE,
    genre VARCHAR2(50),
    pages NUMBER,
    language VARCHAR2(30) DEFAULT 'English',
    CONSTRAINT fk_book_publisher FOREIGN KEY (publisher_id) 
        REFERENCES PUBLISHER(publisher_id) ON DELETE RESTRICT,
    CONSTRAINT uk_book_isbn UNIQUE (isbn),
    CONSTRAINT chk_book_pages CHECK (pages > 0)
);

-- Table: BOOK_AUTHOR (Junction table for M:N relationship)
-- Links books with their authors
CREATE TABLE BOOK_AUTHOR (
    book_id NUMBER,
    author_id NUMBER,
    author_sequence NUMBER DEFAULT 1,
    CONSTRAINT pk_book_author PRIMARY KEY (book_id, author_id),
    CONSTRAINT fk_ba_book FOREIGN KEY (book_id) 
        REFERENCES BOOK(book_id) ON DELETE CASCADE,
    CONSTRAINT fk_ba_author FOREIGN KEY (author_id) 
        REFERENCES AUTHOR(author_id) ON DELETE CASCADE
);

-- Table: LIBRARY_BRANCH
-- Stores information about different library branches
CREATE TABLE LIBRARY_BRANCH (
    branch_id NUMBER PRIMARY KEY,
    branch_name VARCHAR2(100) NOT NULL,
    address VARCHAR2(200) NOT NULL,
    phone VARCHAR2(20),
    email VARCHAR2(100),
    manager VARCHAR2(100),
    CONSTRAINT uk_branch_name UNIQUE (branch_name),
    CONSTRAINT chk_branch_email CHECK (email LIKE '%@%')
);

-- Table: BOOK_COPY
-- Stores physical copies of books at different branches
CREATE TABLE BOOK_COPY (
    copy_id NUMBER PRIMARY KEY,
    book_id NUMBER NOT NULL,
    branch_id NUMBER NOT NULL,
    status VARCHAR2(20) DEFAULT 'available',
    acquisition_date DATE DEFAULT SYSDATE,
    price NUMBER(10,2),
    CONSTRAINT fk_copy_book FOREIGN KEY (book_id) 
        REFERENCES BOOK(book_id) ON DELETE CASCADE,
    CONSTRAINT fk_copy_branch FOREIGN KEY (branch_id) 
        REFERENCES LIBRARY_BRANCH(branch_id) ON DELETE RESTRICT,
    CONSTRAINT chk_copy_status CHECK (status IN ('available', 'borrowed', 'reserved', 'maintenance', 'lost')),
    CONSTRAINT chk_copy_price CHECK (price >= 0)
);

-- Table: MEMBER
-- Stores library member information
CREATE TABLE MEMBER (
    member_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) NOT NULL,
    phone VARCHAR2(20),
    address VARCHAR2(200),
    membership_date DATE DEFAULT SYSDATE,
    expiry_date DATE,
    status VARCHAR2(20) DEFAULT 'active',
    CONSTRAINT uk_member_email UNIQUE (email),
    CONSTRAINT chk_member_email CHECK (email LIKE '%@%'),
    CONSTRAINT chk_member_status CHECK (status IN ('active', 'expired', 'suspended')),
    CONSTRAINT chk_member_dates CHECK (expiry_date > membership_date)
);

-- Table: BORROWING
-- Records of book borrowings
CREATE TABLE BORROWING (
    borrowing_id NUMBER PRIMARY KEY,
    member_id NUMBER NOT NULL,
    copy_id NUMBER NOT NULL,
    borrow_date DATE DEFAULT SYSDATE,
    due_date DATE NOT NULL,
    return_date DATE,
    status VARCHAR2(20) DEFAULT 'active',
    CONSTRAINT fk_borrowing_member FOREIGN KEY (member_id) 
        REFERENCES MEMBER(member_id) ON DELETE RESTRICT,
    CONSTRAINT fk_borrowing_copy FOREIGN KEY (copy_id) 
        REFERENCES BOOK_COPY(copy_id) ON DELETE RESTRICT,
    CONSTRAINT chk_borrowing_status CHECK (status IN ('active', 'returned', 'overdue')),
    CONSTRAINT chk_borrowing_dates CHECK (due_date > borrow_date),
    CONSTRAINT chk_return_date CHECK (return_date IS NULL OR return_date >= borrow_date)
);

-- Table: RESERVATION
-- Book reservations when copies are unavailable
CREATE TABLE RESERVATION (
    reservation_id NUMBER PRIMARY KEY,
    member_id NUMBER NOT NULL,
    book_id NUMBER NOT NULL,
    reservation_date DATE DEFAULT SYSDATE,
    status VARCHAR2(20) DEFAULT 'pending',
    CONSTRAINT fk_reservation_member FOREIGN KEY (member_id) 
        REFERENCES MEMBER(member_id) ON DELETE CASCADE,
    CONSTRAINT fk_reservation_book FOREIGN KEY (book_id) 
        REFERENCES BOOK(book_id) ON DELETE CASCADE,
    CONSTRAINT chk_reservation_status CHECK (status IN ('pending', 'fulfilled', 'cancelled'))
);

-- Table: FINE
-- Fines for overdue or damaged books
CREATE TABLE FINE (
    fine_id NUMBER PRIMARY KEY,
    borrowing_id NUMBER NOT NULL,
    member_id NUMBER NOT NULL,
    amount NUMBER(10,2) NOT NULL,
    fine_date DATE DEFAULT SYSDATE,
    status VARCHAR2(20) DEFAULT 'unpaid',
    paid_date DATE,
    CONSTRAINT fk_fine_borrowing FOREIGN KEY (borrowing_id) 
        REFERENCES BORROWING(borrowing_id) ON DELETE RESTRICT,
    CONSTRAINT fk_fine_member FOREIGN KEY (member_id) 
        REFERENCES MEMBER(member_id) ON DELETE RESTRICT,
    CONSTRAINT chk_fine_amount CHECK (amount > 0),
    CONSTRAINT chk_fine_status CHECK (status IN ('unpaid', 'paid', 'waived')),
    CONSTRAINT chk_fine_paid_date CHECK (paid_date IS NULL OR paid_date >= fine_date)
);

-- Sample Data for Library Management System

-- Publishers
INSERT INTO PUBLISHER VALUES (1, 'Penguin Random House', '1745 Broadway, New York, NY 10019', '+1-212-782-9000', 'info@penguinrandomhouse.com');
INSERT INTO PUBLISHER VALUES (2, 'HarperCollins', '195 Broadway, New York, NY 10007', '+1-212-207-7000', 'contact@harpercollins.com');
INSERT INTO PUBLISHER VALUES (3, 'Simon & Schuster', '1230 Avenue of the Americas, New York, NY 10020', '+1-212-698-7000', 'info@simonandschuster.com');
INSERT INTO PUBLISHER VALUES (4, 'Macmillan Publishers', '120 Broadway, New York, NY 10271', '+1-646-307-5151', 'press.inquiries@macmillan.com');

-- Authors
INSERT INTO AUTHOR VALUES (1, 'J.K.', 'Rowling', 'British author, best known for Harry Potter series', DATE '1965-07-31', 'British');
INSERT INTO AUTHOR VALUES (2, 'George R.R.', 'Martin', 'American novelist and short story writer', DATE '1948-09-20', 'American');
INSERT INTO AUTHOR VALUES (3, 'Stephen', 'King', 'American author of horror, supernatural fiction', DATE '1947-09-21', 'American');
INSERT INTO AUTHOR VALUES (4, 'Agatha', 'Christie', 'English writer known for detective novels', DATE '1890-09-15', 'British');
INSERT INTO AUTHOR VALUES (5, 'Isaac', 'Asimov', 'American writer and professor of biochemistry', DATE '1920-01-02', 'American');

-- Books
INSERT INTO BOOK VALUES (1, '978-0439708180', 'Harry Potter and the Sorcerer''s Stone', 1, DATE '1997-06-26', 'Fantasy', 309, 'English');
INSERT INTO BOOK VALUES (2, '978-0553103540', 'A Game of Thrones', 2, DATE '1996-08-01', 'Fantasy', 694, 'English');
INSERT INTO BOOK VALUES (3, '978-0307743657', 'The Shining', 3, DATE '1977-01-28', 'Horror', 447, 'English');
INSERT INTO BOOK VALUES (4, '978-0062073488', 'Murder on the Orient Express', 2, DATE '1934-01-01', 'Mystery', 256, 'English');
INSERT INTO BOOK VALUES (5, '978-0553293357', 'Foundation', 1, DATE '1951-06-01', 'Science Fiction', 255, 'English');
INSERT INTO BOOK VALUES (6, '978-0439064873', 'Harry Potter and the Chamber of Secrets', 1, DATE '1998-07-02', 'Fantasy', 341, 'English');

-- Book-Author relationships
INSERT INTO BOOK_AUTHOR VALUES (1, 1, 1);
INSERT INTO BOOK_AUTHOR VALUES (2, 2, 1);
INSERT INTO BOOK_AUTHOR VALUES (3, 3, 1);
INSERT INTO BOOK_AUTHOR VALUES (4, 4, 1);
INSERT INTO BOOK_AUTHOR VALUES (5, 5, 1);
INSERT INTO BOOK_AUTHOR VALUES (6, 1, 1);

-- Library Branches
INSERT INTO LIBRARY_BRANCH VALUES (1, 'Main Branch', '123 Library Street, Downtown', '+1-555-0101', 'main@library.org', 'John Smith');
INSERT INTO LIBRARY_BRANCH VALUES (2, 'East Branch', '456 Oak Avenue, Eastside', '+1-555-0102', 'east@library.org', 'Jane Doe');
INSERT INTO LIBRARY_BRANCH VALUES (3, 'West Branch', '789 Elm Road, Westside', '+1-555-0103', 'west@library.org', 'Mike Johnson');

-- Book Copies
INSERT INTO BOOK_COPY VALUES (1, 1, 1, 'available', DATE '2020-01-15', 25.99);
INSERT INTO BOOK_COPY VALUES (2, 1, 1, 'borrowed', DATE '2020-01-15', 25.99);
INSERT INTO BOOK_COPY VALUES (3, 1, 2, 'available', DATE '2020-02-20', 25.99);
INSERT INTO BOOK_COPY VALUES (4, 2, 1, 'available', DATE '2020-01-10', 35.50);
INSERT INTO BOOK_COPY VALUES (5, 2, 3, 'borrowed', DATE '2020-03-15', 35.50);
INSERT INTO BOOK_COPY VALUES (6, 3, 2, 'available', DATE '2020-01-20', 20.00);
INSERT INTO BOOK_COPY VALUES (7, 4, 1, 'available', DATE '2020-02-10', 18.99);
INSERT INTO BOOK_COPY VALUES (8, 5, 3, 'available', DATE '2020-03-01', 22.50);

-- Members
INSERT INTO MEMBER VALUES (1, 'Alice', 'Johnson', 'alice.johnson@email.com', '+1-555-1001', '100 Main St, Apt 5', DATE '2023-01-15', DATE '2025-01-15', 'active');
INSERT INTO MEMBER VALUES (2, 'Bob', 'Williams', 'bob.williams@email.com', '+1-555-1002', '200 Park Ave', DATE '2023-03-20', DATE '2025-03-20', 'active');
INSERT INTO MEMBER VALUES (3, 'Carol', 'Davis', 'carol.davis@email.com', '+1-555-1003', '300 Hill Road', DATE '2023-06-10', DATE '2025-06-10', 'active');
INSERT INTO MEMBER VALUES (4, 'David', 'Brown', 'david.brown@email.com', '+1-555-1004', '400 Valley Dr', DATE '2022-12-01', DATE '2024-12-01', 'expired');

-- Borrowings
INSERT INTO BORROWING VALUES (1, 1, 2, DATE '2024-02-01', DATE '2024-02-15', DATE '2024-02-14', 'returned');
INSERT INTO BORROWING VALUES (2, 2, 5, DATE '2024-02-10', DATE '2024-02-24', NULL, 'active');
INSERT INTO BORROWING VALUES (3, 3, 2, DATE '2024-02-15', DATE '2024-03-01', NULL, 'overdue');
INSERT INTO BORROWING VALUES (4, 1, 4, DATE '2024-02-20', DATE '2024-03-05', NULL, 'active');

-- Reservations
INSERT INTO RESERVATION VALUES (1, 3, 1, DATE '2024-02-25', 'pending');
INSERT INTO RESERVATION VALUES (2, 2, 3, DATE '2024-02-26', 'pending');

-- Fines
INSERT INTO FINE VALUES (1, 3, 3, 15.00, DATE '2024-03-02', 'unpaid', NULL);

COMMIT;

-- ============================================================================
-- PART 2: COLLEGE MANAGEMENT SYSTEM
-- ============================================================================

-- Table: DEPARTMENT
-- Stores academic department information
CREATE TABLE DEPARTMENT (
    dept_id NUMBER PRIMARY KEY,
    dept_name VARCHAR2(100) NOT NULL,
    dept_code VARCHAR2(10) NOT NULL,
    building VARCHAR2(50),
    phone VARCHAR2(20),
    email VARCHAR2(100),
    head_of_dept VARCHAR2(100),
    CONSTRAINT uk_dept_name UNIQUE (dept_name),
    CONSTRAINT uk_dept_code UNIQUE (dept_code),
    CONSTRAINT chk_dept_email CHECK (email LIKE '%@%')
);

-- Table: FACULTY
-- Stores faculty member information
CREATE TABLE FACULTY (
    faculty_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) NOT NULL,
    phone VARCHAR2(20),
    dept_id NUMBER NOT NULL,
    designation VARCHAR2(50),
    hire_date DATE DEFAULT SYSDATE,
    salary NUMBER(10,2),
    specialization VARCHAR2(100),
    CONSTRAINT fk_faculty_dept FOREIGN KEY (dept_id) 
        REFERENCES DEPARTMENT(dept_id) ON DELETE RESTRICT,
    CONSTRAINT uk_faculty_email UNIQUE (email),
    CONSTRAINT chk_faculty_email CHECK (email LIKE '%@%'),
    CONSTRAINT chk_faculty_salary CHECK (salary > 0)
);

-- Table: STUDENT
-- Stores student information
CREATE TABLE STUDENT (
    student_id NUMBER PRIMARY KEY,
    enrollment_no VARCHAR2(20) NOT NULL,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) NOT NULL,
    phone VARCHAR2(20),
    dept_id NUMBER NOT NULL,
    program VARCHAR2(50) NOT NULL,
    semester NUMBER NOT NULL,
    admission_date DATE DEFAULT SYSDATE,
    status VARCHAR2(20) DEFAULT 'active',
    CONSTRAINT fk_student_dept FOREIGN KEY (dept_id) 
        REFERENCES DEPARTMENT(dept_id) ON DELETE RESTRICT,
    CONSTRAINT uk_student_enrollment UNIQUE (enrollment_no),
    CONSTRAINT uk_student_email UNIQUE (email),
    CONSTRAINT chk_student_email CHECK (email LIKE '%@%'),
    CONSTRAINT chk_student_semester CHECK (semester BETWEEN 1 AND 8),
    CONSTRAINT chk_student_status CHECK (status IN ('active', 'graduated', 'suspended', 'dropout'))
);

-- Table: COURSE
-- Stores course information
CREATE TABLE COURSE (
    course_id NUMBER PRIMARY KEY,
    course_code VARCHAR2(20) NOT NULL,
    course_name VARCHAR2(100) NOT NULL,
    dept_id NUMBER NOT NULL,
    faculty_id NUMBER,
    credits NUMBER NOT NULL,
    semester NUMBER NOT NULL,
    course_type VARCHAR2(20) DEFAULT 'theory',
    CONSTRAINT fk_course_dept FOREIGN KEY (dept_id) 
        REFERENCES DEPARTMENT(dept_id) ON DELETE RESTRICT,
    CONSTRAINT fk_course_faculty FOREIGN KEY (faculty_id) 
        REFERENCES FACULTY(faculty_id) ON DELETE SET NULL,
    CONSTRAINT uk_course_code UNIQUE (course_code),
    CONSTRAINT chk_course_credits CHECK (credits > 0),
    CONSTRAINT chk_course_semester CHECK (semester BETWEEN 1 AND 8),
    CONSTRAINT chk_course_type CHECK (course_type IN ('theory', 'lab', 'practical', 'project'))
);

-- Table: ENROLLMENT (Junction table with additional attributes)
-- Records student enrollment in courses
CREATE TABLE ENROLLMENT (
    enrollment_id NUMBER PRIMARY KEY,
    student_id NUMBER NOT NULL,
    course_id NUMBER NOT NULL,
    academic_year VARCHAR2(10) NOT NULL,
    enrollment_date DATE DEFAULT SYSDATE,
    attendance_percentage NUMBER(5,2) DEFAULT 0,
    grade VARCHAR2(2),
    marks NUMBER(5,2),
    CONSTRAINT fk_enrollment_student FOREIGN KEY (student_id) 
        REFERENCES STUDENT(student_id) ON DELETE CASCADE,
    CONSTRAINT fk_enrollment_course FOREIGN KEY (course_id) 
        REFERENCES COURSE(course_id) ON DELETE CASCADE,
    CONSTRAINT uk_enrollment UNIQUE (student_id, course_id, academic_year),
    CONSTRAINT chk_enrollment_attendance CHECK (attendance_percentage BETWEEN 0 AND 100),
    CONSTRAINT chk_enrollment_grade CHECK (grade IN ('A+', 'A', 'B+', 'B', 'C+', 'C', 'D', 'F', 'I')),
    CONSTRAINT chk_enrollment_marks CHECK (marks IS NULL OR marks >= 0)
);

-- Table: CLASSROOM
-- Stores classroom information
CREATE TABLE CLASSROOM (
    room_id NUMBER PRIMARY KEY,
    room_number VARCHAR2(20) NOT NULL,
    building VARCHAR2(50) NOT NULL,
    capacity NUMBER NOT NULL,
    room_type VARCHAR2(30) DEFAULT 'classroom',
    facilities VARCHAR2(200),
    CONSTRAINT uk_room_number UNIQUE (room_number),
    CONSTRAINT chk_room_capacity CHECK (capacity > 0),
    CONSTRAINT chk_room_type CHECK (room_type IN ('classroom', 'lab', 'seminar_hall', 'auditorium'))
);

-- Table: CLASS_SCHEDULE
-- Stores class schedules
CREATE TABLE CLASS_SCHEDULE (
    schedule_id NUMBER PRIMARY KEY,
    course_id NUMBER NOT NULL,
    room_id NUMBER NOT NULL,
    day_of_week VARCHAR2(10) NOT NULL,
    start_time VARCHAR2(8) NOT NULL,
    end_time VARCHAR2(8) NOT NULL,
    academic_year VARCHAR2(10) NOT NULL,
    CONSTRAINT fk_schedule_course FOREIGN KEY (course_id) 
        REFERENCES COURSE(course_id) ON DELETE CASCADE,
    CONSTRAINT fk_schedule_room FOREIGN KEY (room_id) 
        REFERENCES CLASSROOM(room_id) ON DELETE RESTRICT,
    CONSTRAINT chk_schedule_day CHECK (day_of_week IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'))
);

-- Table: ASSIGNMENT
-- Stores assignment information
CREATE TABLE ASSIGNMENT (
    assignment_id NUMBER PRIMARY KEY,
    course_id NUMBER NOT NULL,
    title VARCHAR2(200) NOT NULL,
    description CLOB,
    issue_date DATE DEFAULT SYSDATE,
    due_date DATE NOT NULL,
    max_marks NUMBER NOT NULL,
    CONSTRAINT fk_assignment_course FOREIGN KEY (course_id) 
        REFERENCES COURSE(course_id) ON DELETE CASCADE,
    CONSTRAINT chk_assignment_dates CHECK (due_date > issue_date),
    CONSTRAINT chk_assignment_marks CHECK (max_marks > 0)
);

-- Table: SUBMISSION (Junction table with additional attributes)
-- Records student assignment submissions
CREATE TABLE SUBMISSION (
    submission_id NUMBER PRIMARY KEY,
    assignment_id NUMBER NOT NULL,
    student_id NUMBER NOT NULL,
    submission_date DATE DEFAULT SYSDATE,
    submission_file VARCHAR2(500),
    marks_obtained NUMBER(5,2),
    feedback VARCHAR2(1000),
    CONSTRAINT fk_submission_assignment FOREIGN KEY (assignment_id) 
        REFERENCES ASSIGNMENT(assignment_id) ON DELETE CASCADE,
    CONSTRAINT fk_submission_student FOREIGN KEY (student_id) 
        REFERENCES STUDENT(student_id) ON DELETE CASCADE,
    CONSTRAINT uk_submission UNIQUE (assignment_id, student_id),
    CONSTRAINT chk_submission_marks CHECK (marks_obtained IS NULL OR marks_obtained >= 0)
);

-- Table: ATTENDANCE
-- Records student attendance
CREATE TABLE ATTENDANCE (
    attendance_id NUMBER PRIMARY KEY,
    student_id NUMBER NOT NULL,
    schedule_id NUMBER NOT NULL,
    attendance_date DATE DEFAULT SYSDATE,
    status VARCHAR2(10) NOT NULL,
    remarks VARCHAR2(200),
    CONSTRAINT fk_attendance_student FOREIGN KEY (student_id) 
        REFERENCES STUDENT(student_id) ON DELETE CASCADE,
    CONSTRAINT fk_attendance_schedule FOREIGN KEY (schedule_id) 
        REFERENCES CLASS_SCHEDULE(schedule_id) ON DELETE CASCADE,
    CONSTRAINT chk_attendance_status CHECK (status IN ('present', 'absent', 'late', 'excused'))
);

-- Sample Data for College Management System

-- Departments
INSERT INTO DEPARTMENT VALUES (1, 'Computer Engineering', 'CSE', 'Block A', '+1-555-2001', 'cse@college.edu', 'Dr. Robert Smith');
INSERT INTO DEPARTMENT VALUES (2, 'Mechanical Engineering', 'MECH', 'Block B', '+1-555-2002', 'mech@college.edu', 'Dr. Emily Davis');
INSERT INTO DEPARTMENT VALUES (3, 'Electrical Engineering', 'EEE', 'Block C', '+1-555-2003', 'eee@college.edu', 'Dr. Michael Brown');
INSERT INTO DEPARTMENT VALUES (4, 'Civil Engineering', 'CIVIL', 'Block D', '+1-555-2004', 'civil@college.edu', 'Dr. Sarah Wilson');

-- Faculty
INSERT INTO FACULTY VALUES (1, 'John', 'Anderson', 'john.anderson@college.edu', '+1-555-3001', 1, 'Professor', DATE '2010-08-15', 85000, 'Database Systems');
INSERT INTO FACULTY VALUES (2, 'Mary', 'Thompson', 'mary.thompson@college.edu', '+1-555-3002', 1, 'Associate Professor', DATE '2015-01-10', 70000, 'Web Development');
INSERT INTO FACULTY VALUES (3, 'James', 'Wilson', 'james.wilson@college.edu', '+1-555-3003', 2, 'Professor', DATE '2008-09-01', 90000, 'Thermodynamics');
INSERT INTO FACULTY VALUES (4, 'Linda', 'Martinez', 'linda.martinez@college.edu', '+1-555-3004', 3, 'Assistant Professor', DATE '2018-07-20', 60000, 'Power Systems');
INSERT INTO FACULTY VALUES (5, 'David', 'Garcia', 'david.garcia@college.edu', '+1-555-3005', 1, 'Assistant Professor', DATE '2020-08-01', 65000, 'Data Structures');

-- Students
INSERT INTO STUDENT VALUES (1, 'CSE2024001', 'Emma', 'Johnson', 'emma.johnson@student.edu', '+1-555-4001', 1, 'B.Tech', 4, DATE '2021-08-01', 'active');
INSERT INTO STUDENT VALUES (2, 'CSE2024002', 'Liam', 'Smith', 'liam.smith@student.edu', '+1-555-4002', 1, 'B.Tech', 4, DATE '2021-08-01', 'active');
INSERT INTO STUDENT VALUES (3, 'CSE2024003', 'Olivia', 'Williams', 'olivia.williams@student.edu', '+1-555-4003', 1, 'B.Tech', 4, DATE '2021-08-01', 'active');
INSERT INTO STUDENT VALUES (4, 'MECH2024001', 'Noah', 'Brown', 'noah.brown@student.edu', '+1-555-4004', 2, 'B.Tech', 6, DATE '2020-08-01', 'active');
INSERT INTO STUDENT VALUES (5, 'EEE2024001', 'Ava', 'Jones', 'ava.jones@student.edu', '+1-555-4005', 3, 'B.Tech', 4, DATE '2021-08-01', 'active');
INSERT INTO STUDENT VALUES (6, 'CSE2024004', 'William', 'Davis', 'william.davis@student.edu', '+1-555-4006', 1, 'B.Tech', 4, DATE '2021-08-01', 'active');

-- Courses
INSERT INTO COURSE VALUES (1, 'CSE401', 'Database Management Systems', 1, 1, 4, 4, 'theory');
INSERT INTO COURSE VALUES (2, 'CSE402', 'Web Technologies', 1, 2, 3, 4, 'theory');
INSERT INTO COURSE VALUES (3, 'CSE403', 'Data Structures', 1, 5, 4, 4, 'theory');
INSERT INTO COURSE VALUES (4, 'CSE404', 'Database Lab', 1, 1, 2, 4, 'lab');
INSERT INTO COURSE VALUES (5, 'MECH601', 'Thermodynamics-II', 2, 3, 4, 6, 'theory');
INSERT INTO COURSE VALUES (6, 'EEE401', 'Power Systems', 3, 4, 4, 4, 'theory');

-- Enrollments
INSERT INTO ENROLLMENT VALUES (1, 1, 1, '2024-25', DATE '2024-08-01', 85.50, 'A', 88.5);
INSERT INTO ENROLLMENT VALUES (2, 1, 2, '2024-25', DATE '2024-08-01', 90.00, 'A+', 95.0);
INSERT INTO ENROLLMENT VALUES (3, 2, 1, '2024-25', DATE '2024-08-01', 78.25, 'B+', 82.0);
INSERT INTO ENROLLMENT VALUES (4, 2, 3, '2024-25', DATE '2024-08-01', 82.00, 'A', 85.5);
INSERT INTO ENROLLMENT VALUES (5, 3, 1, '2024-25', DATE '2024-08-01', 92.50, 'A+', 94.0);
INSERT INTO ENROLLMENT VALUES (6, 6, 2, '2024-25', DATE '2024-08-01', 75.00, 'B', 78.5);
INSERT INTO ENROLLMENT VALUES (7, 4, 5, '2024-25', DATE '2024-08-01', 88.00, 'A', 87.0);
INSERT INTO ENROLLMENT VALUES (8, 5, 6, '2024-25', DATE '2024-08-01', 80.50, 'B+', 81.0);

-- Classrooms
INSERT INTO CLASSROOM VALUES (1, 'A-101', 'Block A', 60, 'classroom', 'Projector, Smart Board, AC');
INSERT INTO CLASSROOM VALUES (2, 'A-201', 'Block A', 40, 'lab', '40 Computers, Projector, AC');
INSERT INTO CLASSROOM VALUES (3, 'B-101', 'Block B', 80, 'classroom', 'Projector, Sound System');
INSERT INTO CLASSROOM VALUES (4, 'C-101', 'Block C', 50, 'lab', '30 Workstations, Oscilloscopes');
INSERT INTO CLASSROOM VALUES (5, 'Main-Hall', 'Admin Block', 300, 'auditorium', 'Stage, Sound System, Projector');

-- Class Schedules
INSERT INTO CLASS_SCHEDULE VALUES (1, 1, 1, 'Monday', '09:00', '10:00', '2024-25');
INSERT INTO CLASS_SCHEDULE VALUES (2, 1, 1, 'Wednesday', '09:00', '10:00', '2024-25');
INSERT INTO CLASS_SCHEDULE VALUES (3, 2, 1, 'Tuesday', '10:00', '11:00', '2024-25');
INSERT INTO CLASS_SCHEDULE VALUES (4, 2, 1, 'Thursday', '10:00', '11:00', '2024-25');
INSERT INTO CLASS_SCHEDULE VALUES (5, 3, 1, 'Monday', '11:00', '12:00', '2024-25');
INSERT INTO CLASS_SCHEDULE VALUES (6, 4, 2, 'Friday', '14:00', '17:00', '2024-25');

-- Assignments
INSERT INTO ASSIGNMENT VALUES (1, 1, 'ER Diagram Design', 'Design an ER diagram for a hospital management system', DATE '2024-02-01', DATE '2024-02-15', 20);
INSERT INTO ASSIGNMENT VALUES (2, 1, 'SQL Queries', 'Write 20 SQL queries on given database', DATE '2024-02-10', DATE '2024-02-24', 30);
INSERT INTO ASSIGNMENT VALUES (3, 2, 'HTML/CSS Project', 'Create a responsive website using HTML and CSS', DATE '2024-02-05', DATE '2024-02-25', 40);
INSERT INTO ASSIGNMENT VALUES (4, 3, 'Binary Search Tree Implementation', 'Implement BST in C with all operations', DATE '2024-02-08', DATE '2024-02-22', 25);

-- Submissions
INSERT INTO SUBMISSION VALUES (1, 1, 1, DATE '2024-02-14', '/uploads/student1_assignment1.pdf', 18.5, 'Good work, well-structured diagram');
INSERT INTO SUBMISSION VALUES (2, 1, 2, DATE '2024-02-13', '/uploads/student2_assignment1.pdf', 16.0, 'Missing some relationships');
INSERT INTO SUBMISSION VALUES (3, 2, 1, DATE '2024-02-24', '/uploads/student1_assignment2.sql', 28.0, 'Excellent queries');
INSERT INTO SUBMISSION VALUES (4, 3, 1, DATE '2024-02-23', '/uploads/student1_assignment3.zip', 38.0, 'Very good design');
INSERT INTO SUBMISSION VALUES (5, 4, 2, DATE '2024-02-21', '/uploads/student2_assignment4.c', 23.5, 'Well implemented');

-- Attendance
INSERT INTO ATTENDANCE VALUES (1, 1, 1, DATE '2024-02-05', 'present', NULL);
INSERT INTO ATTENDANCE VALUES (2, 1, 2, DATE '2024-02-07', 'present', NULL);
INSERT INTO ATTENDANCE VALUES (3, 2, 1, DATE '2024-02-05', 'present', NULL);
INSERT INTO ATTENDANCE VALUES (4, 2, 2, DATE '2024-02-07', 'absent', 'Sick leave');
INSERT INTO ATTENDANCE VALUES (5, 3, 1, DATE '2024-02-05', 'present', NULL);
INSERT INTO ATTENDANCE VALUES (6, 3, 2, DATE '2024-02-07', 'late', 'Arrived 10 minutes late');
INSERT INTO ATTENDANCE VALUES (7, 6, 3, DATE '2024-02-06', 'present', NULL);

COMMIT;

-- ============================================================================
-- SAMPLE QUERIES
-- ============================================================================

PROMPT
PROMPT ======== LIBRARY MANAGEMENT SYSTEM QUERIES ========
PROMPT

PROMPT 1. Books with their authors and publishers
SELECT B.title, A.first_name || ' ' || A.last_name AS author_name, 
       P.name AS publisher, B.genre
FROM BOOK B
JOIN BOOK_AUTHOR BA ON B.book_id = BA.book_id
JOIN AUTHOR A ON BA.author_id = A.author_id
JOIN PUBLISHER P ON B.publisher_id = P.publisher_id
ORDER BY B.title;

PROMPT
PROMPT 2. Currently borrowed books
SELECT M.first_name || ' ' || M.last_name AS member_name,
       B.title, LB.branch_name, BR.borrow_date, BR.due_date,
       CASE 
           WHEN BR.due_date < SYSDATE THEN 'OVERDUE'
           ELSE 'ACTIVE'
       END AS borrow_status
FROM BORROWING BR
JOIN MEMBER M ON BR.member_id = M.member_id
JOIN BOOK_COPY BC ON BR.copy_id = BC.copy_id
JOIN BOOK B ON BC.book_id = B.book_id
JOIN LIBRARY_BRANCH LB ON BC.branch_id = LB.branch_id
WHERE BR.status IN ('active', 'overdue');

PROMPT
PROMPT 3. Members with outstanding fines
SELECT M.first_name || ' ' || M.last_name AS member_name,
       M.email, COUNT(F.fine_id) AS fine_count,
       SUM(F.amount) AS total_amount_due
FROM MEMBER M
JOIN FINE F ON M.member_id = F.member_id
WHERE F.status = 'unpaid'
GROUP BY M.member_id, M.first_name, M.last_name, M.email
ORDER BY total_amount_due DESC;

PROMPT
PROMPT 4. Book availability by branch
SELECT LB.branch_name, B.title,
       COUNT(CASE WHEN BC.status = 'available' THEN 1 END) AS available_copies,
       COUNT(BC.copy_id) AS total_copies
FROM LIBRARY_BRANCH LB
CROSS JOIN BOOK B
LEFT JOIN BOOK_COPY BC ON LB.branch_id = BC.branch_id AND B.book_id = BC.book_id
GROUP BY LB.branch_id, LB.branch_name, B.book_id, B.title
HAVING COUNT(BC.copy_id) > 0
ORDER BY LB.branch_name, B.title;

PROMPT
PROMPT ======== COLLEGE MANAGEMENT SYSTEM QUERIES ========
PROMPT

PROMPT 5. Students enrolled in each course with grades
SELECT C.course_code, C.course_name,
       S.enrollment_no, S.first_name || ' ' || S.last_name AS student_name,
       E.grade, E.marks, E.attendance_percentage
FROM COURSE C
JOIN ENROLLMENT E ON C.course_id = E.course_id
JOIN STUDENT S ON E.student_id = S.student_id
WHERE E.academic_year = '2024-25'
ORDER BY C.course_code, E.marks DESC;

PROMPT
PROMPT 6. Faculty teaching schedule
SELECT F.first_name || ' ' || F.last_name AS faculty_name,
       C.course_code, C.course_name,
       CS.day_of_week, CS.start_time, CS.end_time,
       CL.room_number
FROM FACULTY F
JOIN COURSE C ON F.faculty_id = C.faculty_id
JOIN CLASS_SCHEDULE CS ON C.course_id = CS.course_id
JOIN CLASSROOM CL ON CS.room_id = CL.room_id
WHERE CS.academic_year = '2024-25'
ORDER BY F.last_name, CS.day_of_week, CS.start_time;

PROMPT
PROMPT 7. Assignment submission status
SELECT C.course_name, A.title AS assignment_title,
       S.enrollment_no, S.first_name || ' ' || S.last_name AS student_name,
       CASE 
           WHEN SB.submission_id IS NOT NULL THEN 'Submitted'
           ELSE 'Not Submitted'
       END AS submission_status,
       SB.marks_obtained, A.max_marks
FROM COURSE C
JOIN ASSIGNMENT A ON C.course_id = A.course_id
CROSS JOIN STUDENT S
JOIN ENROLLMENT E ON S.student_id = E.student_id AND C.course_id = E.course_id
LEFT JOIN SUBMISSION SB ON A.assignment_id = SB.assignment_id 
    AND S.student_id = SB.student_id
WHERE E.academic_year = '2024-25'
ORDER BY C.course_name, A.title, S.enrollment_no;

PROMPT
PROMPT 8. Student attendance summary
SELECT S.enrollment_no, S.first_name || ' ' || S.last_name AS student_name,
       COUNT(A.attendance_id) AS total_classes,
       COUNT(CASE WHEN A.status = 'present' THEN 1 END) AS present_count,
       COUNT(CASE WHEN A.status = 'absent' THEN 1 END) AS absent_count,
       ROUND(COUNT(CASE WHEN A.status = 'present' THEN 1 END) * 100.0 / 
             NULLIF(COUNT(A.attendance_id), 0), 2) AS attendance_percentage
FROM STUDENT S
LEFT JOIN ATTENDANCE A ON S.student_id = A.student_id
GROUP BY S.student_id, S.enrollment_no, S.first_name, S.last_name
ORDER BY S.enrollment_no;

PROMPT
PROMPT ======== Script execution completed ========
PROMPT
