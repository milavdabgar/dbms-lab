-- ================================================================================
-- Practical No. 8: Set Operators
-- ======================================================================== ========
-- Implement SQL queries using Set Operators:
-- UNION, UNION ALL, INTERSECT, MINUS
--
-- Course: Database Management System (DI04032011)
-- Semester: IV - ICT Engineering
-- ================================================================================

-- ================================================================================
-- SECTION 1: UNION - Returns distinct rows from both queries
-- ================================================================================

-- Query 1: Find employees who are either managers or sales representatives
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, JOB_ID
FROM HR.EMPLOYEES
WHERE JOB_ID LIKE '%MAN%'  -- Managers
UNION
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, JOB_ID
FROM HR.EMPLOYEES
WHERE JOB_ID LIKE '%REP%';  -- Representatives

-- ================================================================================
-- SECTION 2: INTERSECT - Returns rows common to both queries
-- ================================================================================

-- Query 2: Find employees who are both in management roles AND work in specific departments
-- (Finding employees who meet multiple criteria)
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, JOB_ID, DEPARTMENT_ID
FROM HR.EMPLOYEES
WHERE JOB_ID LIKE '%MAN%'  -- Management roles
INTERSECT
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, JOB_ID, DEPARTMENT_ID
FROM HR.EMPLOYEES
WHERE DEPARTMENT_ID IN (20, 50, 80);  -- Specific departments

-- ================================================================================
-- SECTION 3: MINUS - Returns rows from first query not in second query  
-- ================================================================================

-- Query 3: Find employees who are sales representatives but not managers
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, JOB_ID
FROM HR.EMPLOYEES
WHERE JOB_ID LIKE '%REP%'  -- Sales Representatives
MINUS
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, JOB_ID
FROM HR.EMPLOYEES
WHERE JOB_ID LIKE '%MAN%';  -- Managers

-- ================================================================================
-- SECTION 4: More Complex Set Operations with Departments
-- ================================================================================

-- Query 4: Find departments that have either a manager or an administrative assistant
-- (Using subqueries to find department IDs)
SELECT DISTINCT DEPARTMENT_ID, DEPARTMENT_NAME
FROM HR.DEPARTMENTS
WHERE DEPARTMENT_ID IN (
    SELECT DEPARTMENT_ID 
    FROM HR.EMPLOYEES 
    WHERE JOB_ID LIKE '%MAN%'
)
UNION
SELECT DISTINCT DEPARTMENT_ID, DEPARTMENT_NAME
FROM HR.DEPARTMENTS
WHERE DEPARTMENT_ID IN (
    SELECT DEPARTMENT_ID 
    FROM HR.EMPLOYEES 
    WHERE JOB_ID = 'AD_ASST'
);

-- Query 5: Find departments that have both a manager and an administrative assistant
SELECT DISTINCT DEPARTMENT_ID, DEPARTMENT_NAME
FROM HR.DEPARTMENTS
WHERE DEPARTMENT_ID IN (
    SELECT DEPARTMENT_ID 
    FROM HR.EMPLOYEES 
    WHERE JOB_ID LIKE '%MAN%'
)
INTERSECT
SELECT DISTINCT DEPARTMENT_ID, DEPARTMENT_NAME
FROM HR.DEPARTMENTS
WHERE DEPARTMENT_ID IN (
    SELECT DEPARTMENT_ID 
    FROM HR.EMPLOYEES 
    WHERE JOB_ID = 'AD_ASST'
);

-- Query 6: Find employees who either have a manager OR have a subordinate with last name 'King'
-- Employees who report to someone
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, MANAGER_ID
FROM HR.EMPLOYEES
WHERE MANAGER_ID IS NOT NULL
UNION
-- Employees who have subordinates with last name 'King'
SELECT E1.EMPLOYEE_ID, E1.FIRST_NAME, E1.LAST_NAME, E1.MANAGER_ID
FROM HR.EMPLOYEES E1
WHERE E1.EMPLOYEE_ID IN (
    SELECT E2.MANAGER_ID 
    FROM HR.EMPLOYEES E2 
    WHERE E2.LAST_NAME = 'King'
);

-- ================================================================================
-- SECTION 5: UNION ALL - Returns all rows including duplicates
-- ================================================================================

-- Example: Find all employees in departments 50 and 80 (may have duplicates if someone is listed twice)
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, DEPARTMENT_ID, 'From Query 1' AS SOURCE
FROM HR.EMPLOYEES
WHERE DEPARTMENT_ID = 50
UNION ALL
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, DEPARTMENT_ID, 'From Query 2' AS SOURCE
FROM HR.EMPLOYEES
WHERE DEPARTMENT_ID = 80;

-- Comparison: UNION vs UNION ALL
-- UNION removes duplicates, UNION ALL keeps all rows
SELECT JOB_ID FROM HR.EMPLOYEES WHERE DEPARTMENT_ID = 50
UNION
SELECT JOB_ID FROM HR.EMPLOYEES WHERE DEPARTMENT_ID = 80;
-- Result: Distinct job IDs only

SELECT JOB_ID FROM HR.EMPLOYEES WHERE DEPARTMENT_ID = 50
UNION ALL
SELECT JOB_ID FROM HR.EMPLOYEES WHERE DEPARTMENT_ID = 80;
-- Result: All job IDs including duplicates

-- ================================================================================
-- SECTION 6: Additional Examples and Demonstrations
-- ================================================================================

-- Example 1: Find all unique job IDs across multiple departments
SELECT DISTINCT JOB_ID, 'Department 50' AS Department
FROM HR.EMPLOYEES
WHERE DEPARTMENT_ID = 50
UNION
SELECT DISTINCT JOB_ID, 'Department 80' AS Department
FROM HR.EMPLOYEES
WHERE DEPARTMENT_ID = 80
UNION
SELECT DISTINCT JOB_ID, 'Department 90' AS Department
FROM HR.EMPLOYEES
WHERE DEPARTMENT_ID = 90
ORDER BY JOB_ID;

-- Example 2: Find employees in department 50 but not in department 80
-- (Using MINUS to show employees exclusive to dept 50)
SELECT FIRST_NAME, LAST_NAME, JOB_ID
FROM HR.EMPLOYEES
WHERE DEPARTMENT_ID = 50
MINUS
SELECT FIRST_NAME, LAST_NAME, JOB_ID
FROM HR.EMPLOYEES
WHERE DEPARTMENT_ID = 80;

-- Example 3: Combining multiple set operators
-- Find job IDs that appear in dept 50 OR 80, but NOT in dept 90
(SELECT JOB_ID FROM HR.EMPLOYEES WHERE DEPARTMENT_ID = 50
 UNION
 SELECT JOB_ID FROM HR.EMPLOYEES WHERE DEPARTMENT_ID = 80)
MINUS
SELECT JOB_ID FROM HR.EMPLOYEES WHERE DEPARTMENT_ID = 90;

-- Example 4: Using set operators with aggregate functions
-- Employee count by department - two different approaches combined
SELECT DEPARTMENT_ID, COUNT(*) AS EMP_COUNT, 'High Salary Dept' AS TYPE
FROM HR.EMPLOYEES
WHERE SALARY > 10000
GROUP BY DEPARTMENT_ID
UNION
SELECT DEPARTMENT_ID, COUNT(*) AS EMP_COUNT, 'Low Salary Dept' AS TYPE
FROM HR.EMPLOYEES
WHERE SALARY <= 10000
GROUP BY DEPARTMENT_ID
ORDER BY DEPARTMENT_ID;

-- Example 5: Find employees with specific salary ranges in different departments
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY, DEPARTMENT_ID
FROM HR.EMPLOYEES
WHERE DEPARTMENT_ID = 50 AND SALARY > 5000
UNION
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY, DEPARTMENT_ID
FROM HR.EMPLOYEES
WHERE DEPARTMENT_ID = 80 AND SALARY > 8000
ORDER BY DEPARTMENT_ID, SALARY DESC;

-- ================================================================================
-- IMPORTANT NOTES for Set Operators:
-- ================================================================================
-- 1. Number of columns must be same in all SELECT statements
-- 2. Data types must be compatible
-- 3. Column names from first SELECT are used in result
-- 4. ORDER BY can only be used at the end of entire query
-- 5. UNION removes duplicates, UNION ALL keeps duplicates
-- 6. INTERSECT returns common rows from both queries
-- 7. MINUS returns rows from first query not in second query
-- ================================================================================

-- ================================================================================
-- End of Practical 8
-- ================================================================================
