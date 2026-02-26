-- ================================================================================
-- Practical No. 9: Retrieve data using various Joins (Oracle Version)
-- ================================================================================
-- This practical demonstrates different types of SQL joins:
-- INNER JOIN, LEFT OUTER JOIN, RIGHT OUTER JOIN, FULL OUTER JOIN
-- Self JOIN
-- ================================================================================

SET PAGESIZE 100
SET LINESIZE 200
COL FIRST_NAME FORMAT A15
COL LAST_NAME FORMAT A15
COL DEPARTMENT_NAME FORMAT A20
COL JOB_TITLE FORMAT A30
COL MANAGER_NAME FORMAT A30
COL EMAIL FORMAT A15

-- ================================================================================
-- QUERY 1: Retrieve Employee Information for Sales Department
-- ================================================================================
-- Retrieve the employee ID, first name, last name, department name, and job title
-- of all employees who work in the Sales department.
-- Uses: INNER JOIN

PROMPT ========================================
PROMPT Query 1: Employees in Sales Department
PROMPT ========================================

SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME,
    E.LAST_NAME,
    D.DEPARTMENT_NAME,
    J.JOB_TITLE
FROM 
    HR.EMPLOYEES E
    INNER JOIN HR.DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
    INNER JOIN HR.JOBS J ON E.JOB_ID = J.JOB_ID
WHERE 
    D.DEPARTMENT_NAME = 'Sales';

-- ================================================================================
-- QUERY 2: Employees with Commission > 10%
-- ================================================================================
-- Retrieve the employee ID, first name, last name, salary, and commission percentage
-- of all employees who have a commission percentage greater than 10%
-- Uses: Simple SELECT with JOIN (optional, depending on requirements)

PROMPT ========================================
PROMPT Query 2: Employees with Commission > 10%
PROMPT ========================================

SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME,
    E.LAST_NAME,
    E.SALARY,
    E.COMMISSION_PCT,
    D.DEPARTMENT_NAME,
    J.JOB_TITLE
FROM 
    HR.EMPLOYEES E
    LEFT OUTER JOIN HR.DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
    LEFT OUTER JOIN HR.JOBS J ON E.JOB_ID = J.JOB_ID
WHERE 
    E.COMMISSION_PCT > 0.10;

-- ================================================================================
-- QUERY 3: Employees Working in Same Department as Their Manager
-- ================================================================================
-- Retrieve the employee ID, first name, last name, department name, and manager name
-- of all employees who work in the same department as their manager
-- Uses: SELF JOIN + INNER JOIN

PROMPT ========================================
PROMPT Query 3: Employees in Same Dept as Manager
PROMPT ========================================

SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME,
    E.LAST_NAME,
    D.DEPARTMENT_NAME,
    M.FIRST_NAME || ' ' || M.LAST_NAME AS MANAGER_NAME
FROM 
    HR.EMPLOYEES E
    INNER JOIN HR.EMPLOYEES M ON E.MANAGER_ID = M.EMPLOYEE_ID
    INNER JOIN HR.DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE 
    E.DEPARTMENT_ID = M.DEPARTMENT_ID;

-- ================================================================================
-- QUERY 4: Employees with Manager Named King
-- ================================================================================
-- Retrieve the employee ID, first name, last name, department name, and job title
-- of all employees who have a manager whose last name is King.
-- Uses: SELF JOIN + INNER JOIN

PROMPT ========================================
PROMPT Query 4: Employees with Manager 'King'
PROMPT ========================================

SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME,
    E.LAST_NAME,
    D.DEPARTMENT_NAME,
    J.JOB_TITLE,
    M.FIRST_NAME || ' ' || M.LAST_NAME AS MANAGER_NAME
FROM 
    HR.EMPLOYEES E
    INNER JOIN HR.EMPLOYEES M ON E.MANAGER_ID = M.EMPLOYEE_ID
    LEFT OUTER JOIN HR.DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
    LEFT OUTER JOIN HR.JOBS J ON E.JOB_ID = J.JOB_ID
WHERE 
    M.LAST_NAME = 'King';

-- ================================================================================
-- QUERY 5: Employees in Same Department as Employee 176
-- ================================================================================
-- Retrieve the employee ID, first name, last name, department name, job title, and salary
-- of all employees who work in the same department as employee ID 176.
-- Uses: Subquery + INNER JOIN

PROMPT ========================================
PROMPT Query 5: Employees in Same Dept as ID 176
PROMPT ========================================

SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME,
    E.LAST_NAME,
    D.DEPARTMENT_NAME,
    J.JOB_TITLE,
    E.SALARY
FROM 
    HR.EMPLOYEES E
    INNER JOIN HR.DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
    INNER JOIN HR.JOBS J ON E.JOB_ID = J.JOB_ID
WHERE 
    E.DEPARTMENT_ID = (
        SELECT DEPARTMENT_ID 
        FROM HR.EMPLOYEES 
        WHERE EMPLOYEE_ID = 176
    );

-- ================================================================================
-- ADDITIONAL EXAMPLES: Different Types of Joins
-- ================================================================================

-- ================================================================================
-- Example 1: INNER JOIN - Employees and their Departments
-- ================================================================================
PROMPT ========================================
PROMPT Example 1: INNER JOIN (Employees with Departments)
PROMPT ========================================

SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME,
    E.LAST_NAME,
    D.DEPARTMENT_NAME,
    D.LOCATION_ID
FROM 
    HR.EMPLOYEES E
    INNER JOIN HR.DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
ORDER BY 
    E.EMPLOYEE_ID
FETCH FIRST 10 ROWS ONLY;

-- ================================================================================
-- Example 2: LEFT OUTER JOIN - All Employees (including those without departments)
-- ================================================================================
PROMPT ========================================
PROMPT Example 2: LEFT OUTER JOIN (All Employees)
PROMPT ========================================

SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME,
    E.LAST_NAME,
    D.DEPARTMENT_NAME,
    D.LOCATION_ID
FROM 
    HR.EMPLOYEES E
    LEFT OUTER JOIN HR.DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
ORDER BY 
    E.EMPLOYEE_ID
FETCH FIRST 10 ROWS ONLY;

-- ================================================================================
-- Example 3: RIGHT OUTER JOIN - All Departments (including those without employees)
-- ================================================================================
PROMPT ========================================
PROMPT Example 3: RIGHT OUTER JOIN (All Departments)
PROMPT ========================================

SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME,
    E.LAST_NAME,
    D.DEPARTMENT_NAME,
    D.LOCATION_ID
FROM 
    HR.EMPLOYEES E
    RIGHT OUTER JOIN HR.DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
ORDER BY 
    D.DEPARTMENT_ID;

-- ================================================================================
-- Example 4: FULL OUTER JOIN - All Employees and All Departments
-- ================================================================================
PROMPT ========================================
PROMPT Example 4: FULL OUTER JOIN (All Records)
PROMPT ========================================

SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME,
    E.LAST_NAME,
    D.DEPARTMENT_NAME,
    D.LOCATION_ID
FROM 
    HR.EMPLOYEES E
    FULL OUTER JOIN HR.DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
ORDER BY 
    E.EMPLOYEE_ID NULLS LAST;

-- ================================================================================
-- Example 5: SELF JOIN - Employees and their Managers
-- ================================================================================
PROMPT ========================================
PROMPT Example 5: SELF JOIN (Employees and Managers)
PROMPT ========================================

SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME || ' ' || E.LAST_NAME AS EMPLOYEE_NAME,
    E.JOB_ID,
    M.EMPLOYEE_ID AS MANAGER_ID,
    M.FIRST_NAME || ' ' || M.LAST_NAME AS MANAGER_NAME
FROM 
    HR.EMPLOYEES E
    LEFT OUTER JOIN HR.EMPLOYEES M ON E.MANAGER_ID = M.EMPLOYEE_ID
ORDER BY 
    E.EMPLOYEE_ID
FETCH FIRST 10 ROWS ONLY;

-- ================================================================================
-- Example 6: CROSS JOIN - Cartesian Product
-- ================================================================================
PROMPT ========================================
PROMPT Example 6: CROSS JOIN (Cartesian Product - Limited)
PROMPT ========================================

SELECT 
    E.FIRST_NAME AS EMPLOYEE,
    D.DEPARTMENT_NAME
FROM 
    (SELECT FIRST_NAME FROM HR.EMPLOYEES FETCH FIRST 3 ROWS ONLY) E
    CROSS JOIN 
    (SELECT DEPARTMENT_NAME FROM HR.DEPARTMENTS FETCH FIRST 3 ROWS ONLY) D;

-- ================================================================================
-- Example 7: Multiple Joins - Complex Query
-- ================================================================================
PROMPT ========================================
PROMPT Example 7: Multiple Joins (Employees Full Info)
PROMPT ========================================

SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME || ' ' || E.LAST_NAME AS EMPLOYEE_NAME,
    J.JOB_TITLE,
    D.DEPARTMENT_NAME,
    L.CITY,
    C.COUNTRY_NAME,
    M.FIRST_NAME || ' ' || M.LAST_NAME AS MANAGER_NAME
FROM 
    HR.EMPLOYEES E
    LEFT OUTER JOIN HR.JOBS J ON E.JOB_ID = J.JOB_ID
    LEFT OUTER JOIN HR.DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
    LEFT OUTER JOIN HR.LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID
    LEFT OUTER JOIN HR.COUNTRIES C ON L.COUNTRY_ID = C.COUNTRY_ID
    LEFT OUTER JOIN HR.EMPLOYEES M ON E.MANAGER_ID = M.EMPLOYEE_ID
ORDER BY 
    E.EMPLOYEE_ID
FETCH FIRST 10 ROWS ONLY;

-- ================================================================================
-- Example 8: Natural Join (Automatic matching on common column names)
-- ================================================================================
PROMPT ========================================
PROMPT Example 8: NATURAL JOIN (Auto-matching columns)
PROMPT ========================================

SELECT 
    EMPLOYEE_ID,
    FIRST_NAME,
    LAST_NAME,
    DEPARTMENT_NAME
FROM 
    HR.EMPLOYEES 
    NATURAL JOIN HR.DEPARTMENTS
FETCH FIRST 10 ROWS ONLY;

-- ================================================================================
-- Example 9: Join with Aggregate Functions
-- ================================================================================
PROMPT ========================================
PROMPT Example 9: JOIN with Aggregates (Dept Employee Count)
PROMPT ========================================

SELECT 
    D.DEPARTMENT_ID,
    D.DEPARTMENT_NAME,
    COUNT(E.EMPLOYEE_ID) AS EMPLOYEE_COUNT,
    ROUND(AVG(E.SALARY), 2) AS AVG_SALARY,
    MAX(E.SALARY) AS MAX_SALARY,
    MIN(E.SALARY) AS MIN_SALARY
FROM 
    HR.DEPARTMENTS D
    LEFT OUTER JOIN HR.EMPLOYEES E ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
GROUP BY 
    D.DEPARTMENT_ID, D.DEPARTMENT_NAME
HAVING 
    COUNT(E.EMPLOYEE_ID) > 0
ORDER BY 
    EMPLOYEE_COUNT DESC;

-- ================================================================================
-- Example 10: Non-Equijoin (Join without equality condition)
-- ================================================================================
PROMPT ========================================
PROMPT Example 10: Non-Equijoin (Salary Grade)
PROMPT ========================================

-- Note: This example assumes a SALARY_GRADES table exists
-- If not, you can create a simple one for demonstration:

-- CREATE TABLE SALARY_GRADES (
--     GRADE_LEVEL CHAR(1),
--     LOWEST_SAL NUMBER,
--     HIGHEST_SAL NUMBER
-- );
-- 
-- INSERT INTO SALARY_GRADES VALUES ('A', 1000, 2999);
-- INSERT INTO SALARY_GRADES VALUES ('B', 3000, 5999);
-- INSERT INTO SALARY_GRADES VALUES ('C', 6000, 9999);
-- INSERT INTO SALARY_GRADES VALUES ('D', 10000, 14999);
-- INSERT INTO SALARY_GRADES VALUES ('E', 15000, 24999);
-- INSERT INTO SALARY_GRADES VALUES ('F', 25000, 40000);

-- Uncomment below if SALARY_GRADES table exists:
/*
SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME,
    E.LAST_NAME,
    E.SALARY,
    SG.GRADE_LEVEL
FROM 
    HR.EMPLOYEES E
    JOIN SALARY_GRADES SG ON E.SALARY BETWEEN SG.LOWEST_SAL AND SG.HIGHEST_SAL
ORDER BY 
    E.SALARY DESC
FETCH FIRST 10 ROWS ONLY;
*/

-- ================================================================================
-- JOIN TYPES SUMMARY
-- ================================================================================
PROMPT ========================================
PROMPT JOIN TYPES SUMMARY
PROMPT ========================================
PROMPT INNER JOIN: Returns only matching rows from both tables
PROMPT LEFT OUTER JOIN: Returns all rows from left table, matching rows from right
PROMPT RIGHT OUTER JOIN: Returns all rows from right table, matching rows from left
PROMPT FULL OUTER JOIN: Returns all rows from both tables
PROMPT SELF JOIN: Joins a table to itself
PROMPT CROSS JOIN: Returns Cartesian product of both tables
PROMPT NATURAL JOIN: Automatically joins on columns with same names
PROMPT NON-EQUIJOIN: Join condition uses operators other than equality

-- ================================================================================
-- End of Practical 9 (Oracle Version)
-- ================================================================================
