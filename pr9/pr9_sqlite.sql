-- ================================================================================
-- Practical No. 9: Retrieve data using various Joins (SQLite Version)
-- ================================================================================
-- This practical demonstrates different types of SQL joins in SQLite:
-- INNER JOIN, LEFT OUTER JOIN
-- Note: SQLite doesn't support RIGHT JOIN and FULL OUTER JOIN natively
-- (workarounds provided using LEFT JOIN with reversed table order)
-- ================================================================================

-- Enable output formatting
.mode column
.headers on
.width 12 15 15 20 30 10

-- ================================================================================
-- Setup: Create sample tables for demonstration
-- ================================================================================

DROP TABLE IF EXISTS employees_sample;
DROP TABLE IF EXISTS departments_sample;
DROP TABLE IF EXISTS jobs_sample;
DROP TABLE IF EXISTS locations_sample;
DROP TABLE IF EXISTS countries_sample;

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

CREATE TABLE locations_sample (
    LOCATION_ID INTEGER PRIMARY KEY,
    STREET_ADDRESS TEXT,
    POSTAL_CODE TEXT,
    CITY TEXT,
    STATE_PROVINCE TEXT,
    COUNTRY_ID TEXT
);

CREATE TABLE countries_sample (
    COUNTRY_ID TEXT PRIMARY KEY,
    COUNTRY_NAME TEXT,
    REGION_ID INTEGER
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
INSERT INTO departments_sample VALUES (110, 'Accounting', 205, 1700);
INSERT INTO departments_sample VALUES (120, 'Treasury', NULL, 1700);

INSERT INTO jobs_sample VALUES ('AD_PRES', 'President', 20000, 40000);
INSERT INTO jobs_sample VALUES ('AD_VP', 'Administration Vice President', 15000, 30000);
INSERT INTO jobs_sample VALUES ('AD_ASST', 'Administration Assistant', 3000, 6000);
INSERT INTO jobs_sample VALUES ('IT_PROG', 'Programmer', 4000, 10000);
INSERT INTO jobs_sample VALUES ('SA_MAN', 'Sales Manager', 10000, 20000);
INSERT INTO jobs_sample VALUES ('SA_REP', 'Sales Representative', 6000, 12000);
INSERT INTO jobs_sample VALUES ('MK_MAN', 'Marketing Manager', 9000, 15000);
INSERT INTO jobs_sample VALUES ('MK_REP', 'Marketing Representative', 4000, 9000);
INSERT INTO jobs_sample VALUES ('ST_MAN', 'Stock Manager', 5500, 8500);
INSERT INTO jobs_sample VALUES ('ST_CLERK', 'Stock Clerk', 2000, 5000);

INSERT INTO employees_sample VALUES (100, 'Steven', 'King', 'SKING', '515.123.4567', '2003-06-17', 'AD_PRES', 24000, NULL, NULL, 90);
INSERT INTO employees_sample VALUES (101, 'Neena', 'Kochhar', 'NKOCHHAR', '515.123.4568', '2005-09-21', 'AD_VP', 17000, NULL, 100, 90);
INSERT INTO employees_sample VALUES (102, 'Lex', 'De Haan', 'LDEHAAN', '515.123.4569', '2001-01-13', 'AD_VP', 17000, NULL, 100, 90);
INSERT INTO employees_sample VALUES (103, 'Alexander', 'Hunold', 'AHUNOLD', '590.423.4567', '2006-01-03', 'IT_PROG', 9000, NULL, 102, 60);
INSERT INTO employees_sample VALUES (104, 'Bruce', 'Ernst', 'BERNST', '590.423.4568', '2007-05-21', 'IT_PROG', 6000, NULL, 103, 60);
INSERT INTO employees_sample VALUES (145, 'John', 'Russell', 'JRUSSEL', '011.44.1344.429268', '2004-10-01', 'SA_MAN', 14000, 0.40, 100, 80);
INSERT INTO employees_sample VALUES (146, 'Karen', 'Partners', 'KPARTNER', '011.44.1344.467268', '2005-01-05', 'SA_MAN', 13500, 0.30, 100, 80);
INSERT INTO employees_sample VALUES (147, 'Alberto', 'Errazuriz', 'AERRAZUR', '011.44.1344.429278', '2005-03-10', 'SA_MAN', 12000, 0.30, 100, 80);
INSERT INTO employees_sample VALUES (148, 'Gerald', 'Cambrault', 'GCAMBRAU', '011.44.1344.619268', '2007-10-15', 'SA_MAN', 11000, 0.30, 100, 80);
INSERT INTO employees_sample VALUES (149, 'Eleni', 'Zlotkey', 'EZLOTKEY', '011.44.1344.429018', '2008-01-29', 'SA_MAN', 10500, 0.20, 100, 80);
INSERT INTO employees_sample VALUES (150, 'Peter', 'Tucker', 'PTUCKER', '011.44.1344.129268', '2005-01-30', 'SA_REP', 10000, 0.30, 145, 80);
INSERT INTO employees_sample VALUES (151, 'David', 'Bernstein', 'DBERNSTE', '011.44.1344.345268', '2005-03-24', 'SA_REP', 9500, 0.25, 145, 80);
INSERT INTO employees_sample VALUES (152, 'Peter', 'Hall', 'PHALL', '011.44.1344.478968', '2005-08-20', 'SA_REP', 9000, 0.25, 145, 80);
INSERT INTO employees_sample VALUES (153, 'Christopher', 'Olsen', 'COLSEN', '011.44.1344.498718', '2006-03-30', 'SA_REP', 8000, 0.20, 145, 80);
INSERT INTO employees_sample VALUES (154, 'Nanette', 'Cambrault', 'NCAMBRAU', '011.44.1344.987668', '2006-12-09', 'SA_REP', 7500, 0.20, 145, 80);
INSERT INTO employees_sample VALUES (176, 'Jonathon', 'Taylor', 'JTAYLOR', '011.44.1644.429265', '2006-03-24', 'SA_REP', 8600, 0.20, 149, 80);
INSERT INTO employees_sample VALUES (177, 'Jack', 'Livingston', 'JLIVINGS', '011.44.1644.429264', '2006-04-23', 'SA_REP', 8400, 0.20, 149, 80);
INSERT INTO employees_sample VALUES (200, 'Jennifer', 'Whalen', 'JWHALEN', '515.123.4444', '2003-09-17', 'AD_ASST', 4400, NULL, 101, 10);
INSERT INTO employees_sample VALUES (201, 'Michael', 'Hartstein', 'MHARTSTE', '515.123.5555', '2004-02-17', 'MK_MAN', 13000, NULL, 100, 20);
INSERT INTO employees_sample VALUES (202, 'Pat', 'Fay', 'PFAY', '603.123.6666', '2005-08-17', 'MK_REP', 6000, NULL, 201, 20);

INSERT INTO locations_sample VALUES (1400, '2014 Jabberwocky Rd', '26192', 'Southlake', 'Texas', 'US');
INSERT INTO locations_sample VALUES (1500, '2011 Interiors Blvd', '99236', 'South San Francisco', 'California', 'US');
INSERT INTO locations_sample VALUES (1700, '2004 Charade Rd', '98199', 'Seattle', 'Washington', 'US');
INSERT INTO locations_sample VALUES (1800, '147 Spadina Ave', 'M5V 2L7', 'Toronto', 'Ontario', 'CA');
INSERT INTO locations_sample VALUES (2400, '8204 Arthur St', NULL, 'London', NULL, 'UK');
INSERT INTO locations_sample VALUES (2500, 'Magdalen Centre, The Oxford Science Park', 'OX9 9ZB', 'Oxford', 'Oxford', 'UK');
INSERT INTO locations_sample VALUES (2700, 'Schwanthalerstr. 7031', '80925', 'Munich', 'Bavaria', 'DE');

INSERT INTO countries_sample VALUES ('US', 'United States of America', 2);
INSERT INTO countries_sample VALUES ('CA', 'Canada', 2);
INSERT INTO countries_sample VALUES ('UK', 'United Kingdom', 1);
INSERT INTO countries_sample VALUES ('DE', 'Germany', 1);

-- ================================================================================
-- QUERY 1: Retrieve Employee Information for Sales Department
-- ================================================================================
-- Retrieve the employee ID, first name, last name, department name, and job title
-- of all employees who work in the Sales department.
-- Uses: INNER JOIN

SELECT '========================================' AS '';
SELECT 'Query 1: Employees in Sales Department' AS '';
SELECT '========================================' AS '';

SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME,
    E.LAST_NAME,
    D.DEPARTMENT_NAME,
    J.JOB_TITLE
FROM 
    employees_sample E
    INNER JOIN departments_sample D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
    INNER JOIN jobs_sample J ON E.JOB_ID = J.JOB_ID
WHERE 
    D.DEPARTMENT_NAME = 'Sales';

-- ================================================================================
-- QUERY 2: Employees with Commission > 10%
-- ================================================================================
-- Retrieve the employee ID, first name, last name, salary, and commission percentage
-- of all employees who have a commission percentage greater than 10%

SELECT '========================================' AS '';
SELECT 'Query 2: Employees with Commission > 10%' AS '';
SELECT '========================================' AS '';

SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME,
    E.LAST_NAME,
    E.SALARY,
    E.COMMISSION_PCT,
    D.DEPARTMENT_NAME,
    J.JOB_TITLE
FROM 
    employees_sample E
    LEFT JOIN departments_sample D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
    LEFT JOIN jobs_sample J ON E.JOB_ID = J.JOB_ID
WHERE 
    E.COMMISSION_PCT > 0.10;

-- ================================================================================
-- QUERY 3: Employees Working in Same Department as Their Manager
-- ================================================================================
-- Retrieve the employee ID, first name, last name, department name, and manager name
-- of all employees who work in the same department as their manager
-- Uses: SELF JOIN + INNER JOIN

SELECT '========================================' AS '';
SELECT 'Query 3: Employees in Same Dept as Manager' AS '';
SELECT '========================================' AS '';

SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME,
    E.LAST_NAME,
    D.DEPARTMENT_NAME,
    M.FIRST_NAME || ' ' || M.LAST_NAME AS MANAGER_NAME
FROM 
    employees_sample E
    INNER JOIN employees_sample M ON E.MANAGER_ID = M.EMPLOYEE_ID
    INNER JOIN departments_sample D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE 
    E.DEPARTMENT_ID = M.DEPARTMENT_ID;

-- ================================================================================
-- QUERY 4: Employees with Manager Named King
-- ================================================================================
-- Retrieve the employee ID, first name, last name, department name, and job title
-- of all employees who have a manager whose last name is King.
-- Uses: SELF JOIN + INNER JOIN

SELECT '========================================' AS '';
SELECT 'Query 4: Employees with Manager King' AS '';
SELECT '========================================' AS '';

SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME,
    E.LAST_NAME,
    D.DEPARTMENT_NAME,
    J.JOB_TITLE,
    M.FIRST_NAME || ' ' || M.LAST_NAME AS MANAGER_NAME
FROM 
    employees_sample E
    INNER JOIN employees_sample M ON E.MANAGER_ID = M.EMPLOYEE_ID
    LEFT JOIN departments_sample D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
    LEFT JOIN jobs_sample J ON E.JOB_ID = J.JOB_ID
WHERE 
    M.LAST_NAME = 'King';

-- ================================================================================
-- QUERY 5: Employees in Same Department as Employee 176
-- ================================================================================
-- Retrieve the employee ID, first name, last name, department name, job title, and salary
-- of all employees who work in the same department as employee ID 176.
-- Uses: Subquery + INNER JOIN

SELECT '========================================' AS '';
SELECT 'Query 5: Employees in Same Dept as ID 176' AS '';
SELECT '========================================' AS '';

SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME,
    E.LAST_NAME,
    D.DEPARTMENT_NAME,
    J.JOB_TITLE,
    E.SALARY
FROM 
    employees_sample E
    INNER JOIN departments_sample D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
    INNER JOIN jobs_sample J ON E.JOB_ID = J.JOB_ID
WHERE 
    E.DEPARTMENT_ID = (
        SELECT DEPARTMENT_ID 
        FROM employees_sample 
        WHERE EMPLOYEE_ID = 176
    );

-- ================================================================================
-- ADDITIONAL EXAMPLES: Different Types of Joins
-- ================================================================================

-- ================================================================================
-- Example 1: INNER JOIN - Employees and their Departments
-- ================================================================================
SELECT '========================================' AS '';
SELECT 'Example 1: INNER JOIN (Employees with Departments)' AS '';
SELECT '========================================' AS '';

SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME,
    E.LAST_NAME,
    D.DEPARTMENT_NAME,
    D.LOCATION_ID
FROM 
    employees_sample E
    INNER JOIN departments_sample D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
ORDER BY 
    E.EMPLOYEE_ID
LIMIT 10;

-- ================================================================================
-- Example 2: LEFT JOIN - All Employees (including those without departments)
-- ================================================================================
SELECT '========================================' AS '';
SELECT 'Example 2: LEFT JOIN (All Employees)' AS '';
SELECT '========================================' AS '';

SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME,
    E.LAST_NAME,
    D.DEPARTMENT_NAME,
    D.LOCATION_ID
FROM 
    employees_sample E
    LEFT JOIN departments_sample D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
ORDER BY 
    E.EMPLOYEE_ID
LIMIT 10;

-- ================================================================================
-- Example 3: RIGHT JOIN Workaround using LEFT JOIN
-- ================================================================================
-- SQLite doesn't support RIGHT JOIN, but we can simulate it by reversing the tables
-- and using LEFT JOIN

SELECT '========================================' AS '';
SELECT 'Example 3: RIGHT JOIN Workaround (All Departments)' AS '';
SELECT '========================================' AS '';

SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME,
    E.LAST_NAME,
    D.DEPARTMENT_NAME,
    D.LOCATION_ID
FROM 
    departments_sample D
    LEFT JOIN employees_sample E ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
ORDER BY 
    D.DEPARTMENT_ID;

-- ================================================================================
-- Example 4: FULL OUTER JOIN Workaround using UNION
-- ================================================================================
-- SQLite doesn't support FULL OUTER JOIN, but we can simulate it using UNION

SELECT '========================================' AS '';
SELECT 'Example 4: FULL OUTER JOIN Workaround (All Records)' AS '';
SELECT '========================================' AS '';

SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME,
    E.LAST_NAME,
    D.DEPARTMENT_NAME,
    D.LOCATION_ID
FROM 
    employees_sample E
    LEFT JOIN departments_sample D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
UNION
SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME,
    E.LAST_NAME,
    D.DEPARTMENT_NAME,
    D.LOCATION_ID
FROM 
    departments_sample D
    LEFT JOIN employees_sample E ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE 
    E.EMPLOYEE_ID IS NULL
ORDER BY 
    EMPLOYEE_ID;

-- ================================================================================
-- Example 5: SELF JOIN - Employees and their Managers
-- ================================================================================
SELECT '========================================' AS '';
SELECT 'Example 5: SELF JOIN (Employees and Managers)' AS '';
SELECT '========================================' AS '';

SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME || ' ' || E.LAST_NAME AS EMPLOYEE_NAME,
    E.JOB_ID,
    M.EMPLOYEE_ID AS MANAGER_ID,
    M.FIRST_NAME || ' ' || M.LAST_NAME AS MANAGER_NAME
FROM 
    employees_sample E
    LEFT JOIN employees_sample M ON E.MANAGER_ID = M.EMPLOYEE_ID
ORDER BY 
    E.EMPLOYEE_ID
LIMIT 10;

-- ================================================================================
-- Example 6: CROSS JOIN - Cartesian Product
-- ================================================================================
SELECT '========================================' AS '';
SELECT 'Example 6: CROSS JOIN (Cartesian Product - Limited)' AS '';
SELECT '========================================' AS '';

SELECT 
    E.FIRST_NAME AS EMPLOYEE,
    D.DEPARTMENT_NAME
FROM 
    (SELECT FIRST_NAME FROM employees_sample LIMIT 3) E
    CROSS JOIN 
    (SELECT DEPARTMENT_NAME FROM departments_sample LIMIT 3) D;

-- ================================================================================
-- Example 7: Multiple Joins - Complex Query
-- ================================================================================
SELECT '========================================' AS '';
SELECT 'Example 7: Multiple Joins (Employees Full Info)' AS '';
SELECT '========================================' AS '';

SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME || ' ' || E.LAST_NAME AS EMPLOYEE_NAME,
    J.JOB_TITLE,
    D.DEPARTMENT_NAME,
    L.CITY,
    C.COUNTRY_NAME,
    M.FIRST_NAME || ' ' || M.LAST_NAME AS MANAGER_NAME
FROM 
    employees_sample E
    LEFT JOIN jobs_sample J ON E.JOB_ID = J.JOB_ID
    LEFT JOIN departments_sample D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
    LEFT JOIN locations_sample L ON D.LOCATION_ID = L.LOCATION_ID
    LEFT JOIN countries_sample C ON L.COUNTRY_ID = C.COUNTRY_ID
    LEFT JOIN employees_sample M ON E.MANAGER_ID = M.EMPLOYEE_ID
ORDER BY 
    E.EMPLOYEE_ID
LIMIT 10;

-- ================================================================================
-- Example 8: NATURAL JOIN (Automatic matching on common column names)
-- ================================================================================
SELECT '========================================' AS '';
SELECT 'Example 8: NATURAL JOIN (Auto-matching columns)' AS '';
SELECT '========================================' AS '';

-- Note: NATURAL JOIN automatically matches on columns with same names
SELECT 
    EMPLOYEE_ID,
    FIRST_NAME,
    LAST_NAME,
    DEPARTMENT_NAME
FROM 
    employees_sample 
    NATURAL JOIN departments_sample
LIMIT 10;

-- ================================================================================
-- Example 9: Join with Aggregate Functions
-- ================================================================================
SELECT '========================================' AS '';
SELECT 'Example 9: JOIN with Aggregates (Dept Employee Count)' AS '';
SELECT '========================================' AS '';

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
    COUNT(E.EMPLOYEE_ID) > 0
ORDER BY 
    EMPLOYEE_COUNT DESC;

-- ================================================================================
-- JOIN TYPES SUMMARY
-- ================================================================================
SELECT '========================================' AS '';
SELECT 'JOIN TYPES SUMMARY' AS '';
SELECT '========================================' AS '';

SELECT 'INNER JOIN' AS "Join Type", 'Returns only matching rows from both tables' AS "Description";
SELECT 'LEFT JOIN' AS "Join Type", 'Returns all rows from left table, matching rows from right' AS "Description";
SELECT 'RIGHT JOIN' AS "Join Type", 'Not supported - use LEFT JOIN with reversed tables' AS "Description";
SELECT 'FULL OUTER JOIN' AS "Join Type", 'Not supported - use UNION of LEFT JOINs' AS "Description";
SELECT 'SELF JOIN' AS "Join Type", 'Joins a table to itself' AS "Description";
SELECT 'CROSS JOIN' AS "Join Type", 'Returns Cartesian product of both tables' AS "Description";
SELECT 'NATURAL JOIN' AS "Join Type", 'Automatically joins on columns with same names' AS "Description";

-- ================================================================================
-- End of Practical 9 (SQLite Version)
-- ================================================================================
