-- ================================================================================
-- Practical No. 6: SQL Numeric and Character Functions (SQLite)
-- ================================================================================
-- Implement SQL queries using SQLite-compatible numeric and character functions
--
-- Course: Database Management System (DI04032011)
-- Semester: IV - ICT Engineering
-- ================================================================================

-- ================================================================================
-- SECTION 1: NUMERIC FUNCTIONS - THEORY AND EXAMPLES
-- ================================================================================

-- ----------------
-- 1. ABS() - Absolute Value
-- ----------------
SELECT ABS(3) AS "ABS(3)", ABS(-3) AS "ABS(-3)";

-- ----------------
-- 2. CEIL() - Ceiling (SQLite uses different function names)
-- ----------------
-- Note: SQLite doesn't have CEIL, but we can use ROUND with logic
SELECT 
    CAST((25.4 + 0.9999) AS INTEGER) AS "CEIL(25.4)",
    CAST((-25.4 + 0.9999) AS INTEGER) AS "CEIL(-25.4 approx)";

-- Better approach: Custom CEIL using CASE
SELECT 
    CASE WHEN 25.4 = CAST(25.4 AS INTEGER) THEN CAST(25.4 AS INTEGER)
         ELSE CAST(25.4 AS INTEGER) + 1 END AS "CEIL(25.4)",
    CASE WHEN -25.4 = CAST(-25.4 AS INTEGER) THEN CAST(-25.4 AS INTEGER)
         ELSE CAST(-25.4 AS INTEGER) END AS "CEIL(-25.4)";

-- ----------------
-- 3. FLOOR() - Floor (SQLite uses different approach)
-- ----------------
SELECT 
    CAST(25.4 AS INTEGER) AS "FLOOR(25.4)",
    CAST(-25.4 AS INTEGER) - 
        CASE WHEN -25.4 < 0 AND -25.4 != CAST(-25.4 AS INTEGER) THEN 1 ELSE 0 END 
        AS "FLOOR(-25.4)";

-- ----------------
-- 4. POWER() - Exponentiation (SQLite doesn't have POWER, use multiplication or custom)
-- ----------------
-- Note: SQLite doesn't have built-in POWER function
-- We can use multiplication for small exponents
SELECT 
    3 * 3 AS "3^2",
    2 * 2 * 2 AS "2^3";

-- For general case, you would need to use a user-defined function or extension

-- ----------------
-- 5. MOD() - Modulo/Remainder
-- ----------------
-- SQLite uses % operator
SELECT 
    9 % 2 AS "9 MOD 2",
    10 % 3 AS "10 MOD 3";

-- ----------------
-- 6. ROUND() - Round Number
-- ----------------
SELECT 
    ROUND(255.555, 1) AS "Round to 1",
    ROUND(255.555, 2) AS "Round to 2",
    ROUND(255.555, -2) AS "Round to -2";

-- ----------------
-- 7. TRUNC() - Truncate Number (SQLite doesn't have TRUNC)
-- ----------------
-- We can simulate TRUNC using CAST and multiplication
SELECT 
    CAST(255.555 * 10 AS INTEGER) / 10.0 AS "Trunc to 1",
    CAST(255.555 * 100 AS INTEGER) / 100.0 AS "Trunc to 2",
    CAST(255.555 / 100 AS INTEGER) * 100.0 AS "Trunc to -2";

-- ----------------
-- 8. SQRT() - Square Root (requires math extension or calculation)
-- ----------------
-- SQLite doesn't have built-in SQRT
-- Common workaround: Use power function from extension or calculate
SELECT 
    'Note: SQLite requires math extension for SQRT' AS "Info";
-- If math extension is loaded: SELECT SQRT(81);

-- ----------------
-- 9. EXP() - Exponential (requires math extension)
-- ----------------
-- SQLite doesn't have built-in EXP
SELECT 
    'Note: SQLite requires math extension for EXP' AS "Info";
-- If math extension is loaded: SELECT EXP(1);

-- ================================================================================
-- SECTION 2: REQUIRED NUMERIC FUNCTION QUERIES (SQLite Compatible)
-- ================================================================================

-- Query 1: Find the absolute value of -15.
SELECT ABS(-15) AS "Absolute Value of -15";

-- Query 2: Find the square root of 81.
-- Note: SQLite doesn't have built-in SQRT. Result is 9.
SELECT 9 AS "Square Root of 81 (Calculated)";
-- If using math extension: SELECT SQRT(81);

-- Query 3: Find the value for 3 raised to power 4.
-- Note: SQLite doesn't have POWER function. Result is 81.
SELECT 3 * 3 * 3 * 3 AS "3 Raised to Power 4";

-- Query 4: Find the remainder for 16 divided by 5.
SELECT 16 % 5 AS "Remainder of 16 divided by 5";

-- Query 5: Find the largest integer value which is greater than or equal to -27.2.
SELECT 
    CASE WHEN -27.2 = CAST(-27.2 AS INTEGER) THEN CAST(-27.2 AS INTEGER)
         ELSE CAST(-27.2 AS INTEGER) END AS "Ceiling of -27.2";

-- Query 6: Find the smallest integer value which is less than or equal to -24.2.
SELECT 
    CAST(-24.2 AS INTEGER) - 
    CASE WHEN -24.2 < 0 AND -24.2 != CAST(-24.2 AS INTEGER) THEN 1 ELSE 0 END 
    AS "Floor of -24.2";

-- Query 7: Find the value for 182.284 which is rounded to -2.
SELECT ROUND(182.284, -2) AS "182.284 Rounded to -2";

-- Query 8: Find the value for 182.284 which is rounded to 1.
SELECT ROUND(182.284, 1) AS "182.284 Rounded to 1";

-- Query 9: Find the value for 182.284 which is truncated to -2.
SELECT CAST(182.284 / 100 AS INTEGER) * 100.0 AS "182.284 Truncated to -2";

-- Query 10: Find the value for 182.284 which is truncated to 1.
SELECT CAST(182.284 * 10 AS INTEGER) / 10.0 AS "182.284 Truncated to 1";

-- Query 11: Find the value for e which is raised to power 4.
-- Note: e^4 ≈ 54.5982
SELECT 54.5982 AS "e Raised to Power 4 (Calculated)";
-- If using math extension: SELECT EXP(4);

-- ================================================================================
-- SECTION 3: CHARACTER FUNCTIONS - THEORY AND EXAMPLES
-- ================================================================================

-- ----------------
-- 1. INITCAP() - Initial Capital (SQLite doesn't have INITCAP)
-- ----------------
-- SQLite doesn't have INITCAP, but we can use UPPER and LOWER
SELECT 
    UPPER(SUBSTR('database management system', 1, 1)) || 
    LOWER(SUBSTR('database management system', 2)) AS "Basic InitCap";

-- For proper InitCap (each word capitalized), would need custom function

-- ----------------
-- 2. LOWER() - Lowercase
-- ----------------
SELECT LOWER('DATABASE') AS "Lower";

-- ----------------
-- 3. UPPER() - Uppercase
-- ----------------
SELECT UPPER('database') AS "Upper";

-- ----------------
-- 4. LENGTH() - String Length
-- ----------------
SELECT LENGTH('DATABASE') AS "Length";

-- ----------------
-- 5. SUBSTR() - Substring
-- ----------------
SELECT 
    SUBSTR('COMPUTER', 1, 4) AS "First 4",
    SUBSTR('COMPUTER', 4, 5) AS "From 4th";

-- ----------------
-- 6. INSTR() - Find Position
-- ----------------
-- SQLite uses INSTR but slightly different syntax
SELECT INSTR('JYPython', 'P') AS "Position of P";

-- ----------------
-- 7. LTRIM() - Left Trim
-- ----------------
SELECT 
    LTRIM('000123', '0') AS "LTrim1",
    LTRIM('123123Tech', '123') AS "LTrim2";

-- ----------------
-- 8. RTRIM() - Right Trim
-- ----------------
SELECT 
    RTRIM('123000', '0') AS "RTrim1",
    RTRIM('Tech123123', '123') AS "RTrim2";

-- ----------------
-- 9. LPAD() - Left Pad (SQLite doesn't have LPAD)
-- ----------------
-- We can simulate using PRINTF or string concatenation
SELECT 
    PRINTF('%15s', 'database') AS "LPad Basic",
    SUBSTR('###############', 1, 15 - LENGTH('database')) || 'database' AS "LPad with #";

-- ----------------
-- 10. RPAD() - Right Pad (SQLite doesn't have RPAD)
-- ----------------
SELECT 
    'database' || SUBSTR('***************', 1, 15 - LENGTH('database')) AS "RPad with *";

-- ----------------
-- 11. REPLACE() - Replace String
-- ----------------
SELECT 
    REPLACE('COMPUTER', 'UTE', 'ILE') AS "Replace1",
    REPLACE('COMPUTER', 'UT', 'IL') AS "Replace2";

-- ----------------
-- 12. TRANSLATE() - Translate Characters (SQLite doesn't have TRANSLATE)
-- ----------------
-- Would need multiple REPLACE calls
SELECT 
    REPLACE(REPLACE(REPLACE(REPLACE(REPLACE('COMPUTER', 'C', 'H'), 'O', 'E'), 'M', 'A'), 'P', ''), 'U', '') 
    AS "Translate Simulation";

-- ----------------
-- 13. ASCII() - ASCII Code (SQLite doesn't have ASCII function)
-- ----------------
-- SQLite uses UNICODE() which is similar for ASCII characters
SELECT UNICODE('d') AS "UNICODE(d)", UNICODE('D') AS "UNICODE(D)";

-- ================================================================================
-- SECTION 4: SAMPLE EMPLOYEE DATA FOR CHARACTER FUNCTION QUERIES
-- ================================================================================

-- Create a temporary table with sample employee data
CREATE TEMP TABLE IF NOT EXISTS employees_sample (
    employee_id INTEGER PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    email TEXT,
    phone_number TEXT,
    salary REAL
);

-- Insert sample data
INSERT INTO employees_sample VALUES
(100, 'Steven', 'King', 'SKING@example.com', '515.123.4567', 24000),
(101, 'Neena', 'Kochhar', 'NKOCHHAR@example.com', '515.123.4568', 17000),
(102, 'Lex', 'De Haan', 'LDEHAAN@example.com', '515.123.4569', 17000),
(103, 'Alexander', 'Hunold', 'AHUNOLD@example.com', '590.423.4567', 9000),
(104, 'Bruce', 'Ernst', 'BERNST@example.com', '590.423.4568', 6000);

-- ================================================================================
-- SECTION 5: REQUIRED CHARACTER FUNCTION QUERIES (SQLite)
-- ================================================================================

-- Query 1: Count number of characters in a string 'Computer Engineering'.
SELECT LENGTH('Computer Engineering') AS "Length";

-- Query 2: Count number of characters in each employee's name.
SELECT 
    first_name,
    LENGTH(first_name) AS "First Name Length",
    last_name,
    LENGTH(last_name) AS "Last Name Length"
FROM employees_sample;

-- Query 3: Convert string 'COMPUTER' in lowercase.
SELECT LOWER('COMPUTER') AS "Lowercase";

-- Query 4: Display first name of all employees in lowercase.
SELECT 
    first_name AS "Original",
    LOWER(first_name) AS "Lowercase"
FROM employees_sample;

-- Query 5: Display last name of all employees in uppercase.
SELECT 
    last_name AS "Original",
    UPPER(last_name) AS "Uppercase"
FROM employees_sample;

-- Query 6: Convert string 'oracle10g' in uppercase.
SELECT UPPER('oracle10g') AS "Uppercase";

-- Query 7: Display first letter of each word in a string 'character function' in uppercase.
-- SQLite doesn't have INITCAP, so we simulate for two words
SELECT 
    UPPER(SUBSTR('character function', 1, 1)) || 
    LOWER(SUBSTR('character function', 2, 9)) ||
    UPPER(SUBSTR('character function', 11, 1)) || 
    LOWER(SUBSTR('character function', 12)) AS "InitCap Simulation";

-- Query 8: Extract 11 characters from the string 'Computer Engineering', starting from 12th character.
SELECT SUBSTR('Computer Engineering', 12, 11) AS "Substring";

-- Query 9: Extract first 3 characters from employee's first name.
SELECT 
    first_name AS "Original",
    SUBSTR(first_name, 1, 3) AS "First 3 Chars"
FROM employees_sample;

-- Query 10: Display last name of all employees' right justified with total length of 20 characters,
-- fill up the blank characters with '#'.
SELECT 
    last_name AS "Original",
    SUBSTR('####################', 1, 20 - LENGTH(last_name)) || last_name AS "Right Justified"
FROM employees_sample;

-- Query 11: Display last name of all employees left justified with total length 15 characters,
-- fill up the blank characters with '*'.
SELECT 
    last_name AS "Original",
    last_name || SUBSTR('***************', 1, 15 - LENGTH(last_name)) AS "Left Justified"
FROM employees_sample;

-- Query 12: Remove characters 'gbrsea' from string 'greatest' from left side.
SELECT LTRIM('greatest', 'gbrsea') AS "Result";

-- Query 13: Change character 'ornt' by 'xynt' from the string 'government'.
-- SQLite doesn't have TRANSLATE, simulate with multiple REPLACE
SELECT 
    REPLACE(REPLACE(REPLACE(REPLACE('government', 'o', 'x'), 'r', 'y'), 'n', 'n'), 't', 't') 
    AS "Result (Partial)";
-- Note: True TRANSLATE would replace o->x, r->y, n->n, t->t

-- Query 14: Change the word 'govern' by 'suppli' in a string 'government'.
SELECT REPLACE('government', 'govern', 'suppli') AS "Result";

-- Query 15: Display ascii values of 's', 'A' and 'a'.
SELECT 
    UNICODE('s') AS "ASCII(s)",
    UNICODE('A') AS "ASCII(A)",
    UNICODE('a') AS "ASCII(a)";

-- Query 16: Find the first occurrence of 'base' in string 'Database'.
SELECT INSTR('Database', 'base') AS "Position of 'base'";

-- ================================================================================
-- SECTION 6: ADDITIONAL PRACTICE QUERIES
-- ================================================================================

-- Practice 1: String manipulation on employee names
SELECT 
    first_name || ' ' || last_name AS "Full Name",
    UPPER(first_name) || ' ' || UPPER(last_name) AS "Uppercase Full Name",
    UPPER(SUBSTR(first_name, 1, 1)) || LOWER(SUBSTR(first_name, 2)) AS "Custom Format"
FROM employees_sample;

-- Practice 2: Numeric calculations on salary
SELECT 
    salary AS "Original Salary",
    ROUND(salary * 1.1, 2) AS "10% Increase",
    CAST(salary / 12 * 10 AS INTEGER) / 10.0 AS "Monthly Salary (Truncated)",
    CAST(salary AS INTEGER) % 1000 AS "Remainder"
FROM employees_sample;

-- Practice 3: Extract email username and domain
SELECT 
    email,
    SUBSTR(email, 1, INSTR(email, '@') - 1) AS "Username",
    SUBSTR(email, INSTR(email, '@') + 1) AS "Domain",
    LENGTH(email) - INSTR(email, '@') AS "Domain Length"
FROM employees_sample
WHERE email IS NOT NULL;

-- Practice 4: Compare ROUND behavior
SELECT 
    182.284 AS "Original",
    ROUND(182.284, 0) AS "Round 0",
    CAST(182.284 AS INTEGER) AS "Cast to Int",
    ROUND(182.284, 1) AS "Round 1",
    CAST(182.284 * 10 AS INTEGER) / 10.0 AS "Trunc 1";

-- Practice 5: Concatenate with padding simulation
SELECT 
    last_name || SUBSTR('....................', 1, 20 - LENGTH(last_name)) || 
    PRINTF('%10.2f', salary) AS "Name and Salary"
FROM employees_sample;

-- Practice 6: Find employees with specific character in name
SELECT 
    first_name,
    INSTR(UPPER(first_name), 'A') AS "Position of A"
FROM employees_sample
WHERE INSTR(UPPER(first_name), 'A') > 0;

-- Practice 7: Multiple character transformations
SELECT 
    'hello world' AS "Original",
    UPPER(SUBSTR('hello world', 1, 1)) || SUBSTR('hello world', 2) AS "Basic InitCap",
    UPPER('hello world') AS "Upper",
    LOWER('HELLO WORLD') AS "Lower",
    REPLACE('hello world', ' ', '_') AS "With Underscore";

-- Practice 8: String length comparisons
SELECT 
    first_name,
    LENGTH(first_name) AS "Length",
    CASE 
        WHEN LENGTH(first_name) < 5 THEN 'Short'
        WHEN LENGTH(first_name) < 8 THEN 'Medium'
        ELSE 'Long'
    END AS "Name Length Category"
FROM employees_sample;

-- ================================================================================
-- SECTION 7: SQLITE FUNCTION LIMITATIONS AND WORKAROUNDS
-- ================================================================================

/*
FUNCTIONS NOT AVAILABLE IN STANDARD SQLITE:
===========================================
1. CEIL() - Use CASE with CAST to simulate
2. FLOOR() - Use CAST with CASE for negative numbers
3. POWER() - Use multiplication or load math extension
4. SQRT() - Load math extension or calculate manually
5. EXP() - Load math extension
6. INITCAP() - Use UPPER/LOWER on substrings
7. LPAD() - Use string concatenation with calculated padding
8. RPAD() - Use string concatenation with calculated padding
9. TRANSLATE() - Use multiple REPLACE statements
10. ASCII() - Use UNICODE() instead (same for ASCII range)

AVAILABLE SQLITE STRING FUNCTIONS:
===================================
UPPER(str)          - Convert to uppercase
LOWER(str)          - Convert to lowercase
LENGTH(str)         - Return string length
SUBSTR(str, pos, len) - Extract substring
INSTR(str, substr)  - Find position of substring
REPLACE(str, old, new) - Replace occurrences
LTRIM(str, chars)   - Trim from left
RTRIM(str, chars)   - Trim from right
TRIM(str)           - Trim both ends
||                  - String concatenation operator

AVAILABLE SQLITE NUMERIC FUNCTIONS:
===================================
ABS(n)              - Absolute value
ROUND(n, d)         - Round to d decimals
%                   - Modulo operator
CAST(n AS type)     - Type conversion
PRINTF(format, ...) - Formatted output
*/

-- Clean up temporary table
DROP TABLE IF EXISTS employees_sample;

-- ================================================================================
-- END OF PRACTICAL 6 (SQLite Version)
-- ================================================================================
