-- Practical No.3: DDL Commands
PRAGMA foreign_keys = ON;


-- 1. Create a table named "users"
CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(100),
    password VARCHAR(100)
);

-- 2. Create a table named "products"
CREATE TABLE products (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100),
    price DECIMAL(10,2),
    description TEXT
);

-- 3. Create a table named "orders"
-- Assuming ON DELETE CASCADE or NO ACTION based on standard behavior.
-- SQLite enforces FKs if PRAGMA foreign_keys = ON;
CREATE TABLE orders (
    id INTEGER PRIMARY KEY,
    user_id INTEGER,
    product_id INTEGER,
    quantity INTEGER,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- 4. Create a table named "Students"
CREATE TABLE Students (
    student_id INTEGER PRIMARY KEY,
    name VARCHAR(50),
    age INTEGER,
    gender VARCHAR(10),
    address VARCHAR(100)
);

-- 5. Create a table named "Courses"
CREATE TABLE Courses (
    course_id INTEGER PRIMARY KEY,
    name VARCHAR(50),
    credits INTEGER,
    instructor VARCHAR(50)
);

-- 6. Create a table named "Enrollments"
CREATE TABLE Enrollments (
    enrollment_id INTEGER PRIMARY KEY,
    student_id INTEGER,
    course_id INTEGER,
    semester VARCHAR(20),
    year INTEGER,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- 7. Create a table named "Grades"
CREATE TABLE Grades (
    grade_id INTEGER PRIMARY KEY,
    enrollment_id INTEGER,
    grade VARCHAR(2),
    FOREIGN KEY (enrollment_id) REFERENCES Enrollments(enrollment_id)
);
