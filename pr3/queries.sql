-- Demonstration Queries for Practical No.3

-- 1. Select all users
SELECT "--- All Users ---";
SELECT * FROM users;

-- 2. Select specific columns from products
SELECT "--- Product Names and Prices ---";
SELECT name, price FROM products;

-- 3. Find orders for a specific user (Alice) with product details
-- JOIN operation
SELECT "--- Alice's Orders ---";
SELECT 
    u.name AS User, 
    p.name AS Product, 
    o.quantity AS Quantity,
    (p.price * o.quantity) AS Total_Cost
FROM orders o
JOIN users u ON o.user_id = u.id
JOIN products p ON o.product_id = p.id
WHERE u.name LIKE 'Alice%';

-- 4. List all students and their enrolled courses
SELECT "--- Student Enrollments ---";
SELECT 
    s.name AS Student, 
    c.name AS Course, 
    e.semester, 
    e.year
FROM Enrollments e
JOIN Students s ON e.student_id = s.student_id
JOIN Courses c ON e.course_id = c.course_id;

-- 5. Calculate average price of products
SELECT "--- Average Product Price ---";
SELECT AVG(price) AS Average_Price FROM products;

-- 6. Count number of students in each course
SELECT "--- Student Count per Course ---";
SELECT 
    c.name AS Course, 
    COUNT(e.student_id) AS Student_Count
FROM Enrollments e
JOIN Courses c ON e.course_id = c.course_id
GROUP BY c.name;
