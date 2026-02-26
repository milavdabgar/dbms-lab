-- ================================================================================
-- Practical No. 6: SQL Numeric and Character Functions (Oracle)
-- ================================================================================
-- Implement SQL queries using:
-- 1. Numeric functions: ABS, CEIL, POWER, MOD, ROUND, TRUNC, SQRT, EXP, FLOOR
-- 2. Character functions: INITCAP, LOWER, UPPER, LTRIM, RTRIM, REPLACE, 
--    SUBSTR, INSTR, LENGTH, LPAD, RPAD, ASCII, TRANSLATE
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
-- Returns the absolute (positive) value of a number
SELECT ABS(3) AS "ABS(3)", ABS(-3) AS "ABS(-3)" FROM DUAL;

-- ----------------
-- 2. CEIL() - Ceiling
-- ----------------
-- Returns the smallest integer greater than or equal to the number
SELECT CEIL(-25.4) AS "CEIL1", CEIL(25.4) AS "CEIL2" FROM DUAL;

-- ----------------
-- 3. FLOOR() - Floor
-- ----------------
-- Returns the largest integer less than or equal to the number
SELECT FLOOR(25.4) AS "FLOOR1", FLOOR(-25.4) AS "FLOOR2" FROM DUAL;

-- ----------------
-- 4. POWER() - Exponentiation
-- ----------------
-- Returns value raised to the power of exponent
SELECT POWER(3, 2) AS "3^2", POWER(2, 3) AS "2^3" FROM DUAL;

-- ----------------
-- 5. MOD() - Modulo/Remainder
-- ----------------
-- Returns remainder of division
SELECT MOD(9, 2) AS "9 MOD 2", MOD(10, 3) AS "10 MOD 3" FROM DUAL;

-- ----------------
-- 6. ROUND() - Round Number
-- ----------------
-- Rounds number to specified decimal places
SELECT 
    ROUND(255.555, 1) AS "Round to 1",
    ROUND(255.555, 2) AS "Round to 2",
    ROUND(255.555, -2) AS "Round to -2"
FROM DUAL;

-- ----------------
-- 7. TRUNC() - Truncate Number
-- ----------------
-- Truncates number to specified decimal places
SELECT 
    TRUNC(255.555, 1) AS "Trunc to 1",
    TRUNC(255.555, 2) AS "Trunc to 2",
    TRUNC(255.555, -2) AS "Trunc to -2"
FROM DUAL;

-- ----------------
-- 8. SQRT() - Square Root
-- ----------------
-- Returns square root of a number
SELECT SQRT(9) AS "SQRT(9)", SQRT(81) AS "SQRT(81)" FROM DUAL;

-- ----------------
-- 9. EXP() - Exponential
-- ----------------
-- Returns e raised to the nth power (e = 2.71828183)
SELECT EXP(1) AS "e^1", EXP(2) AS "e^2" FROM DUAL;

-- ================================================================================
-- SECTION 2: REQUIRED NUMERIC FUNCTION QUERIES
-- ================================================================================

-- Query 1: Find the absolute value of -15.
SELECT ABS(-15) AS "Absolute Value of -15" FROM DUAL;

-- Query 2: Find the square root of 81.
SELECT SQRT(81) AS "Square Root of 81" FROM DUAL;

-- Query 3: Find the value for 3 raised to power 4.
SELECT POWER(3, 4) AS "3 Raised to Power 4" FROM DUAL;

-- Query 4: Find the remainder for 16 divided by 5.
SELECT MOD(16, 5) AS "Remainder of 16 divided by 5" FROM DUAL;

-- Query 5: Find the largest integer value which is greater than or equal to -27.2.
SELECT CEIL(-27.2) AS "Ceiling of -27.2" FROM DUAL;

-- Query 6: Find the smallest integer value which is less than or equal to -24.2.
SELECT FLOOR(-24.2) AS "Floor of -24.2" FROM DUAL;

-- Query 7: Find the value for 182.284 which is rounded to -2.
SELECT ROUND(182.284, -2) AS "182.284 Rounded to -2" FROM DUAL;

-- Query 8: Find the value for 182.284 which is rounded to 1.
SELECT ROUND(182.284, 1) AS "182.284 Rounded to 1" FROM DUAL;

-- Query 9: Find the value for 182.284 which is truncated to -2.
SELECT TRUNC(182.284, -2) AS "182.284 Truncated to -2" FROM DUAL;

-- Query 10: Find the value for 182.284 which is truncated to 1.
SELECT TRUNC(182.284, 1) AS "182.284 Truncated to 1" FROM DUAL;

-- Query 11: Find the value for e which is raised to power 4.
SELECT EXP(4) AS "e Raised to Power 4" FROM DUAL;

-- ================================================================================
-- SECTION 3: CHARACTER FUNCTIONS - THEORY AND EXAMPLES
-- ================================================================================

-- ----------------
-- 1. INITCAP() - Initial Capital
-- ----------------
-- Capitalizes first letter of each word
SELECT INITCAP('database management system') AS "InitCap" FROM DUAL;

-- ----------------
-- 2. LOWER() - Lowercase
-- ----------------
-- Converts string to lowercase
SELECT LOWER('DATABASE') AS "Lower" FROM DUAL;

-- ----------------
-- 3. UPPER() - Uppercase
-- ----------------
-- Converts string to uppercase
SELECT UPPER('database') AS "Upper" FROM DUAL;

-- ----------------
-- 4. LENGTH() - String Length
-- ----------------
-- Returns number of characters in string
SELECT LENGTH('DATABASE') AS "Length" FROM DUAL;

-- ----------------
-- 5. SUBSTR() - Substring
-- ----------------
-- Extracts substring from string
SELECT 
    SUBSTR('COMPUTER', 1, 4) AS "First 4",
    SUBSTR('COMPUTER', 4, 5) AS "From 4th"
FROM DUAL;

-- ----------------
-- 6. INSTR() - Find Position
-- ----------------
-- Returns position of substring in string
SELECT INSTR('JYPython', 'P') AS "Position of P" FROM DUAL;

-- ----------------
-- 7. LTRIM() - Left Trim
-- ----------------
-- Removes specified characters from left
SELECT 
    LTRIM('000123', '0') AS "LTrim1",
    LTRIM('123123Tech', '123') AS "LTrim2"
FROM DUAL;

-- ----------------
-- 8. RTRIM() - Right Trim
-- ----------------
-- Removes specified characters from right
SELECT 
    RTRIM('123000', '0') AS "RTrim1",
    RTRIM('Tech123123', '123') AS "RTrim2"
FROM DUAL;

-- ----------------
-- 9. LPAD() - Left Pad
-- ----------------
-- Pads string on left to specified length
SELECT LPAD('database', 15, '#') AS "LPad" FROM DUAL;

-- ----------------
-- 10. RPAD() - Right Pad
-- ----------------
-- Pads string on right to specified length
SELECT RPAD('database', 15, '*') AS "RPad" FROM DUAL;

-- ----------------
-- 11. REPLACE() - Replace String
-- ----------------
-- Replaces all occurrences of search string
SELECT 
    REPLACE('COMPUTER', 'UTE', 'ILE') AS "Replace1",
    REPLACE('COMPUTER', 'UT', 'IL') AS "Replace2"
FROM DUAL;

-- ----------------
-- 12. TRANSLATE() - Translate Characters
-- ----------------
-- Replaces characters one by one
SELECT TRANSLATE('COMPUTER', 'COMPU', 'HEA') AS "Translate" FROM DUAL;

-- ----------------
-- 13. ASCII() - ASCII Code
-- ----------------
-- Returns ASCII code of character
SELECT ASCII('d') AS "ascii(d)", ASCII('D') AS "ascii(D)" FROM DUAL;

-- ================================================================================
-- SECTION 4: REQUIRED CHARACTER FUNCTION QUERIES
-- ================================================================================

-- Query 1: Count number of characters in a string 'Computer Engineering'.
SELECT LENGTH('Computer Engineering') AS "Length" FROM DUAL;

-- Query 2: Count number of characters in each employee's name.
-- Note: This requires HR.EMPLOYEES table
SELECT 
    FIRST_NAME,
    LENGTH(FIRST_NAME) AS "First Name Length",
    LAST_NAME,
    LENGTH(LAST_NAME) AS "Last Name Length"
FROM HR.EMPLOYEES;

-- Query 3: Convert string 'COMPUTER' in lowercase.
SELECT LOWER('COMPUTER') AS "Lowercase" FROM DUAL;

-- Query 4: Display first name of all employees in lowercase.
SELECT 
    FIRST_NAME AS "Original",
    LOWER(FIRST_NAME) AS "Lowercase"
FROM HR.EMPLOYEES;

-- Query 5: Display last name of all employees in uppercase.
SELECT 
    LAST_NAME AS "Original",
    UPPER(LAST_NAME) AS "Uppercase"
FROM HR.EMPLOYEES;

-- Query 6: Convert string 'oracle10g' in uppercase.
SELECT UPPER('oracle10g') AS "Uppercase" FROM DUAL;

-- Query 7: Display first letter of each word in a string 'character function' in uppercase.
SELECT INITCAP('character function') AS "InitCap" FROM DUAL;

-- Query 8: Extract 11 characters from the string 'Computer Engineering', starting from 12th character.
SELECT SUBSTR('Computer Engineering', 12, 11) AS "Substring" FROM DUAL;

-- Query 9: Extract first 3 characters from employee's first name.
SELECT 
    FIRST_NAME AS "Original",
    SUBSTR(FIRST_NAME, 1, 3) AS "First 3 Chars"
FROM HR.EMPLOYEES;

-- Query 10: Display last name of all employees' right justified with total length of 20 characters, 
-- fill up the blank characters with '#'.
SELECT 
    LAST_NAME AS "Original",
    LPAD(LAST_NAME, 20, '#') AS "Right Justified"
FROM HR.EMPLOYEES;

-- Query 11: Display last name of all employees left justified with total length 15 characters, 
-- fill up the blank characters with '*'.
SELECT 
    LAST_NAME AS "Original",
    RPAD(LAST_NAME, 15, '*') AS "Left Justified"
FROM HR.EMPLOYEES;

-- Query 12: Remove characters 'gbrsea' from string 'greatest' from left side.
SELECT LTRIM('greatest', 'gbrsea') AS "Result" FROM DUAL;

-- Query 13: Change character 'ornt' by 'xynt' from the string 'government'.
SELECT TRANSLATE('government', 'ornt', 'xynt') AS "Result" FROM DUAL;

-- Query 14: Change the word 'govern' by 'suppli' in a string 'government'.
SELECT REPLACE('government', 'govern', 'suppli') AS "Result" FROM DUAL;

-- Query 15: Display ascii values of 's', 'A' and 'a'.
SELECT 
    ASCII('s') AS "ASCII(s)",
    ASCII('A') AS "ASCII(A)",
    ASCII('a') AS "ASCII(a)"
FROM DUAL;

-- Query 16: Find the first occurrence of 'base' in string 'Database'.
SELECT INSTR('Database', 'base') AS "Position of 'base'" FROM DUAL;

-- ================================================================================
-- SECTION 5: ADDITIONAL PRACTICE QUERIES
-- ================================================================================

-- Practice 1: Combine multiple numeric functions
SELECT 
    ABS(SQRT(POWER(-3, 2))) AS "Complex Calculation",
    ROUND(MOD(123, 10) / 2, 2) AS "Another Calculation"
FROM DUAL;

-- Practice 2: String manipulation on employee names
SELECT 
    FIRST_NAME || ' ' || LAST_NAME AS "Full Name",
    INITCAP(FIRST_NAME || ' ' || LAST_NAME) AS "Proper Case",
    UPPER(SUBSTR(FIRST_NAME, 1, 1)) || LOWER(SUBSTR(FIRST_NAME, 2)) AS "Custom Format"
FROM HR.EMPLOYEES
WHERE ROWNUM <= 5;

-- Practice 3: Numeric calculations on salary
SELECT 
    SALARY AS "Original Salary",
    ROUND(SALARY * 1.1, 2) AS "10% Increase",
    TRUNC(SALARY / 12, 2) AS "Monthly Salary",
    MOD(SALARY, 1000) AS "Remainder"
FROM HR.EMPLOYEES
WHERE ROWNUM <= 5;

-- Practice 4: Extract email username and domain
SELECT 
    EMAIL,
    SUBSTR(EMAIL, 1, INSTR(EMAIL, '@') - 1) AS "Username",
    LENGTH(EMAIL) - INSTR(EMAIL, '@') AS "Domain Length"
FROM HR.EMPLOYEES
WHERE EMAIL IS NOT NULL
AND ROWNUM <= 5;

-- Practice 5: Format phone numbers
SELECT 
    PHONE_NUMBER AS "Original",
    RPAD(SUBSTR(PHONE_NUMBER, 1, 3), 15, '*') AS "Masked"
FROM HR.EMPLOYEES
WHERE PHONE_NUMBER IS NOT NULL
AND ROWNUM <= 5;

-- Practice 6: Compare ROUND vs TRUNC
SELECT 
    182.284 AS "Original",
    ROUND(182.284, 0) AS "Round 0",
    TRUNC(182.284, 0) AS "Trunc 0",
    ROUND(182.284, 1) AS "Round 1",
    TRUNC(182.284, 1) AS "Trunc 1"
FROM DUAL;

-- Practice 7: CEIL vs FLOOR comparison
SELECT 
    CEIL(27.1) AS "CEIL(27.1)",
    FLOOR(27.1) AS "FLOOR(27.1)",
    CEIL(-27.1) AS "CEIL(-27.1)",
    FLOOR(-27.1) AS "FLOOR(-27.1)"
FROM DUAL;

-- Practice 8: Concatenate with padding
SELECT 
    RPAD(FIRST_NAME, 20, '.') || LPAD(TO_CHAR(SALARY), 10, ' ') AS "Name and Salary"
FROM HR.EMPLOYEES
WHERE ROWNUM <= 10;

-- Practice 9: Find employees with specific character in name
SELECT 
    FIRST_NAME,
    INSTR(UPPER(FIRST_NAME), 'A') AS "Position of A"
FROM HR.EMPLOYEES
WHERE INSTR(UPPER(FIRST_NAME), 'A') > 0
AND ROWNUM <= 10;

-- Practice 10: Multiple character transformations
SELECT 
    'hello world' AS "Original",
    INITCAP('hello world') AS "InitCap",
    UPPER('hello world') AS "Upper",
    LOWER('HELLO WORLD') AS "Lower",
    REPLACE(INITCAP('hello world'), ' ', '_') AS "With Underscore"
FROM DUAL;

-- ================================================================================
-- SECTION 6: FUNCTION REFERENCE SUMMARY
-- ================================================================================

/*
NUMERIC FUNCTIONS:
==================
ABS(n)              - Absolute value
CEIL(n)             - Smallest integer >= n
FLOOR(n)            - Largest integer <= n
ROUND(n, m)         - Round to m decimal places
TRUNC(n, m)         - Truncate to m decimal places
MOD(m, n)           - Remainder of m/n
POWER(m, n)         - m raised to power n
SQRT(n)             - Square root of n
EXP(n)              - e raised to power n

CHARACTER FUNCTIONS:
===================
UPPER(char)         - Convert to uppercase
LOWER(char)         - Convert to lowercase
INITCAP(char)       - Capitalize first letter of each word
LENGTH(char)        - Return length of string
SUBSTR(char, m, n)  - Extract n characters from position m
INSTR(char1, char2) - Find position of char2 in char1
LTRIM(char, set)    - Remove characters from left
RTRIM(char, set)    - Remove characters from right
LPAD(char, n, pad)  - Pad on left to length n
RPAD(char, n, pad)  - Pad on right to length n
REPLACE(char, old, new) - Replace all occurrences
TRANSLATE(char, from, to) - Translate character by character
ASCII(char)         - Return ASCII code
CHR(n)              - Return character for ASCII code n
CONCAT(char1, char2) - Concatenate strings (or use ||)
TRIM(char)          - Remove leading and trailing spaces
*/

-- ================================================================================
-- END OF PRACTICAL 6 (Oracle Version)
-- ================================================================================
