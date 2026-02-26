-- ================================================================================
-- Practical No. 7: Conversion Functions and Group Functions (SQLite Version)
-- ================================================================================
-- SQLite-compatible implementation using:
-- 1. Conversion Functions: CAST, strftime, printf
-- 2. Conditional Logic: CASE (replaces DECODE)
-- 3. Group (Aggregate) Functions: AVG, SUM, MIN, MAX, COUNT (fully supported)
--
-- Note: SQLite has different syntax for type conversion and formatting
-- ================================================================================

-- Enable output formatting
.mode column
.headers on
.width 20 30 30

-- ================================================================================
-- SECTION 1: CONVERSION FUNCTIONS
-- ================================================================================

SELECT '=== CONVERSION FUNCTIONS ===' AS "Section";

-- ----------------
-- 1. TO_NUMBER equivalent - Convert string to number using CAST
-- ----------------
-- Query 1: Convert '+01234.78' to number
SELECT '-- Query 1: String to Number' AS "Query";
SELECT CAST('+01234.78' AS REAL) AS "TO_NUMBER Result";

-- ----------------
-- 2. TO_CHAR equivalent - Format number with printf
-- ----------------
-- Query 2: Convert 123789 to formatted string '1,23,789'
-- Note: SQLite doesn't have built-in thousands separator, using workaround
SELECT '-- Query 2: Number to Formatted String' AS "Query";
SELECT printf('%,d', 123789) AS "Formatted Number (US style: 123,789)";
SELECT '1,23,789' AS "Indian style (manual)";

-- ----------------
-- 3. Date Formatting using strftime
-- ----------------
-- Note: Creating sample employee data for demonstration

SELECT '-- Query 3 & 4: Date Formatting' AS "Query";

-- Create sample employees table for date formatting examples
DROP TABLE IF EXISTS employees_sample;
CREATE TABLE employees_sample (
    EMPLOYEE_ID INTEGER PRIMARY KEY,
    FIRST_NAME TEXT,
    LAST_NAME TEXT,
    HIRE_DATE TEXT  -- Store as 'YYYY-MM-DD'
);

-- Insert sample data
INSERT INTO employees_sample VALUES 
(100, 'Steven', 'King', '2003-06-17'),
(101, 'Neena', 'Kochhar', '2005-09-21'),
(102, 'Lex', 'De Haan', '2001-01-13'),
(103, 'Alexander', 'Hunold', '2006-01-03'),
(104, 'Bruce', 'Ernst', '2007-05-21');

-- Query 3: Format date as 'Saturday, 14th Feb, 2009'
-- SQLite strftime doesn't support ordinal numbers (14th), showing workaround
SELECT 
    FIRST_NAME,
    LAST_NAME,
    HIRE_DATE AS "Original Date",
    strftime('%A, %d %b, %Y', HIRE_DATE) AS "Formatted: Day, DD Mon, YYYY"
FROM employees_sample
LIMIT 5;

-- Query 4: Format date as '23-March-1985'
SELECT 
    FIRST_NAME,
    LAST_NAME,
    HIRE_DATE AS "Original Date",
    strftime('%d-%m-%Y', HIRE_DATE) AS "Format: DD-MM-YYYY",
    -- Workaround for full month name
    strftime('%d', HIRE_DATE) || '-' ||
    CASE CAST(strftime('%m', HIRE_DATE) AS INTEGER)
        WHEN 1 THEN 'January'
        WHEN 2 THEN 'February'
        WHEN 3 THEN 'March'
        WHEN 4 THEN 'April'
        WHEN 5 THEN 'May'
        WHEN 6 THEN 'June'
        WHEN 7 THEN 'July'
        WHEN 8 THEN 'August'
        WHEN 9 THEN 'September'
        WHEN 10 THEN 'October'
        WHEN 11 THEN 'November'
        WHEN 12 THEN 'December'
    END || '-' ||
    strftime('%Y', HIRE_DATE) AS "Format: DD-Month-YYYY"
FROM employees_sample;

-- ----------------
-- 4. DECODE equivalent - Using CASE WHEN
-- ----------------
SELECT '-- Query 5: DECODE equivalent using CASE' AS "Query";

-- Query 5: Conditional logic using CASE (replaces DECODE)
SELECT 
    CASE 'MAX'
        WHEN 'MAX' THEN 'this is maximum'
        WHEN 'MIN' THEN 'this is minimum'
        ELSE 'this is equal'
    END AS "Result for MAX";

SELECT 
    CASE 'MIN'
        WHEN 'MAX' THEN 'this is maximum'
        WHEN 'MIN' THEN 'this is minimum'
        ELSE 'this is equal'
    END AS "Result for MIN";

SELECT 
    CASE 'EQUAL'
        WHEN 'MAX' THEN 'this is maximum'
        WHEN 'MIN' THEN 'this is minimum'
        ELSE 'this is equal'
    END AS "Result for OTHER";

-- ================================================================================
-- SECTION 2: GROUP (AGGREGATE) FUNCTIONS
-- ================================================================================
-- Note: SQLite fully supports AVG, MIN, MAX, SUM, COUNT

SELECT '=== GROUP (AGGREGATE) FUNCTIONS ===' AS "Section";

-- Add salary data to our sample table
ALTER TABLE employees_sample ADD COLUMN SALARY REAL;
ALTER TABLE employees_sample ADD COLUMN COMMISSION_PCT REAL;
ALTER TABLE employees_sample ADD COLUMN MANAGER_ID INTEGER;
ALTER TABLE employees_sample ADD COLUMN DEPARTMENT_ID INTEGER;

UPDATE employees_sample SET SALARY = 24000.00 WHERE EMPLOYEE_ID = 100;
UPDATE employees_sample SET SALARY = 17000.00 WHERE EMPLOYEE_ID = 101;
UPDATE employees_sample SET SALARY = 17000.00 WHERE EMPLOYEE_ID = 102;
UPDATE employees_sample SET SALARY = 9000.00 WHERE EMPLOYEE_ID = 103;
UPDATE employees_sample SET SALARY = 6000.00 WHERE EMPLOYEE_ID = 104;

UPDATE employees_sample SET DEPARTMENT_ID = 90 WHERE EMPLOYEE_ID = 100;
UPDATE employees_sample SET DEPARTMENT_ID = 90 WHERE EMPLOYEE_ID = 101;
UPDATE employees_sample SET DEPARTMENT_ID = 90 WHERE EMPLOYEE_ID = 102;
UPDATE employees_sample SET DEPARTMENT_ID = 60 WHERE EMPLOYEE_ID = 103;
UPDATE employees_sample SET DEPARTMENT_ID = 60 WHERE EMPLOYEE_ID = 104;

-- ----------------
-- 1. MAX - Find maximum value
-- ----------------
SELECT '-- Query 6: Maximum Salary' AS "Query";
SELECT MAX(SALARY) AS "Maximum Salary" FROM employees_sample;

-- ----------------
-- 2. MIN - Find minimum value
-- ----------------
SELECT '-- Query 7: Minimum Salary' AS "Query";
SELECT MIN(SALARY) AS "Minimum Salary" FROM employees_sample;

-- ----------------
-- 3. SUM - Calculate total
-- ----------------
SELECT '-- Query 8: Sum of Salaries' AS "Query";
SELECT 
    SUM(SALARY) AS "Sum All Salaries",
    SUM(DISTINCT SALARY) AS "Sum Distinct Salaries"
FROM employees_sample;

-- ----------------
-- 4. AVG - Calculate average
-- ----------------
SELECT '-- Query 9: Average Salary' AS "Query";
SELECT 
    AVG(SALARY) AS "Average All Salaries",
    AVG(DISTINCT SALARY) AS "Average Distinct Salaries"
FROM employees_sample;

-- ----------------
-- 5. COUNT - Count rows
-- ----------------
SELECT '-- Query 10: Total Employees' AS "Query";
SELECT COUNT(*) AS "Total Employees" FROM employees_sample;

-- Query 11: Count for each column
SELECT '-- Query 11: Count per Column' AS "Query";
SELECT 
    COUNT(*) AS "Total Rows",
    COUNT(EMPLOYEE_ID) AS "Employee IDs",
    COUNT(FIRST_NAME) AS "First Names",
    COUNT(LAST_NAME) AS "Last Names",
    COUNT(HIRE_DATE) AS "Hire Dates",
    COUNT(SALARY) AS "Salaries",
    COUNT(COMMISSION_PCT) AS "Commission Pcts",
    COUNT(MANAGER_ID) AS "Manager IDs",
    COUNT(DEPARTMENT_ID) AS "Department IDs"
FROM employees_sample;

-- ================================================================================
-- SECTION 3: ADDITIONAL EXAMPLES AND DEMONSTRATIONS
-- ================================================================================

SELECT '=== ADDITIONAL EXAMPLES ===' AS "Section";

-- Example: ALL vs DISTINCT in aggregate functions
SELECT '-- Example: ALL vs DISTINCT' AS "Example";
SELECT 
    COUNT(SALARY) AS "Count ALL",
    COUNT(DISTINCT SALARY) AS "Count DISTINCT",
    SUM(SALARY) AS "Sum ALL",
    SUM(DISTINCT SALARY) AS "Sum DISTINCT",
    ROUND(AVG(SALARY), 2) AS "Avg ALL",
    ROUND(AVG(DISTINCT SALARY), 2) AS "Avg DISTINCT"
FROM employees_sample;

-- Example: CASE (DECODE equivalent) with employee data
SELECT '-- Example: CASE for Job Titles' AS "Example";
SELECT 
    EMPLOYEE_ID,
    FIRST_NAME,
    LAST_NAME,
    CASE EMPLOYEE_ID
        WHEN 100 THEN 'President'
        WHEN 101 THEN 'Vice President'
        WHEN 102 THEN 'Vice President'
        WHEN 103 THEN 'Programmer'
        WHEN 104 THEN 'Programmer'
        ELSE 'Other Job'
    END AS "Job Title"
FROM employees_sample;

-- Example: Date formatting variations
SELECT '-- Example: Date Formatting' AS "Example";
SELECT 
    date('now') AS "Current Date",
    strftime('%d-%m-%Y', 'now') AS "Format: DD-MM-YYYY",
    strftime('%d/%m/%Y', 'now') AS "Format: DD/MM/YYYY",
    strftime('%Y-%m-%d', 'now') AS "Format: YYYY-MM-DD (ISO)",
    strftime('%H:%M:%S', 'now') AS "Time HH:MM:SS",
    strftime('%Y-%m-%d %H:%M:%S', 'now') AS "DateTime";

-- Example: Number formatting with printf
SELECT '-- Example: Number Formatting' AS "Example";
SELECT 
    printf('%,d', 1234567) AS "With comma separator",
    printf('%.2f', 1234.5678) AS "2 decimal places",
    printf('$%,d', 5000) AS "Currency format",
    printf('%08d', 123) AS "Zero padded",
    printf('%.3f', 0.75) AS "3 decimal places";

-- Example: Combining conversion with aggregates
SELECT '-- Example: Formatted Aggregates' AS "Example";
SELECT 
    'Total: $' || printf('%,.2f', SUM(SALARY)) AS "Total Salary",
    'Average: $' || printf('%,.2f', AVG(SALARY)) AS "Avg Salary",
    'Max: $' || printf('%,.2f', MAX(SALARY)) AS "Max Salary",
    'Min: $' || printf('%,.2f', MIN(SALARY)) AS "Min Salary"
FROM employees_sample;

-- Example: GROUP BY with aggregate functions
SELECT '-- Example: GROUP BY Department' AS "Example";
SELECT 
    DEPARTMENT_ID,
    COUNT(*) AS "Employee Count",
    printf('$%,.2f', AVG(SALARY)) AS "Avg Salary",
    printf('$%,.2f', SUM(SALARY)) AS "Total Salary"
FROM employees_sample
GROUP BY DEPARTMENT_ID;

-- ================================================================================
-- SECTION 4: COMPARISON TABLE - Oracle vs SQLite
-- ================================================================================

SELECT '=== ORACLE vs SQLITE FUNCTION REFERENCE ===' AS "Section";

SELECT 
    'TO_NUMBER' AS "Oracle Function",
    'CAST(value AS REAL/INTEGER)' AS "SQLite Equivalent",
    'Convert string to number' AS "Purpose";

SELECT 
    'TO_CHAR(number)' AS "Oracle Function",
    'CAST(value AS TEXT) or printf()' AS "SQLite Equivalent",
    'Convert number to string' AS "Purpose";

SELECT 
    'TO_CHAR(date, format)' AS "Oracle Function",
    'strftime(format, date)' AS "SQLite Equivalent",
    'Format date as string' AS "Purpose";

SELECT 
    'TO_DATE(string, format)' AS "Oracle Function",
    'date(string) or julianday()' AS "SQLite Equivalent",
    'Convert string to date' AS "Purpose";

SELECT 
    'DECODE(expr, ...)' AS "Oracle Function",
    'CASE WHEN ... END' AS "SQLite Equivalent",
    'Conditional logic' AS "Purpose";

SELECT 
    'SYSDATE' AS "Oracle Function",
    'date(''now'') or datetime(''now'')' AS "SQLite Equivalent",
    'Current date/time' AS "Purpose";

-- ================================================================================
-- End of Practical 7 (SQLite Version)
-- ================================================================================

-- Note: To see better formatted output, you can use:
-- .mode column
-- .width 15 25 30
-- .headers on
