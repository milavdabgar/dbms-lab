-- ================================================================================
-- Practical No. 10: Create, Alter, and Update Views (Oracle Version)
-- ================================================================================
-- This practical demonstrates working with database views in Oracle:
-- CREATE VIEW, ALTER VIEW (via CREATE OR REPLACE), DROP VIEW
-- ================================================================================

SET PAGESIZE 100
SET LINESIZE 200
COL FIRST_NAME FORMAT A15
COL LAST_NAME FORMAT A15
COL JOB_TITLE FORMAT A30
COL DEPARTMENT_NAME FORMAT A20
COL SALARY FORMAT 99999
COL HIRE_DATE FORMAT A12

-- ================================================================================
-- QUERY 1: Create a view called "employee_info"
-- ================================================================================
-- Shows employee's first name, last name, job title, department name, and salary

PROMPT ========================================
PROMPT Query 1: Create employee_info View
PROMPT ========================================

CREATE OR REPLACE VIEW employee_info AS
SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME,
    E.LAST_NAME,
    J.JOB_TITLE,
    D.DEPARTMENT_NAME,
    E.SALARY
FROM 
    HR.EMPLOYEES E
    LEFT OUTER JOIN HR.JOBS J ON E.JOB_ID = J.JOB_ID
    LEFT OUTER JOIN HR.DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;

PROMPT View employee_info created successfully!
PROMPT
PROMPT Selecting first 10 rows from employee_info:

SELECT * FROM employee_info
FETCH FIRST 10 ROWS ONLY;

-- ================================================================================
-- QUERY 2: Add a new column called "hire_date" to the "employee_info" view
-- ================================================================================
-- In Oracle, you alter a view by recreating it with CREATE OR REPLACE VIEW

PROMPT ========================================
PROMPT Query 2: Add hire_date Column to View
PROMPT ========================================

CREATE OR REPLACE VIEW employee_info AS
SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME,
    E.LAST_NAME,
    J.JOB_TITLE,
    D.DEPARTMENT_NAME,
    E.SALARY,
    E.HIRE_DATE
FROM 
    HR.EMPLOYEES E
    LEFT OUTER JOIN HR.JOBS J ON E.JOB_ID = J.JOB_ID
    LEFT OUTER JOIN HR.DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;

PROMPT View employee_info updated with hire_date column!
PROMPT
PROMPT Selecting first 10 rows from updated employee_info:

SELECT * FROM employee_info
FETCH FIRST 10 ROWS ONLY;

-- ================================================================================
-- QUERY 3: Update the view to show only employees with salary > $50,000
-- ================================================================================

PROMPT ========================================
PROMPT Query 3: Filter View for Salary > 50000
PROMPT ========================================

CREATE OR REPLACE VIEW employee_info AS
SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME,
    E.LAST_NAME,
    J.JOB_TITLE,
    D.DEPARTMENT_NAME,
    E.SALARY,
    E.HIRE_DATE
FROM 
    HR.EMPLOYEES E
    LEFT OUTER JOIN HR.JOBS J ON E.JOB_ID = J.JOB_ID
    LEFT OUTER JOIN HR.DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE 
    E.SALARY > 50000;

PROMPT View employee_info updated to show only salary > 50000!
PROMPT
PROMPT Selecting all rows from filtered employee_info:

SELECT * FROM employee_info
ORDER BY SALARY DESC;

-- ================================================================================
-- QUERY 4: Create a view named "my_view" showing employees in department 20
-- ================================================================================

PROMPT ========================================
PROMPT Query 4: Create my_view for Department 20
PROMPT ========================================

CREATE OR REPLACE VIEW my_view AS
SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME,
    E.LAST_NAME,
    E.JOB_ID,
    E.SALARY,
    E.DEPARTMENT_ID,
    D.DEPARTMENT_NAME
FROM 
    HR.EMPLOYEES E
    LEFT OUTER JOIN HR.DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE 
    E.DEPARTMENT_ID = 20;

PROMPT View my_view created for department 20!
PROMPT
PROMPT Selecting all rows from my_view:

SELECT * FROM my_view;

-- ================================================================================
-- QUERY 5: Alter "my_view" to show only employees in department 30
-- ================================================================================

PROMPT ========================================
PROMPT Query 5: Alter my_view for Department 30
PROMPT ========================================

CREATE OR REPLACE VIEW my_view AS
SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME,
    E.LAST_NAME,
    E.JOB_ID,
    E.SALARY,
    E.DEPARTMENT_ID,
    D.DEPARTMENT_NAME
FROM 
    HR.EMPLOYEES E
    LEFT OUTER JOIN HR.DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE 
    E.DEPARTMENT_ID = 30;

PROMPT View my_view altered to show department 30!
PROMPT
PROMPT Selecting all rows from altered my_view:

SELECT * FROM my_view;

-- ================================================================================
-- QUERY 6: Drop the "my_view" view from the database
-- ================================================================================

PROMPT ========================================
PROMPT Query 6: Drop my_view
PROMPT ========================================

DROP VIEW my_view;

PROMPT View my_view dropped successfully!
PROMPT
PROMPT Attempting to select from my_view (should fail):
-- SELECT * FROM my_view;  -- This will fail: table or view does not exist

-- ================================================================================
-- ADDITIONAL EXAMPLES: Working with Views
-- ================================================================================

-- ================================================================================
-- Example 1: Simple View - Department Employee Count
-- ================================================================================

PROMPT ========================================
PROMPT Example 1: Create dept_stats View
PROMPT ========================================

CREATE OR REPLACE VIEW dept_stats AS
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
    COUNT(E.EMPLOYEE_ID) > 0;

PROMPT View dept_stats created!
PROMPT
PROMPT Department statistics:

SELECT * FROM dept_stats
ORDER BY EMPLOYEE_COUNT DESC;

-- ================================================================================
-- Example 2: View with Complex Calculation
-- ================================================================================

PROMPT ========================================
PROMPT Example 2: Create emp_compensation View
PROMPT ========================================

CREATE OR REPLACE VIEW emp_compensation AS
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
    HR.EMPLOYEES E
    LEFT OUTER JOIN HR.DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;

PROMPT View emp_compensation created!
PROMPT
PROMPT Employee compensation details (top 10 by total compensation):

SELECT * FROM emp_compensation
ORDER BY TOTAL_COMPENSATION DESC
FETCH FIRST 10 ROWS ONLY;

-- ================================================================================
-- Example 3: View with Subquery
-- ================================================================================

PROMPT ========================================
PROMPT Example 3: Create high_earners View
PROMPT ========================================

CREATE OR REPLACE VIEW high_earners AS
SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME,
    E.LAST_NAME,
    E.SALARY,
    D.DEPARTMENT_NAME,
    J.JOB_TITLE
FROM 
    HR.EMPLOYEES E
    LEFT OUTER JOIN HR.DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
    LEFT OUTER JOIN HR.JOBS J ON E.JOB_ID = J.JOB_ID
WHERE 
    E.SALARY > (SELECT AVG(SALARY) FROM HR.EMPLOYEES);

PROMPT View high_earners created (employees earning above average)!
PROMPT
PROMPT High earners list:

SELECT * FROM high_earners
ORDER BY SALARY DESC;

-- ================================================================================
-- Example 4: Updatable View
-- ================================================================================

PROMPT ========================================
PROMPT Example 4: Create updatable_emp View
PROMPT ========================================

-- Note: A view is updatable if it meets certain conditions:
-- - No aggregate functions, DISTINCT, GROUP BY, or HAVING
-- - No set operators (UNION, INTERSECT, MINUS)
-- - Based on single base table or preserves key

CREATE OR REPLACE VIEW updatable_emp AS
SELECT 
    EMPLOYEE_ID,
    FIRST_NAME,
    LAST_NAME,
    EMAIL,
    SALARY,
    DEPARTMENT_ID
FROM 
    HR.EMPLOYEES
WHERE 
    DEPARTMENT_ID = 60;

PROMPT View updatable_emp created!
PROMPT This view can be used for INSERT, UPDATE, and DELETE operations.
PROMPT
PROMPT Current data in updatable_emp:

SELECT * FROM updatable_emp;

-- Example of updating through view (commented out to prevent actual changes):
-- UPDATE updatable_emp SET SALARY = SALARY * 1.10 WHERE EMPLOYEE_ID = 103;
-- COMMIT;

-- ================================================================================
-- Example 5: View with CHECK OPTION
-- ================================================================================

PROMPT ========================================
PROMPT Example 5: Create secure_dept_view with CHECK OPTION
PROMPT ========================================

-- CHECK OPTION ensures that all inserts/updates through the view
-- satisfy the view's WHERE clause

CREATE OR REPLACE VIEW secure_dept_view AS
SELECT 
    EMPLOYEE_ID,
    FIRST_NAME,
    LAST_NAME,
    SALARY,
    DEPARTMENT_ID
FROM 
    HR.EMPLOYEES
WHERE 
    DEPARTMENT_ID = 50
WITH CHECK OPTION CONSTRAINT secure_dept_check;

PROMPT View secure_dept_view created with CHECK OPTION!
PROMPT This view prevents inserting/updating rows that don't meet WHERE clause.
PROMPT
PROMPT Current data in secure_dept_view:

SELECT * FROM secure_dept_view
FETCH FIRST 10 ROWS ONLY;

-- ================================================================================
-- Example 6: View with READ ONLY option
-- ================================================================================

PROMPT ========================================
PROMPT Example 6: Create readonly_emp_view
PROMPT ========================================

CREATE OR REPLACE VIEW readonly_emp_view AS
SELECT 
    E.EMPLOYEE_ID,
    E.FIRST_NAME,
    E.LAST_NAME,
    D.DEPARTMENT_NAME,
    J.JOB_TITLE,
    E.SALARY
FROM 
    HR.EMPLOYEES E
    LEFT OUTER JOIN HR.DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
    LEFT OUTER JOIN HR.JOBS J ON E.JOB_ID = J.JOB_ID
WITH READ ONLY;

PROMPT View readonly_emp_view created (read-only)!
PROMPT This view cannot be used for INSERT, UPDATE, or DELETE.
PROMPT
PROMPT Data from readonly_emp_view (first 10 rows):

SELECT * FROM readonly_emp_view
FETCH FIRST 10 ROWS ONLY;

-- ================================================================================
-- Viewing Metadata about Views
-- ================================================================================

PROMPT ========================================
PROMPT View Metadata (USER_VIEWS)
PROMPT ========================================

COL VIEW_NAME FORMAT A20
COL TEXT_LENGTH FORMAT 9999
COL READ_ONLY FORMAT A10

SELECT 
    VIEW_NAME,
    TEXT_LENGTH,
    READ_ONLY
FROM 
    USER_VIEWS
WHERE 
    VIEW_NAME IN ('EMPLOYEE_INFO', 'DEPT_STATS', 'HIGH_EARNERS', 
                  'READONLY_EMP_VIEW', 'SECURE_DEPT_VIEW', 'UPDATABLE_EMP')
ORDER BY 
    VIEW_NAME;

-- ================================================================================
-- Clean up created views (optional)
-- ================================================================================

PROMPT ========================================
PROMPT Cleanup (Optional)
PROMPT ========================================

-- Uncomment these lines to drop all created views:
-- DROP VIEW employee_info;
-- DROP VIEW dept_stats;
-- DROP VIEW emp_compensation;
-- DROP VIEW high_earners;
-- DROP VIEW updatable_emp;
-- DROP VIEW secure_dept_view;
-- DROP VIEW readonly_emp_view;

-- PROMPT All views dropped!

-- ================================================================================
-- VIEW TYPES SUMMARY
-- ================================================================================

PROMPT ========================================
PROMPT VIEW TYPES SUMMARY
PROMPT ========================================
PROMPT Simple View: Based on single table, allows DML operations
PROMPT Complex View: Based on multiple tables or uses functions/grouping
PROMPT Inline View: Subquery in FROM clause, temporary view for one query
PROMPT Materialized View: Physical copy of data, refreshed periodically
PROMPT
PROMPT VIEW OPTIONS:
PROMPT WITH CHECK OPTION: Ensures DML operations satisfy view WHERE clause
PROMPT WITH READ ONLY: Prevents DML operations through view
PROMPT CREATE OR REPLACE: Updates existing view without dropping it
PROMPT FORCE: Creates view even if base tables don't exist

-- ================================================================================
-- End of Practical 10 (Oracle Version)
-- ================================================================================
