-- ================================================================================
-- Practical No. 5: SQL Date Functions
-- ================================================================================
-- Implement SQL queries using Date functions like:
-- ADD_MONTHS, MONTHS_BETWEEN, LAST_DAY, NEXT_DAY, ROUND, and TRUNC
--
-- Course: Database Management System (DI04032011)
-- Semester: IV - ICT Engineering
-- ================================================================================

-- ================================================================================
-- SECTION 1: THEORY AND EXAMPLES
-- ================================================================================
-- NOTE: Consider '31-DEC-2012' as SYSDATE for theoretical examples

-- ----------------
-- 1. ADD_MONTHS
-- ----------------
-- ADD_MONTHS function returns new date after adding the number of months
-- specified in the function.
-- Syntax: ADD_MONTHS(date, number_of_months)

-- Example 1: Adding 3 months to current date
SELECT ADD_MONTHS(SYSDATE, 3) AS "Add 3 Months" FROM DUAL;

-- Example 2: Subtracting months (using negative value)
SELECT ADD_MONTHS(SYSDATE, -3) AS "Subtract 3 Months" FROM DUAL;

-- Example 3: Adding months to a specific date
SELECT ADD_MONTHS(TO_DATE('31-DEC-12', 'DD-MON-YY'), 3) AS "31-MAR-13" FROM DUAL;

-- ----------------
-- 2. MONTHS_BETWEEN
-- ----------------
-- MONTHS_BETWEEN function returns number of months between date1 and date2.
-- Syntax: MONTHS_BETWEEN(date1, date2)

-- Example 1: Find months between two dates
SELECT MONTHS_BETWEEN(TO_DATE('31-MAR-13', 'DD-MON-YY'), 
                      TO_DATE('31-DEC-12', 'DD-MON-YY')) AS "Months Between" 
FROM DUAL;

-- Example 2: Months between dates (partial months shown as decimals)
SELECT MONTHS_BETWEEN(TO_DATE('15-MAR-13', 'DD-MON-YY'), 
                      TO_DATE('31-DEC-12', 'DD-MON-YY')) AS "Months (Decimal)" 
FROM DUAL;

-- ----------------
-- 3. LAST_DAY
-- ----------------
-- LAST_DAY function returns the last date of the month specified.
-- Syntax: LAST_DAY(date)

-- Example 1: Find last day of March 2013
SELECT LAST_DAY(TO_DATE('1-MAR-13', 'DD-MON-YY')) AS "Last Day of March" FROM DUAL;

-- Example 2: Find last day of current month
SELECT LAST_DAY(SYSDATE) AS "Last Day of Current Month" FROM DUAL;

-- Example 3: Find last day of February (leap year check)
SELECT LAST_DAY(TO_DATE('15-FEB-20', 'DD-MON-YY')) AS "Last Day Feb 2020" FROM DUAL;

-- ----------------
-- 4. NEXT_DAY
-- ----------------
-- NEXT_DAY function returns the date of the next named weekday.
-- Syntax: NEXT_DAY(date, 'day_name')

-- Example 1: Find next Sunday after a specific date
SELECT NEXT_DAY(TO_DATE('3-JUN-19', 'DD-MON-YY'), 'SUNDAY') AS "Next Sunday" FROM DUAL;

-- Example 2: Find next Monday from today
SELECT NEXT_DAY(SYSDATE, 'MONDAY') AS "Next Monday" FROM DUAL;

-- ----------------
-- 5. ROUND
-- ----------------
-- ROUND function returns the rounded date according to format.
-- If format is omitted, date is rounded to the next day if time is 12:00 PM or later,
-- otherwise returns today's date (at 12:00 AM).
-- Syntax: ROUND(date, [format])

-- Example 1: Round date with time 3:30:45 PM (rounds to next day)
SELECT ROUND(TO_DATE('31-DEC-12 03:30:45 PM', 'DD-MON-YY HH:MI:SS PM')) AS "Rounded Date" 
FROM DUAL;

-- Example 2: Round date with time 12:00:00 PM (rounds to next day)
SELECT ROUND(TO_DATE('31-DEC-12 12:00:00 PM', 'DD-MON-YY HH:MI:SS PM')) AS "Rounded Date" 
FROM DUAL;

-- Example 3: Round date with time 3:30:45 AM (remains same day)
SELECT ROUND(TO_DATE('31-DEC-12 03:30:45 AM', 'DD-MON-YY HH:MI:SS PM')) AS "Rounded Date" 
FROM DUAL;

-- ----------------
-- 6. TRUNC
-- ----------------
-- TRUNC function returns the truncated date according to format.
-- If format is omitted, date is truncated to 12:00 AM (removes time portion).
-- Syntax: TRUNC(date, [format])

-- Example 1: Truncate date with time 3:30:45 PM
SELECT TRUNC(TO_DATE('31-DEC-12 03:30:45 PM', 'DD-MON-YY HH:MI:SS PM')) AS "Truncated Date" 
FROM DUAL;

-- Example 2: Truncate date with time 12:00:00 PM
SELECT TRUNC(TO_DATE('31-DEC-12 12:00:00 PM', 'DD-MON-YY HH:MI:SS PM')) AS "Truncated Date" 
FROM DUAL;

-- Example 3: Truncate current date and time
SELECT TRUNC(SYSDATE) AS "Truncated Today" FROM DUAL;

-- ================================================================================
-- SECTION 2: REQUIRED PRACTICAL QUERIES
-- ================================================================================

-- Query 1: Find a date after adding 4 months to '01-06-19'.
SELECT ADD_MONTHS(TO_DATE('01-06-19', 'DD-MM-YY'), 4) AS "Date After 4 Months" 
FROM DUAL;

-- Query 2: Find a total months between '01-01-19' to '01-05-19'.
SELECT MONTHS_BETWEEN(TO_DATE('01-05-19', 'DD-MM-YY'), 
                      TO_DATE('01-01-19', 'DD-MM-YY')) AS "Total Months" 
FROM DUAL;

-- Query 3: Find a last date of '01-02-19'.
SELECT LAST_DAY(TO_DATE('01-02-19', 'DD-MM-YY')) AS "Last Date of February" 
FROM DUAL;

-- Query 4: Find out date of next Tuesday after '18-06-19'.
SELECT NEXT_DAY(TO_DATE('18-06-19', 'DD-MM-YY'), 'TUESDAY') AS "Next Tuesday" 
FROM DUAL;

-- Query 5: Find the round format date for '17-06-19 12:35pm', '17-06-19 12:35am' and '17-06-19 01:30pm'.
SELECT 
    ROUND(TO_DATE('17-06-19 12:35 PM', 'DD-MM-YY HH:MI PM')) AS "Round 12:35 PM",
    ROUND(TO_DATE('17-06-19 12:35 AM', 'DD-MM-YY HH:MI AM')) AS "Round 12:35 AM",
    ROUND(TO_DATE('17-06-19 01:30 PM', 'DD-MM-YY HH:MI PM')) AS "Round 01:30 PM"
FROM DUAL;

-- Query 6: Find the trunc format date for '17-06-19 12:35pm', '17-06-19 12:35am' and '17-06-19 01:30pm'.
SELECT 
    TRUNC(TO_DATE('17-06-19 12:35 PM', 'DD-MM-YY HH:MI PM')) AS "Trunc 12:35 PM",
    TRUNC(TO_DATE('17-06-19 12:35 AM', 'DD-MM-YY HH:MI AM')) AS "Trunc 12:35 AM",
    TRUNC(TO_DATE('17-06-19 01:30 PM', 'DD-MM-YY HH:MI PM')) AS "Trunc 01:30 PM"
FROM DUAL;

-- Query 7: Find out the date of next Sunday after today.
SELECT NEXT_DAY(SYSDATE, 'SUNDAY') AS "Next Sunday" FROM DUAL;

-- ================================================================================
-- SECTION 3: ADDITIONAL PRACTICE QUERIES
-- ================================================================================

-- Practice 1: Calculate age in months
SELECT MONTHS_BETWEEN(SYSDATE, TO_DATE('01-JAN-2000', 'DD-MON-YYYY')) AS "Age in Months" 
FROM DUAL;

-- Practice 2: Find all days of the week for next 7 days
SELECT SYSDATE + LEVEL AS "Date", 
       TO_CHAR(SYSDATE + LEVEL, 'DAY') AS "Day Name"
FROM DUAL
CONNECT BY LEVEL <= 7;

-- Practice 3: Find number of days remaining in current month
SELECT LAST_DAY(SYSDATE) - SYSDATE AS "Days Remaining in Month" FROM DUAL;

-- Practice 4: Find the first day of current month
SELECT TRUNC(SYSDATE, 'MONTH') AS "First Day of Month" FROM DUAL;

-- Practice 5: Find the last day of previous month
SELECT LAST_DAY(ADD_MONTHS(SYSDATE, -1)) AS "Last Day of Previous Month" FROM DUAL;

-- Practice 6: Round date to the nearest month
SELECT ROUND(SYSDATE, 'MONTH') AS "Rounded to Month" FROM DUAL;

-- Practice 7: Truncate date to the start of the year
SELECT TRUNC(SYSDATE, 'YEAR') AS "First Day of Year" FROM DUAL;

-- Practice 8: Find all Fridays in current month
SELECT TRUNC(SYSDATE, 'MONTH') + (LEVEL - 1) AS "Date"
FROM DUAL
WHERE TO_CHAR(TRUNC(SYSDATE, 'MONTH') + (LEVEL - 1), 'DAY') LIKE 'FRIDAY%'
CONNECT BY LEVEL <= 31
AND TRUNC(SYSDATE, 'MONTH') + (LEVEL - 1) <= LAST_DAY(SYSDATE);

-- Practice 9: Calculate quarter of the year
SELECT TO_CHAR(SYSDATE, 'Q') AS "Current Quarter" FROM DUAL;

-- Practice 10: Find date 90 days from now
SELECT SYSDATE + 90 AS "Date 90 Days From Now" FROM DUAL;

-- ================================================================================
-- SECTION 4: COMMON DATE FORMAT MODELS
-- ================================================================================
-- Display current date in various formats
SELECT 
    TO_CHAR(SYSDATE, 'DD-MON-YYYY') AS "Format 1",
    TO_CHAR(SYSDATE, 'DD/MM/YYYY') AS "Format 2",
    TO_CHAR(SYSDATE, 'Month DD, YYYY') AS "Format 3",
    TO_CHAR(SYSDATE, 'DAY, DD-MON-YYYY') AS "Format 4",
    TO_CHAR(SYSDATE, 'HH24:MI:SS') AS "Time Format",
    TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS') AS "Complete Format"
FROM DUAL;

-- ================================================================================
-- END OF PRACTICAL 5
-- ================================================================================
