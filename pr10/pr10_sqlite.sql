-- ================================================================================
-- Practical No. 10: Create, Alter, and Update Views (SQLite Version)
-- ================================================================================
-- This practical demonstrates working with database views in SQLite:
-- CREATE VIEW, DROP VIEW
-- Note: SQLite doesn't support ALTER VIEW - must DROP and recreate
-- ================================================================================

-- Enable output formatting
.mode column
.headers on
.width 12 15 15 30 20 8 12

-- ================================================================================
-- Setup: Create sample tables for demonstration
-- ================================================================================

DROP TABLE IF EXISTS employees_sample;
DROP TABLE IF EXISTS departments_sample;
DROP TABLE IF EXISTS jobs_sample;

-- Create tables
CREATE TABLE departments_sample (
    DEPARTMENT_ID INTEGER PRIMARY KEY,
    DEPARTMENT_NAME TEXT,
    MANAGER_ID INTEGER,
    LOCATION_ID INTEGER
);

CREATE TABLE jobs_sample (
    JOB_ID TEXT PRIMARY KEY,
    JOB_TITLE TEXT,
    MIN_SALARY REAL,
    MAX_SALARY REAL
);

CREATE TABLE employees_sample (
    EMPLOYEE_ID INTEGER PRIMARY KEY,
    FIRST_NAME TEXT,
    LAST_NAME TEXT,
    EMAIL TEXT,
    PHONE_NUMBER TEXT,
    HIRE_DATE TEXT,
    JOB_ID TEXT,
    SALARY REAL,
    COMMISSION_PCT REAL,
    MANAGER_ID INTEGER,
    DEPARTMENT_ID INTEGER,
    FOREIGN KEY (JOB_ID) REFERENCES jobs_sample(JOB_ID),
    FOREIGN KEY (DEPARTMENT_ID) REFERENCES departments_sample(DEPARTMENT_ID),
    FOREIGN KEY (MANAGER_ID) REFERENCES employees_sample(EMPLOYEE_ID)
);

-- Insert sample data
INSERT INTO departments_sample VALUES (10, 'Administration', 200, 1700);
INSERT INTO departments_sample VALUES (20, 'Marketing', 201, 1800);
INSERT INTO departments_sample VALUES (30, 'Purchasing', 114, 1700);
INSERT INTO departments_sample VALUES (40, 'Human Resources', 203, 2400);
INSERT INTO departments_sample VALUES (50, 'Shipping', 121, 1500);
INSERT INTO departments_sample VALUES (60, 'IT', 103, 1400);
INSERT INTO departments_sample VALUES (70, 'Public Relations', 204, 2700);
INSERT INTO departments_sample VALUES (80, 'Sales', 145, 2500);
INSERT INTO departments_sample VALUES (90, 'Executive', 100, 1700);
INSERT INTO departments_sample VALUES (100, 'Finance', 108, 1700);

INSERT INTO jobs_sample VALUES ('AD_PRES', 'President', 20000, 40000);
INSERT INTO jobs_sample VALUES ('AD_VP', 'Administration Vice President', 15000, 30000);
INSERT INTO jobs_sample VALUES ('AD_ASST', 'Administration Assistant', 3000, 6000);
INSERT INTO jobs_sample VALUES ('FI_MGR', 'Finance Manager', 8200, 16000);
INSERT INTO jobs_sample VALUES ('FI_ACCOUNT', 'Accountant', 4200, 9000);
INSERT INTO jobs_sample VALUES ('IT_PROG', 'Programmer', 4000, 10000);
INSERT INTO jobs_sample VALUES ('SA_MAN', 'Sales Manager', 10000, 20000);
INSERT INTO jobs_sample VALUES ('SA_REP', 'Sales Representative', 6000, 12000);
INSERT INTO jobs_sample VALUES ('MK_MAN', 'Marketing Manager', 9000, 15000);
INSERT INTO jobs_sample VALUES ('MK_REP', 'Marketing Representative', 4000, 9000);
INSERT INTO jobs_sample VALUES ('PU_CLERK', 'Purchasing Clerk', 2500, 5500);
INSERT INTO jobs_sample VALUES ('ST_CLERK', 'Stock Clerk', 2000, 5000);

INSERT INTO employees_sample VALUES (100, 'Steven', 'King', 'SKING', '515.123.4567', '2003-06-17', 'AD_PRES', 24000, NULL, NULL, 90);
INSERT INTO employees_sample VALUES (101, 'Neena', 'Kochhar', 'NKOCHHAR', '515.123.4568', '2005-09-21', 'AD_VP', 17000, NULL, 100, 90);
INSERT INTO employees_sample VALUES (102, 'Lex', 'De Haan', 'LDEHAAN', '515.123.4569', '2001-01-13', 'AD_VP', 17000, NULL, 100, 90);
INSERT INTO employees_sample VALUES (103, 'Alexander', 'Hunold', 'AHUNOLD', '590.423.4567', '2006-01-03', 'IT_PROG', 9000, NULL, 102, 60);
INSERT INTO employees_sample VALUES (108, 'Nancy', 'Greenberg', 'NGREENBE', '515.124.4569', '2002-08-17', 'FI_MGR', 12000, NULL, 101, 100);
INSERT INTO employees_sample VALUES (109, 'Daniel', 'Faviet', 'DFAVIET', '515.124.4169', '2002-08-16', 'FI_ACCOUNT', 9000, NULL, 108, 100);
INSERT INTO employees_sample VALUES (110, 'John', 'Chen', 'JCHEN', '515.124.4269', '2005-09-28', 'FI_ACCOUNT', 8200, NULL, 108, 100);
INSERT INTO employees_sample VALUES (114, 'Den', 'Raphaely', 'DRAPHEAL', '515.127.4561', '2002-12-07', 'PU_CLERK', 11000, NULL, 100, 30);
INSERT INTO employees_sample VALUES (115, 'Alexander', 'Khoo', 'AKHOO', '515.127.4562', '2003-05-18', 'PU_CLERK', 3100, NULL, 114, 30);
INSERT INTO employees_sample VALUES (116, 'Shelli', 'Baida', 'SBAIDA', '515.127.4563', '2005-12-24', 'PU_CLERK', 2900, NULL, 114, 30);
INSERT INTO employees_sample VALUES (145, 'John', 'Russell', 'JRUSSEL', '011.44.1344.429268', '2004-10-01', 'SA_MAN', 14000, 0.40, 100, 80);
INSERT INTO employees_sample VALUES (146, 'Karen', 'Partners', 'KPARTNER', '011.44.1344.467268', '2005-01-05', 'SA_MAN', 13500, 0.30, 100, 80);
INSERT INTO employees_sample VALUES (200, 'Jennifer', 'Whalen', 'JWHALEN', '515.123.4444', '2003-09-17', 'AD_ASST', 4400, NULL, 101, 10);
INSERT INTO employees_sample VALUES (201, 'Michael', 'Hartstein', 'MHARTSTE', '515.123.5555', '2004-02-17', 'MK_MAN', 13000, NULL, 100, 20);
INSERT INTO employees_sample VALUES (202, 'Pat', 'Fay', 'PFAY', '603.123.6666', '2005-08-17', 'MK_REP', 6000, NULL, 201, 20);

-- ================================================================================
-- QUERY 1: Create a view called "employee_info"
-- ================================================================================
-- Shows employee's first name, last name, job title, department name, and salary

SELECT '========================================' AS '';
SELECT 'Query 1: Create employee_info View' AS '';
SELECT '========================================' AS '';

DROP VIEW IF EXISTS employee_info;

CREATE VIEW employee_info AS
SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME,
    E.LAST_NAME,
    J.JOB_TITLE,
    D.DEPARTMENT_NAME,
    E.SALARY
FROM 
    employees_sample E
    LEFT JOIN jobs_sample J ON E.JOB_ID = J.JOB_ID
    LEFT JOIN departments_sample D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;

SELECT 'View employee_info created successfully!' AS '';
SELECT '' AS '';
SELECT 'Selecting first 10 rows from employee_info:' AS '';

SELECT * FROM employee_info
LIMIT 10;

-- ================================================================================
-- QUERY 2: Add a new column called "hire_date" to the "employee_info" view
-- ================================================================================
-- In SQLite, you must DROP and recreate the view to alter it

SELECT '========================================' AS '';
SELECT 'Query 2: Add hire_date Column to View' AS '';
SELECT '========================================' AS '';

DROP VIEW IF EXISTS employee_info;

CREATE VIEW employee_info AS
SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME,
    E.LAST_NAME,
    J.JOB_TITLE,
    D.DEPARTMENT_NAME,
    E.SALARY,
    E.HIRE_DATE
FROM 
    employees_sample E
    LEFT JOIN jobs_sample J ON E.JOB_ID = J.JOB_ID
    LEFT JOIN departments_sample D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;

SELECT 'View employee_info updated with hire_date column!' AS '';
SELECT '' AS '';
SELECT 'Selecting first 10 rows from updated employee_info:' AS '';

SELECT * FROM employee_info
LIMIT 10;

-- ================================================================================
-- QUERY 3: Update the view to show only employees with salary > $50,000
-- ================================================================================

SELECT '========================================' AS '';
SELECT 'Query 3: Filter View for Salary > 50000' AS '';
SELECT '========================================' AS '';

-- Note: In the lab manual, $50,000 is mentioned, but sample data has salaries in lower range
-- We'll use 10000 as threshold to have some results

DROP VIEW IF EXISTS employee_info;

CREATE VIEW employee_info AS
SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME,
    E.LAST_NAME,
    J.JOB_TITLE,
    D.DEPARTMENT_NAME,
    E.SALARY,
    E.HIRE_DATE
FROM 
    employees_sample E
    LEFT JOIN jobs_sample J ON E.JOB_ID = J.JOB_ID
    LEFT JOIN departments_sample D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE 
    E.SALARY > 10000;

SELECT 'View employee_info updated to show only salary > 10000!' AS '';
SELECT '' AS '';
SELECT 'Selecting all rows from filtered employee_info:' AS '';

SELECT * FROM employee_info
ORDER BY SALARY DESC;

-- ================================================================================
-- QUERY 4: Create a view named "my_view" showing employees in department 20
-- ================================================================================

SELECT '========================================' AS '';
SELECT 'Query 4: Create my_view for Department 20' AS '';
SELECT '========================================' AS '';

DROP VIEW IF EXISTS my_view;

CREATE VIEW my_view AS
SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME,
    E.LAST_NAME,
    E.JOB_ID,
    E.SALARY,
    E.DEPARTMENT_ID,
    D.DEPARTMENT_NAME
FROM 
    employees_sample E
    LEFT JOIN departments_sample D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE 
    E.DEPARTMENT_ID = 20;

SELECT 'View my_view created for department 20!' AS '';
SELECT '' AS '';
SELECT 'Selecting all rows from my_view:' AS '';

SELECT * FROM my_view;

-- ================================================================================
-- QUERY 5: Alter "my_view" to show only employees in department 30
-- ================================================================================
-- SQLite doesn't support ALTER VIEW - must DROP and recreate

SELECT '========================================' AS '';
SELECT 'Query 5: Alter my_view for Department 30' AS '';
SELECT '========================================' AS '';

DROP VIEW IF EXISTS my_view;

CREATE VIEW my_view AS
SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME,
    E.LAST_NAME,
    E.JOB_ID,
    E.SALARY,
    E.DEPARTMENT_ID,
    D.DEPARTMENT_NAME
FROM 
    employees_sample E
    LEFT JOIN departments_sample D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE 
    E.DEPARTMENT_ID = 30;

SELECT 'View my_view altered (recreated) to show department 30!' AS '';
SELECT '' AS '';
SELECT 'Selecting all rows from altered my_view:' AS '';

SELECT * FROM my_view;

-- ================================================================================
-- QUERY 6: Drop the "my_view" view from the database
-- ================================================================================

SELECT '========================================' AS '';
SELECT 'Query 6: Drop my_view' AS '';
SELECT '========================================' AS '';

DROP VIEW IF EXISTS my_view;

SELECT 'View my_view dropped successfully!' AS '';
SELECT '' AS '';
SELECT 'Attempting to query deleted view (next query will be commented):' AS '';
-- SELECT * FROM my_view;  -- This will fail: no such table: my_view

-- ================================================================================
-- ADDITIONAL EXAMPLES: Working with Views
-- ================================================================================

-- ================================================================================
-- Example 1: Simple View - Department Employee Count
-- ================================================================================

SELECT '========================================' AS '';
SELECT 'Example 1: Create dept_stats View' AS '';
SELECT '========================================' AS '';

DROP VIEW IF EXISTS dept_stats;

CREATE VIEW dept_stats AS
SELECT 
    D.DEPARTMENT_ID,
    D.DEPARTMENT_NAME,
    COUNT(E.EMPLOYEE_ID) AS EMPLOYEE_COUNT,
    ROUND(AVG(E.SALARY), 2) AS AVG_SALARY,
    MAX(E.SALARY) AS MAX_SALARY,
    MIN(E.SALARY) AS MIN_SALARY
FROM 
    departments_sample D
    LEFT JOIN employees_sample E ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
GROUP BY 
    D.DEPARTMENT_ID, D.DEPARTMENT_NAME
HAVING 
    COUNT(E.EMPLOYEE_ID) > 0;

SELECT 'View dept_stats created!' AS '';
SELECT '' AS '';
SELECT 'Department statistics:' AS '';

SELECT * FROM dept_stats
ORDER BY EMPLOYEE_COUNT DESC;

-- ================================================================================
-- Example 2: View with Complex Calculation
-- ================================================================================

SELECT '========================================' AS '';
SELECT 'Example 2: Create emp_compensation View' AS '';
SELECT '========================================' AS '';

DROP VIEW IF EXISTS emp_compensation;

CREATE VIEW emp_compensation AS
SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME,
    E.LAST_NAME,
    E.SALARY,
    E.COMMISSION_PCT,
    E.SALARY * 12 AS ANNUAL_SALARY,
    CASE 
        WHEN E.COMMISSION_PCT IS NOT NULL 
        THEN E.SALARY * 12 * (1 + E.COMMISSION_PCT)
        ELSE E.SALARY * 12
    END AS TOTAL_COMPENSATION,
    D.DEPARTMENT_NAME
FROM 
    employees_sample E
    LEFT JOIN departments_sample D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;

SELECT 'View emp_compensation created!' AS '';
SELECT '' AS '';
SELECT 'Employee compensation details (top 10 by total compensation):' AS '';

SELECT * FROM emp_compensation
ORDER BY TOTAL_COMPENSATION DESC
LIMIT 10;

-- ================================================================================
-- Example 3: View with Subquery
-- ================================================================================

SELECT '========================================' AS '';
SELECT 'Example 3: Create high_earners View' AS '';
SELECT '========================================' AS '';

DROP VIEW IF EXISTS high_earners;

CREATE VIEW high_earners AS
SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME,
    E.LAST_NAME,
    E.SALARY,
    D.DEPARTMENT_NAME,
    J.JOB_TITLE
FROM 
    employees_sample E
    LEFT JOIN departments_sample D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
    LEFT JOIN jobs_sample J ON E.JOB_ID = J.JOB_ID
WHERE 
    E.SALARY > (SELECT AVG(SALARY) FROM employees_sample);

SELECT 'View high_earners created (employees earning above average)!' AS '';
SELECT '' AS '';
SELECT 'High earners list:' AS '';

SELECT * FROM high_earners
ORDER BY SALARY DESC;

-- ================================================================================
-- Example 4: Updatable View
-- ================================================================================

SELECT '========================================' AS '';
SELECT 'Example 4: Create updatable_emp View' AS '';
SELECT '========================================' AS '';

-- Note: SQLite supports updatable views with some restrictions:
-- - Must be based on a single table
-- - No DISTINCT, GROUP BY, HAVING, or aggregate functions
-- - No UNION, INTERSECT, or EXCEPT operators

DROP VIEW IF EXISTS updatable_emp;

CREATE VIEW updatable_emp AS
SELECT 
    EMPLOYEE_ID,
    FIRST_NAME,
    LAST_NAME,
    EMAIL,
    SALARY,
    DEPARTMENT_ID
FROM 
    employees_sample
WHERE 
    DEPARTMENT_ID = 60;

SELECT 'View updatable_emp created!' AS '';
SELECT 'This view can be used for INSERT, UPDATE, and DELETE operations.' AS '';
SELECT '' AS '';
SELECT 'Current data in updatable_emp:' AS '';

SELECT * FROM updatable_emp;

-- Example of updating through view (commented out to prevent actual changes):
-- UPDATE updatable_emp SET SALARY = SALARY * 1.10 WHERE EMPLOYEE_ID = 103;

-- ================================================================================
-- Viewing Metadata about Views
-- ================================================================================

SELECT '========================================' AS '';
SELECT 'View Metadata (sqlite_master)' AS '';
SELECT '========================================' AS '';

SELECT 
    name AS VIEW_NAME,
    LENGTH(sql) AS SQL_LENGTH
FROM 
    sqlite_master
WHERE 
    type = 'view' 
    AND name IN ('employee_info', 'dept_stats', 'high_earners', 'updatable_emp', 'emp_compensation')
ORDER BY 
    name;

-- ================================================================================
-- Clean up created views (optional)
-- ================================================================================

SELECT '========================================' AS '';
SELECT 'Cleanup (Optional)' AS '';
SELECT '========================================' AS '';

-- Uncomment these lines to drop all created views:
-- DROP VIEW IF EXISTS employee_info;
-- DROP VIEW IF EXISTS dept_stats;
-- DROP VIEW IF EXISTS emp_compensation;
-- DROP VIEW IF EXISTS high_earners;
-- DROP VIEW IF EXISTS updatable_emp;

-- SELECT 'All views dropped!' AS '';

-- ================================================================================
-- VIEW OPERATIONS SUMMARY
-- ================================================================================

SELECT '========================================' AS '';
SELECT 'SQLITE VIEW NOTES' AS '';
SELECT '========================================' AS '';

SELECT 'CREATE VIEW' AS "Operation", 'Supported - creates virtual table' AS "Status";
SELECT 'DROP VIEW' AS "Operation", 'Supported - with IF EXISTS clause recommended' AS "Status";
SELECT 'ALTER VIEW' AS "Operation", 'NOT supported - must DROP and recreate' AS "Status";
SELECT 'WITH CHECK OPTION' AS "Operation", 'NOT supported in SQLite' AS "Status";
SELECT 'WITH READ ONLY' AS "Operation", 'NOT supported in SQLite' AS "Status";
SELECT 'CREATE OR REPLACE' AS "Operation", 'NOT supported - use DROP IF EXISTS then CREATE' AS "Status";
SELECT 'Updatable Views' AS "Operation", 'Supported with restrictions (single table, no aggregates)' AS "Status";

-- ================================================================================
-- End of Practical 10 (SQLite Version)
-- ================================================================================
