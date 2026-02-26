-- ================================================================================
-- Practical No. 7: Conversion Functions and Group Functions
-- ================================================================================
-- Implement SQL queries using:
-- 1. Conversion Functions: TO_NUMBER, TO_CHAR, TO_DATE
-- 2. Miscellaneous Functions: DECODE
-- 3. Group (Aggregate) Functions: AVG, SUM, MIN, MAX, COUNT
--
-- Course: Database Management System (DI04032011)
-- Semester: IV - ICT Engineering
-- ================================================================================

-- ================================================================================
-- SECTION 1: CONVERSION FUNCTIONS
-- ================================================================================

-- ----------------
-- 1. TO_NUMBER - Convert string to number
-- ----------------
-- Query 1: Convert '+01234.78' to number
SELECT TO_NUMBER('+01234.78') AS "TO_NUMBER Result" FROM DUAL;

-- ----------------
-- 2. TO_CHAR - Convert number to character with format
-- ----------------
-- Query 2: Convert a value 123789 to character using '9,99,999' format
SELECT TO_CHAR(123789, '9,99,999') AS "Formatted Number" FROM DUAL;

-- ----------------
-- 3. TO_CHAR - Convert date to formatted character string
-- ----------------
-- Note: Using HR.EMPLOYEES table for date formatting queries

-- Query 3: List out hire date in form of 'Saturday, 14th Feb, 2009' for employee
SELECT FIRST_NAME, LAST_NAME,
       TO_CHAR(HIRE_DATE, 'Day, DDth Mon, YYYY') AS "Hire Date Formatted"
FROM HR.EMPLOYEES
WHERE ROWNUM <= 5;

-- Query 4: List out hire date in form of '23-March-1985' for all employees
SELECT FIRST_NAME, LAST_NAME,
       TO_CHAR(HIRE_DATE, 'DD-Month-YYYY') AS "Hire Date"
FROM HR.EMPLOYEES
WHERE ROWNUM <= 10;

-- ----------------
-- 4. DECODE - Conditional logic (IF-THEN-ELSE)
-- ----------------
-- Query 5: If input value is 'MAX' display 'this is maximum', 
--          if 'MIN' display 'this is minimum', 
--          otherwise display 'this is equal'
SELECT DECODE('MAX', 
              'MAX', 'this is maximum',
              'MIN', 'this is minimum',
              'this is equal') AS "Result for MAX" 
FROM DUAL;

SELECT DECODE('MIN', 
              'MAX', 'this is maximum',
              'MIN', 'this is minimum',
              'this is equal') AS "Result for MIN" 
FROM DUAL;

SELECT DECODE('EQUAL', 
              'MAX', 'this is maximum',
              'MIN', 'this is minimum',
              'this is equal') AS "Result for OTHER" 
FROM DUAL;

-- ================================================================================
-- SECTION 2: GROUP (AGGREGATE) FUNCTIONS
-- ================================================================================
-- Note: Consider HR.EMPLOYEES table to solve all queries

-- ----------------
-- 1. MAX - Find maximum value
-- ----------------
-- Query 6: Find maximum salary from table
SELECT MAX(SALARY) AS "Maximum Salary" FROM HR.EMPLOYEES;

-- ----------------
-- 2. MIN - Find minimum value
-- ----------------
-- Query 7: Find minimum salary from table
SELECT MIN(SALARY) AS "Minimum Salary" FROM HR.EMPLOYEES;

-- ----------------
-- 3. SUM - Calculate total
-- ----------------
-- Query 8: Find sum of all and distinct salary from table
SELECT SUM(SALARY) AS "Sum All Salaries",
       SUM(DISTINCT SALARY) AS "Sum Distinct Salaries"
FROM HR.EMPLOYEES;

-- ----------------
-- 4. AVG - Calculate average
-- ----------------
-- Query 9: Find average of all and distinct salaries from table
SELECT AVG(SALARY) AS "Average All Salaries",
       AVG(DISTINCT SALARY) AS "Average Distinct Salaries"
FROM HR.EMPLOYEES;

-- ----------------
-- 5. COUNT - Count rows
-- ----------------
-- Query 10: Find total number of employees
SELECT COUNT(*) AS "Total Employees" FROM HR.EMPLOYEES;

-- Query 11: Find total number of rows for each column from table
-- This shows count for different columns (some may have NULL values)
SELECT 
    COUNT(*) AS "Total Rows",
    COUNT(EMPLOYEE_ID) AS "Employee IDs",
    COUNT(FIRST_NAME) AS "First Names",
    COUNT(LAST_NAME) AS "Last Names",
    COUNT(EMAIL) AS "Emails",
    COUNT(PHONE_NUMBER) AS "Phone Numbers",
    COUNT(HIRE_DATE) AS "Hire Dates",
    COUNT(JOB_ID) AS "Job IDs",
    COUNT(SALARY) AS "Salaries",
    COUNT(COMMISSION_PCT) AS "Commission Percentages",
    COUNT(MANAGER_ID) AS "Manager IDs",
    COUNT(DEPARTMENT_ID) AS "Department IDs"
FROM HR.EMPLOYEES;

-- ================================================================================
-- SECTION 3: ADDITIONAL EXAMPLES AND DEMONSTRATIONS
-- ================================================================================

-- Example: ALL vs DISTINCT in aggregate functions
-- Create sample data for demonstration
SELECT 'Demonstration: ALL vs DISTINCT in aggregate functions' AS "Info" FROM DUAL;

-- Show difference between ALL and DISTINCT for salary ranges
SELECT 
    COUNT(SALARY) AS "Count ALL",
    COUNT(DISTINCT SALARY) AS "Count DISTINCT",
    SUM(SALARY) AS "Sum ALL",
    SUM(DISTINCT SALARY) AS "Sum DISTINCT",
    AVG(SALARY) AS "Avg ALL",
    AVG(DISTINCT SALARY) AS "Avg DISTINCT"
FROM HR.EMPLOYEES;

-- Example: DECODE with multiple values
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, JOB_ID,
       DECODE(JOB_ID,
              'AD_PRES', 'President',
              'AD_VP', 'Vice President',
              'IT_PROG', 'Programmer',
              'ST_CLERK', 'Clerk',
              'Other Job') AS "Job Title Description"
FROM HR.EMPLOYEES
WHERE ROWNUM <= 10;

-- Example: TO_CHAR date formatting variations
SELECT SYSDATE AS "Current Date",
       TO_CHAR(SYSDATE, 'DD-MON-YYYY') AS "Format 1",
       TO_CHAR(SYSDATE, 'DD/MM/YYYY') AS "Format 2",
       TO_CHAR(SYSDATE, 'Day, Month DD, YYYY') AS "Format 3",
       TO_CHAR(SYSDATE, 'HH24:MI:SS') AS "Time",
       TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS') AS "Date & Time"
FROM DUAL;

-- Example: TO_CHAR number formatting
SELECT 
    TO_CHAR(1234567, '9,999,999') AS "Format with comma",
    TO_CHAR(1234567, '09,999,999') AS "Format with leading zero",
    TO_CHAR(5000, '$99,999') AS "Currency format",
    TO_CHAR(0.75, '0.99') AS "Decimal format"
FROM DUAL;

-- Example: Combining conversion functions with aggregate functions
SELECT 
    'Total Salary: ' || TO_CHAR(SUM(SALARY), '$999,999,999') AS "Formatted Total",
    'Average Salary: ' || TO_CHAR(AVG(SALARY), '$999,999.99') AS "Formatted Average",
    'Max Salary: ' || TO_CHAR(MAX(SALARY), '$999,999') AS "Formatted Max",
    'Min Salary: ' || TO_CHAR(MIN(SALARY), '$999,999') AS "Formatted Min"
FROM HR.EMPLOYEES;

-- ================================================================================
-- End of Practical 7
-- ================================================================================
