-- ================================================================================
-- Practical No. 5: SQL Date Functions (SQLite Version)
-- ================================================================================
-- Implement SQL queries using Date functions
-- SQLite compatible version using SQLite's date/time functions
--
-- Course: Database Management System (DI04032011)
-- Semester: IV - ICT Engineering
-- ================================================================================

-- ================================================================================
-- SECTION 1: SQLite DATE FUNCTIONS - THEORY AND EXAMPLES
-- ================================================================================

-- SQLite Date/Time Functions:
-- date() - Returns date in 'YYYY-MM-DD' format
-- datetime() - Returns datetime in 'YYYY-MM-DD HH:MM:SS' format
-- julianday() - Returns Julian day number
-- strftime() - Format date/time

-- ----------------
-- 1. ADD_MONTHS Equivalent (Using date() with modifiers)
-- ----------------
-- SQLite uses date() function with '+N months' or '-N months' modifier

-- Example 1: Adding 3 months to current date
SELECT date('now', '+3 months') AS "Add 3 Months";

-- Example 2: Subtracting 3 months from current date
SELECT date('now', '-3 months') AS "Subtract 3 Months";

-- Example 3: Adding months to a specific date
SELECT date('2012-12-31', '+3 months') AS "Add 3 Months to 31-Dec-2012";

-- ----------------
-- 2. MONTHS_BETWEEN Equivalent
-- ----------------
-- Calculate difference in months between two dates
-- SQLite requires calculation using julianday

-- Example 1: Months between two dates (approximate)
SELECT 
    CAST((julianday('2013-03-31') - julianday('2012-12-31')) / 30.44 AS INTEGER) 
    AS "Months Between (Approx)";

-- Example 2: More precise months calculation
SELECT 
    (CAST(strftime('%Y', '2013-03-31') AS INTEGER) - 
     CAST(strftime('%Y', '2012-12-31') AS INTEGER)) * 12 +
    (CAST(strftime('%m', '2013-03-31') AS INTEGER) - 
     CAST(strftime('%m', '2012-12-31') AS INTEGER))
    AS "Months Between (Precise)";

-- ----------------
-- 3. LAST_DAY Equivalent
-- ----------------
-- Get the last day of the month
-- SQLite: Use date() with 'start of month' and '+1 month' and '-1 day'

-- Example 1: Last day of March 2013
SELECT date('2013-03-01', '+1 month', '-1 day') AS "Last Day of March";

-- Example 2: Last day of current month
SELECT date('now', 'start of month', '+1 month', '-1 day') AS "Last Day of Current Month";

-- Example 3: Last day of February (leap year - 2020)
SELECT date('2020-02-01', '+1 month', '-1 day') AS "Last Day Feb 2020 (29)";

-- Example 4: Last day of February (non-leap year - 2019)
SELECT date('2019-02-01', '+1 month', '-1 day') AS "Last Day Feb 2019 (28)";

-- ----------------
-- 4. NEXT_DAY Equivalent
-- ----------------
-- Find next occurrence of a specific weekday
-- SQLite: More complex - need to calculate using strftime('%w')
-- %w returns day of week (0=Sunday, 1=Monday, ..., 6=Saturday)

-- Example 1: Find next Sunday (weekday 0)
SELECT 
    date('now', 
         '+' || ((7 - CAST(strftime('%w', 'now') AS INTEGER)) % 7 + 
         CASE WHEN (7 - CAST(strftime('%w', 'now') AS INTEGER)) % 7 = 0 
              THEN 7 ELSE 0 END) || ' days') 
    AS "Next Sunday";

-- Example 2: Find next Monday (weekday 1) from a specific date
SELECT 
    date('2019-06-03', 
         '+' || ((1 - CAST(strftime('%w', '2019-06-03') AS INTEGER) + 7) % 7 + 
         CASE WHEN ((1 - CAST(strftime('%w', '2019-06-03') AS INTEGER) + 7) % 7) = 0 
              THEN 7 ELSE 0 END) || ' days') 
    AS "Next Monday after June 3, 2019";

-- ----------------
-- 5. ROUND Date
-- ----------------
-- Round to nearest day based on time
-- If time >= 12:00, round to next day; otherwise keep current day

-- Example 1: Round datetime 3:30:45 PM to nearest day (next day)
SELECT date('2012-12-31 15:30:45') AS "Original",
       CASE 
           WHEN CAST(strftime('%H', '2012-12-31 15:30:45') AS INTEGER) >= 12 
           THEN date('2012-12-31 15:30:45', '+1 day')
           ELSE date('2012-12-31 15:30:45')
       END AS "Rounded";

-- Example 2: Round datetime 3:30:45 AM to nearest day (same day)
SELECT date('2012-12-31 03:30:45') AS "Original",
       CASE 
           WHEN CAST(strftime('%H', '2012-12-31 03:30:45') AS INTEGER) >= 12 
           THEN date('2012-12-31 03:30:45', '+1 day')
           ELSE date('2012-12-31 03:30:45')
       END AS "Rounded";

-- ----------------
-- 6. TRUNC Date
-- ----------------
-- Truncate time portion from datetime (always returns date at 00:00:00)

-- Example 1: Truncate datetime
SELECT 
    datetime('2012-12-31 15:30:45') AS "Original DateTime",
    date('2012-12-31 15:30:45') AS "Truncated to Date";

-- Example 2: Truncate current datetime
SELECT 
    datetime('now') AS "Current DateTime",
    date('now') AS "Truncated to Date";

-- ================================================================================
-- SECTION 2: REQUIRED PRACTICAL QUERIES (SQLite Version)
-- ================================================================================

-- Query 1: Find a date after adding 4 months to '01-06-19'.
SELECT date('2019-06-01', '+4 months') AS "Date After 4 Months";

-- Query 2: Find a total months between '01-01-19' to '01-05-19'.
-- Method 1: Approximate (using days)
SELECT 
    CAST((julianday('2019-05-01') - julianday('2019-01-01')) / 30.44 AS INTEGER) 
    AS "Total Months (Approx)";

-- Method 2: Precise month calculation
SELECT 
    (CAST(strftime('%Y', '2019-05-01') AS INTEGER) - 
     CAST(strftime('%Y', '2019-01-01') AS INTEGER)) * 12 +
    (CAST(strftime('%m', '2019-05-01') AS INTEGER) - 
     CAST(strftime('%m', '2019-01-01') AS INTEGER))
    AS "Total Months (Precise)";

-- Query 3: Find a last date of '01-02-19'.
SELECT date('2019-02-01', '+1 month', '-1 day') AS "Last Date of February 2019";

-- Query 4: Find out date of next Tuesday after '18-06-19'.
-- Tuesday is weekday 2
SELECT 
    date('2019-06-18', 
         '+' || ((2 - CAST(strftime('%w', '2019-06-18') AS INTEGER) + 7) % 7 + 
         CASE WHEN ((2 - CAST(strftime('%w', '2019-06-18') AS INTEGER) + 7) % 7) = 0 
              THEN 7 ELSE 0 END) || ' days') 
    AS "Next Tuesday";

-- Query 5: Find the round format date for '17-06-19 12:35pm', '17-06-19 12:35am' and '17-06-19 01:30pm'.
SELECT 
    CASE 
        WHEN CAST(strftime('%H', '2019-06-17 12:35:00') AS INTEGER) >= 12 
        THEN date('2019-06-17 12:35:00', '+1 day')
        ELSE date('2019-06-17 12:35:00')
    END AS "Round 12:35 PM",
    CASE 
        WHEN CAST(strftime('%H', '2019-06-17 00:35:00') AS INTEGER) >= 12 
        THEN date('2019-06-17 00:35:00', '+1 day')
        ELSE date('2019-06-17 00:35:00')
    END AS "Round 12:35 AM",
    CASE 
        WHEN CAST(strftime('%H', '2019-06-17 13:30:00') AS INTEGER) >= 12 
        THEN date('2019-06-17 13:30:00', '+1 day')
        ELSE date('2019-06-17 13:30:00')
    END AS "Round 01:30 PM";

-- Query 6: Find the trunc format date for '17-06-19 12:35pm', '17-06-19 12:35am' and '17-06-19 01:30pm'.
SELECT 
    date('2019-06-17 12:35:00') AS "Trunc 12:35 PM",
    date('2019-06-17 00:35:00') AS "Trunc 12:35 AM",
    date('2019-06-17 13:30:00') AS "Trunc 01:30 PM";

-- Query 7: Find out the date of next Sunday after today.
-- Sunday is weekday 0
SELECT 
    date('now', 
         '+' || ((7 - CAST(strftime('%w', 'now') AS INTEGER)) % 7 + 
         CASE WHEN (7 - CAST(strftime('%w', 'now') AS INTEGER)) % 7 = 0 
              THEN 7 ELSE 0 END) || ' days') 
    AS "Next Sunday";

-- ================================================================================
-- SECTION 3: ADDITIONAL PRACTICE QUERIES (SQLite)
-- ================================================================================

-- Practice 1: Calculate age in months (approximate)
SELECT 
    CAST((julianday('now') - julianday('2000-01-01')) / 30.44 AS INTEGER) 
    AS "Age in Months (Approx)";

-- Practice 2: Find next 7 days with day names
WITH RECURSIVE dates(n, dt, day_name) AS (
    SELECT 1, date('now', '+1 day'), strftime('%w', date('now', '+1 day'))
    UNION ALL
    SELECT n+1, date('now', '+' || (n+1) || ' days'), 
           strftime('%w', date('now', '+' || (n+1) || ' days'))
    FROM dates
    WHERE n < 7
)
SELECT dt AS "Date", 
       CASE day_name
           WHEN '0' THEN 'Sunday'
           WHEN '1' THEN 'Monday'
           WHEN '2' THEN 'Tuesday'
           WHEN '3' THEN 'Wednesday'
           WHEN '4' THEN 'Thursday'
           WHEN '5' THEN 'Friday'
           WHEN '6' THEN 'Saturday'
       END AS "Day Name"
FROM dates;

-- Practice 3: Find number of days remaining in current month
SELECT 
    julianday(date('now', 'start of month', '+1 month', '-1 day')) - 
    julianday(date('now')) AS "Days Remaining in Month";

-- Practice 4: Find the first day of current month
SELECT date('now', 'start of month') AS "First Day of Month";

-- Practice 5: Find the last day of previous month
SELECT date('now', 'start of month', '-1 day') AS "Last Day of Previous Month";

-- Practice 6: Find the first day of current year
SELECT date('now', 'start of year') AS "First Day of Year";

-- Practice 7: Find date 90 days from now
SELECT date('now', '+90 days') AS "Date 90 Days From Now";

-- Practice 8: Calculate difference in days between two dates
SELECT 
    julianday('2019-12-31') - julianday('2019-01-01') AS "Days in 2019";

-- Practice 9: Get current date and time in various formats
SELECT 
    date('now') AS "Current Date (YYYY-MM-DD)",
    datetime('now') AS "Current DateTime",
    datetime('now', 'localtime') AS "Local DateTime",
    strftime('%d-%m-%Y', 'now') AS "Format DD-MM-YYYY",
    strftime('%d/%m/%Y', 'now') AS "Format DD/MM/YYYY",
    strftime('%Y-%m-%d %H:%M:%S', 'now', 'localtime') AS "Complete Format",
    strftime('%H:%M:%S', 'now', 'localtime') AS "Time Only",
    strftime('%w', 'now') AS "Weekday Number (0-6)";

-- Practice 10: Find all dates in current month
WITH RECURSIVE all_dates(dt) AS (
    SELECT date('now', 'start of month')
    UNION ALL
    SELECT date(dt, '+1 day')
    FROM all_dates
    WHERE dt < date('now', 'start of month', '+1 month', '-1 day')
)
SELECT dt AS "Date",
       strftime('%w', dt) AS "Weekday",
       CASE strftime('%w', dt)
           WHEN '0' THEN 'Sunday'
           WHEN '1' THEN 'Monday'
           WHEN '2' THEN 'Tuesday'
           WHEN '3' THEN 'Wednesday'
           WHEN '4' THEN 'Thursday'
           WHEN '5' THEN 'Friday'
           WHEN '6' THEN 'Saturday'
       END AS "Day Name"
FROM all_dates;

-- ================================================================================
-- SECTION 4: SQLite DATE FUNCTIONS REFERENCE
-- ================================================================================

-- Common SQLite Date/Time Modifiers:
-- '+N days' / '-N days'
-- '+N months' / '-N months'
-- '+N years' / '-N years'
-- 'start of month' - First day of the month
-- 'start of year' - First day of the year
-- 'start of day' - Midnight (00:00:00)
-- 'weekday N' - Next occurrence of weekday N (0=Sunday, 6=Saturday)
-- 'localtime' - Convert UTC to local time

-- Common strftime() format specifiers:
-- %Y - 4-digit year (2019)
-- %m - Month (01-12)
-- %d - Day of month (01-31)
-- %H - Hour (00-23)
-- %M - Minute (00-59)
-- %S - Second (00-59)
-- %w - Weekday (0-6, 0=Sunday)
-- %j - Day of year (001-366)
-- %W - Week of year (00-53)

-- ================================================================================
-- END OF PRACTICAL 5 (SQLite Version)
-- ================================================================================
