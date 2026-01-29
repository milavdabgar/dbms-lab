-- Sample Data for Practical No.3
PRAGMA foreign_keys = ON;

-- Insert into users
INSERT INTO users (name, email, password) VALUES 
('Alice Johnson', 'alice@example.com', 'password123'),
('Bob Smith', 'bob@example.com', 'securepass456'),
('Charlie Brown', 'charlie@example.com', 'mypassword789');

-- Insert into products
INSERT INTO products (name, price, description) VALUES 
('Laptop', 1200.00, 'High performance laptop'),
('Smartphone', 800.00, 'Latest model smartphone'),
('Headphones', 150.00, 'Noise cancelling headphones');

-- Insert into orders
-- Assuming IDs 1, 2, 3 generated above
INSERT INTO orders (user_id, product_id, quantity) VALUES 
(1, 1, 1), -- Alice bought a Laptop
(1, 3, 2), -- Alice bought 2 Headphones
(2, 2, 1); -- Bob bought a Smartphone

-- Insert into Students
INSERT INTO Students (name, age, gender, address) VALUES 
('John Doe', 20, 'Male', '123 Maple St'),
('Jane Roe', 21, 'Female', '456 Oak Ave'),
('Sam Wilson', 22, 'Male', '789 Pine Rd');

-- Insert into Courses
INSERT INTO Courses (name, credits, instructor) VALUES 
('Database Systems', 4, 'Dr. Codd'),
('Operating Systems', 4, 'Dr. Torvalds'),
('Data Structures', 3, 'Dr. Knuth');

-- Insert into Enrollments
-- John (1) in DBMS (1) and OS (2)
INSERT INTO Enrollments (student_id, course_id, semester, year) VALUES 
(1, 1, 'Fall', 2023),
(1, 2, 'Fall', 2023),
(2, 1, 'Fall', 2023); -- Jane in DBMS

-- Insert into Grades
-- John got A in DBMS
INSERT INTO Grades (enrollment_id, grade) VALUES 
(1, 'A'),
(2, 'B'),
(3, 'A');
