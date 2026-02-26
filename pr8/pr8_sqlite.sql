-- ================================================================================
-- Practical No. 8: Set Operators (SQLite Version)
-- ================================================================================
-- SQLite-compatible implementation of Set Operators:
-- UNION, UNION ALL, INTERSECT, EXCEPT (SQLite uses EXCEPT instead of MINUS)
--
-- Note: SQLite fully supports UNION, UNION ALL, and INTERSECT
-- SQLite uses EXCEPT instead of Oracle's MINUS (functionally identical)
-- ================================================================================

-- Enable output formatting
.mode column
.headers on
.width 12 15 15 15 10

-- ================================================================================
-- Setup: Create sample employees table
-- ================================================================================

DROP TABLE IF EXISTS employees_sample;
CREATE TABLE employees_sample (
    EMPLOYEE_ID INTEGER PRIMARY KEY,
    FIRST_NAME TEXT,
    LAST_NAME TEXT,
    EMAIL TEXT,
    JOB_ID TEXT,
    SALARY REAL,
    MANAGER_ID INTEGER,
    DEPARTMENT_ID INTEGER
);

-- Insert sample data
INSERT INTO employees_sample VALUES 
(100, 'Steven', 'King', 'SKING', 'AD_PRES', 24000, NULL, 90),
(101, 'Neena', 'Kochhar', 'NKOCHHAR', 'AD_VP', 17000, 100, 90),
(102, 'Lex', 'De Haan', 'LDEHAAN', 'AD_VP', 17000, 100, 90),
(103, 'Alexander', 'Hunold', 'AHUNOLD', 'IT_PROG', 9000, 102, 60),
(104, 'Bruce', 'Ernst', 'BERNST', 'IT_PROG', 6000, 103, 60),
(105, 'David', 'Austin', 'DAUSTIN', 'IT_PROG', 4800, 103, 60),
(106, 'Valli', 'Pataballa', 'VPATABAL', 'IT_PROG', 4800, 103, 60),
(107, 'Diana', 'Lorentz', 'DLORENTZ', 'IT_PROG', 4200, 103, 60),
(145, 'John', 'Russell', 'JRUSSEL', 'SA_MAN', 14000, 100, 80),
(146, 'Karen', 'Partners', 'KPARTNER', 'SA_MAN', 13500, 100, 80),
(147, 'Alberto', 'Errazuriz', 'AERRAZUR', 'SA_MAN', 12000, 100, 80),
(148, 'Gerald', 'Cambrault', 'GCAMBRAU', 'SA_MAN', 11000, 100, 80),
(149, 'Eleni', 'Zlotkey', 'EZLOTKEY', 'SA_MAN', 10500, 100, 80),
(150, 'Peter', 'Tucker', 'PTUCKER', 'SA_REP', 10000, 145, 80),
(151, 'David', 'Bernstein', 'DBERNSTE', 'SA_REP', 9500, 145, 80),
(152, 'Peter', 'Hall', 'PHALL', 'SA_REP', 9000, 145, 80),
(153, 'Christopher', 'Olsen', 'COLSEN', 'SA_REP', 8000, 145, 80),
(154, 'Nanette', 'Cambrault', 'NCAMBRAU', 'SA_REP', 7500, 145, 80),
(200, 'Jennifer', 'Whalen', 'JWHALEN', 'AD_ASST', 4400, 101, 10),
(201, 'Michael', 'Hartstein', 'MHARTSTE', 'MK_MAN', 13000, 100, 20),
(202, 'Pat', 'Fay', 'PFAY', 'MK_REP', 6000, 201, 20),
(124, 'Kevin', 'Mourgos', 'KMOURGOS', 'ST_MAN', 5800, 100, 50),
(125, 'Julia', 'Nayer', 'JNAYER', 'ST_CLERK', 3200, 124, 50),
(126, 'Irene', 'Mikkilineni', 'IMIKKILI', 'ST_CLERK', 2700, 124, 50),
(127, 'James', 'Landry', 'JLANDRY', 'ST_CLERK', 2400, 124, 50);

-- Create departments table
DROP TABLE IF EXISTS departments_sample;
CREATE TABLE departments_sample (
    DEPARTMENT_ID INTEGER PRIMARY KEY,
    DEPARTMENT_NAME TEXT,
    MANAGER_ID INTEGER
);

INSERT INTO departments_sample VALUES 
(10, 'Administration', 200),
(20, 'Marketing', 201),
(50, 'Shipping', 124),
(60, 'IT', 103),
(80, 'Sales', 145),
(90, 'Executive', 100);

-- ================================================================================
-- SECTION 1: UNION - Returns distinct rows from both queries
-- ================================================================================

SELECT '=== Query 1: UNION Example ===' AS "Query";
SELECT 'Find employees who are either managers OR sales representatives' AS "Description";

-- Query 1: Find employees who are either managers or sales representatives
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, JOB_ID
FROM employees_sample
WHERE JOB_ID LIKE '%MAN%'  -- Managers
UNION
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, JOB_ID
FROM employees_sample
WHERE JOB_ID LIKE '%REP%';  -- Representatives

-- ================================================================================
-- SECTION 2: INTERSECT - Returns rows common to both queries
-- ================================================================================

SELECT '=== Query 2: INTERSECT Example ===' AS "Query";
SELECT 'Find employees who are in management AND work in specific departments' AS "Description";

-- Query 2: Find employees in management roles AND in specific departments
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, JOB_ID, DEPARTMENT_ID
FROM employees_sample
WHERE JOB_ID LIKE '%MAN%'  -- Management roles
INTERSECT
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, JOB_ID, DEPARTMENT_ID
FROM employees_sample
WHERE DEPARTMENT_ID IN (20, 50, 80);  -- Specific departments

-- ================================================================================
-- SECTION 3: EXCEPT - Returns rows from first query not in second query
-- ================================================================================
-- Note: SQLite uses EXCEPT instead of Oracle's MINUS (functionally identical)

SELECT '=== Query 3: EXCEPT Example (Oracle: MINUS) ===' AS "Query";
SELECT 'Find employees who are sales representatives but NOT managers' AS "Description";

-- Query 3: Find employees who are sales representatives but not managers
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, JOB_ID
FROM employees_sample
WHERE JOB_ID LIKE '%REP%'  -- Sales Representatives
EXCEPT
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, JOB_ID
FROM employees_sample
WHERE JOB_ID LIKE '%MAN%';  -- Managers

-- ================================================================================
-- SECTION 4: Complex Set Operations with Departments
-- ================================================================================

SELECT '=== Query 4: Departments with managers OR admin assistants ===' AS "Query";

-- Query 4: Find departments that have either a manager or an administrative assistant
SELECT DISTINCT DEPARTMENT_ID, DEPARTMENT_NAME
FROM departments_sample
WHERE DEPARTMENT_ID IN (
    SELECT DEPARTMENT_ID 
    FROM employees_sample 
    WHERE JOB_ID LIKE '%MAN%'
)
UNION
SELECT DISTINCT DEPARTMENT_ID, DEPARTMENT_NAME
FROM departments_sample
WHERE DEPARTMENT_ID IN (
    SELECT DEPARTMENT_ID 
    FROM employees_sample 
    WHERE JOB_ID = 'AD_ASST'
);

SELECT '=== Query 5: Departments with BOTH managers AND admin assistants ===' AS "Query";

-- Query 5: Find departments that have both a manager and an administrative assistant
SELECT DISTINCT DEPARTMENT_ID, DEPARTMENT_NAME
FROM departments_sample
WHERE DEPARTMENT_ID IN (
    SELECT DEPARTMENT_ID 
    FROM employees_sample 
    WHERE JOB_ID LIKE '%MAN%'
)
INTERSECT
SELECT DISTINCT DEPARTMENT_ID, DEPARTMENT_NAME
FROM departments_sample
WHERE DEPARTMENT_ID IN (
    SELECT DEPARTMENT_ID 
    FROM employees_sample 
    WHERE JOB_ID = 'AD_ASST'
);

SELECT '=== Query 6: Employees with manager OR subordinate named King ===' AS "Query";

-- Query 6: Find employees who either have a manager OR have a subordinate with last name 'King'
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, MANAGER_ID
FROM employees_sample
WHERE MANAGER_ID IS NOT NULL
UNION
SELECT E1.EMPLOYEE_ID, E1.FIRST_NAME, E1.LAST_NAME, E1.MANAGER_ID
FROM employees_sample E1
WHERE E1.EMPLOYEE_ID IN (
    SELECT E2.MANAGER_ID 
    FROM employees_sample E2 
    WHERE E2.LAST_NAME = 'King'
);

-- ================================================================================
-- SECTION 5: UNION ALL - Returns all rows including duplicates
-- ================================================================================

SELECT '=== UNION ALL Example (keeps duplicates) ===' AS "Example";

-- Example: Get employees from multiple departments, showing source
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, DEPARTMENT_ID, 'From Dept 50' AS SOURCE
FROM employees_sample
WHERE DEPARTMENT_ID = 50
UNION ALL
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, DEPARTMENT_ID, 'From Dept 80' AS SOURCE
FROM employees_sample
WHERE DEPARTMENT_ID = 80;

-- Comparison: UNION vs UNION ALL
SELECT '=== Comparison: UNION (removes duplicates) ===' AS "Comparison";
SELECT JOB_ID FROM employees_sample WHERE DEPARTMENT_ID = 50
UNION
SELECT JOB_ID FROM employees_sample WHERE DEPARTMENT_ID = 80;

SELECT '=== Comparison: UNION ALL (keeps duplicates) ===' AS "Comparison";
SELECT JOB_ID FROM employees_sample WHERE DEPARTMENT_ID = 50
UNION ALL
SELECT JOB_ID FROM employees_sample WHERE DEPARTMENT_ID = 80;

-- ================================================================================
-- SECTION 6: Additional Examples
-- ================================================================================

SELECT '=== Example 1: Unique job IDs across departments ===' AS "Example";

-- Example 1: Find all unique job IDs across multiple departments
SELECT DISTINCT JOB_ID, 'Department 50' AS Department
FROM employees_sample
WHERE DEPARTMENT_ID = 50
UNION
SELECT DISTINCT JOB_ID, 'Department 80' AS Department
FROM employees_sample
WHERE DEPARTMENT_ID = 80
UNION
SELECT DISTINCT JOB_ID, 'Department 90' AS Department
FROM employees_sample
WHERE DEPARTMENT_ID = 90
ORDER BY JOB_ID;

SELECT '=== Example 2: Employees in dept 50 but NOT in dept 80 ===' AS "Example";

-- Example 2: Find employees in department 50 but not in department 80
-- (Using EXCEPT to show employees exclusive to dept 50)
SELECT FIRST_NAME, LAST_NAME, JOB_ID
FROM employees_sample
WHERE DEPARTMENT_ID = 50
EXCEPT
SELECT FIRST_NAME, LAST_NAME, JOB_ID
FROM employees_sample
WHERE DEPARTMENT_ID = 80;

SELECT '=== Example 3: Job IDs in (50 OR 80) but NOT 90 ===' AS "Example";

-- Example 3: Combining multiple set operators
-- Find job IDs that appear in dept 50 OR 80, but NOT in dept 90
SELECT JOB_ID FROM employees_sample WHERE DEPARTMENT_ID = 50
UNION
SELECT JOB_ID FROM employees_sample WHERE DEPARTMENT_ID = 80
EXCEPT
SELECT JOB_ID FROM employees_sample WHERE DEPARTMENT_ID = 90;

SELECT '=== Example 4: Aggregates with UNION ===' AS "Example";

-- Example 4: Using set operators with aggregate functions
SELECT DEPARTMENT_ID, COUNT(*) AS EMP_COUNT, 'High Salary Dept' AS TYPE
FROM employees_sample
WHERE SALARY > 10000
GROUP BY DEPARTMENT_ID
UNION
SELECT DEPARTMENT_ID, COUNT(*) AS EMP_COUNT, 'Low Salary Dept' AS TYPE
FROM employees_sample
WHERE SALARY <= 10000
GROUP BY DEPARTMENT_ID
ORDER BY DEPARTMENT_ID;

SELECT '=== Example 5: Employees by salary range ===' AS "Example";

-- Example 5: Find employees with specific salary ranges in different departments
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY, DEPARTMENT_ID
FROM employees_sample
WHERE DEPARTMENT_ID = 50 AND SALARY > 3000
UNION
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY, DEPARTMENT_ID
FROM employees_sample
WHERE DEPARTMENT_ID = 80 AND SALARY > 8000
ORDER BY DEPARTMENT_ID, SALARY DESC;

-- ================================================================================
-- SECTION 7: Oracle vs SQLite Set Operators Comparison
-- ================================================================================

SELECT '=== ORACLE vs SQLITE SET OPERATORS ===' AS "Reference";

SELECT 
    'UNION' AS "Operator",
    'Supported' AS "Oracle",
    'Supported' AS "SQLite",
    'Returns distinct rows from both queries' AS "Description";

SELECT 
    'UNION ALL' AS "Operator",
    'Supported' AS "Oracle",
    'Supported' AS "SQLite",
    'Returns all rows including duplicates' AS "Description";

SELECT 
    'INTERSECT' AS "Operator",
    'Supported' AS "Oracle",
    'Supported' AS "SQLite",
    'Returns rows common to both queries' AS "Description";

SELECT 
    'MINUS' AS "Operator",
    'Supported' AS "Oracle",
    'Use EXCEPT' AS "SQLite",
    'Returns rows from 1st query not in 2nd' AS "Description";

SELECT 
    'EXCEPT' AS "Operator",
    'Not available' AS "Oracle",
    'Supported' AS "SQLite",
    'Same as MINUS - Oracle equivalent' AS "Description";

-- ================================================================================
-- IMPORTANT RULES for Set Operators:
-- ================================================================================
SELECT '=== SET OPERATOR RULES ===' AS "Rules";

SELECT '1. Number of columns must be same in all SELECT statements' AS "Rule";
SELECT '2. Data types must be compatible across queries' AS "Rule";
SELECT '3. Column names from first SELECT are used in result' AS "Rule";
SELECT '4. ORDER BY can only be used at the end of entire query' AS "Rule";
SELECT '5. UNION removes duplicates, UNION ALL keeps duplicates' AS "Rule";
SELECT '6. INTERSECT returns common rows from both queries' AS "Rule";
SELECT '7. EXCEPT (MINUS in Oracle) returns rows from 1st not in 2nd' AS "Rule";
SELECT '8. Set operators have equal precedence, evaluated left to right' AS "Rule";
SELECT '9. Use parentheses to control evaluation order' AS "Rule";

-- ================================================================================
-- End of Practical 8 (SQLite Version)
-- ================================================================================
