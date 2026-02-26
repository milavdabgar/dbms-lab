# Practical No. 5: SQL Date Functions

This directory contains solutions for Practical No. 5 - Implementing SQL queries using Date functions.

## Objective

To implement SQL queries using various date functions like ADD_MONTHS, MONTHS_BETWEEN, LAST_DAY, NEXT_DAY, ROUND, and TRUNC.

## Files

### Oracle Database Version

- **`pr5.sql`** - Complete SQL queries for Oracle Database
  - Uses Oracle-specific date functions
  - Requires Oracle SQL*Plus, SQL Developer, or Oracle Live SQL
  - Uses the `DUAL` table for demonstrations

### SQLite Database Version

- **`pr5_sqlite.sql`** - SQLite-compatible queries
  - Uses SQLite's date/time functions
  - Works with any SQLite database or online SQLite runners
  - No special tables required

## Required Practical Queries

Both versions implement the following 7 required queries:

1. Find a date after adding 4 months to '01-06-19'
2. Find total months between '01-01-19' to '01-05-19'
3. Find last date of '01-02-19'
4. Find date of next Tuesday after '18-06-19'
5. Find round format date for three different times
6. Find trunc format date for three different times
7. Find date of next Sunday after today

## How to Run

### Option 1: Oracle Database (As per Lab Manual)

#### Prerequisites

- Oracle Database (11g, 12c, 18c, 19c, or 21c)
- Oracle SQL*Plus or SQL Developer installed

#### Using SQL*Plus (Command Line)

```bash
# Connect to Oracle Database
sqlplus username/password@database

# Run the script
SQL> @pr5.sql

# Or run individual queries
SQL> SELECT ADD_MONTHS(TO_DATE('01-06-19', 'DD-MM-YY'), 4) FROM DUAL;
```

#### Using SQL Developer (GUI)

1. Open Oracle SQL Developer
2. Connect to your database
3. Open `pr5.sql` file
4. Click "Run Script" (F5) or execute queries individually (Ctrl+Enter)

#### Using Oracle Live SQL (Online - Free)

1. Go to: https://livesql.oracle.com/
2. Sign in with Oracle account (free)
3. Copy and paste queries from `pr5.sql`
4. Click "Run" to execute

### Option 2: SQLite (Compatible Version)

#### Prerequisites

- SQLite3 installed on your system

#### Using SQLite Command Line

```bash
# Start SQLite (no database needed for date functions)
sqlite3

# Run the script
sqlite> .read pr5_sqlite.sql

# Or run individual queries
sqlite> SELECT date('2019-06-01', '+4 months') AS "Date After 4 Months";
```

#### Using Online SQLite Runners

1. Go to any online SQLite runner:
   - https://sqliteonline.com/
   - https://www.db-fiddle.com/ (select SQLite)
   - https://onecompiler.com/sqlite
2. Copy queries from `pr5_sqlite.sql`
3. Run queries directly

#### Using DB Browser for SQLite (GUI)

1. Open DB Browser for SQLite
2. Click "Execute SQL" tab
3. Copy and paste queries from `pr5_sqlite.sql`
4. Click "Run" (F5) or execute individual queries

## Key Differences Between Oracle and SQLite

### Oracle Functions

```sql
-- Oracle uses specific date functions
ADD_MONTHS(date, n)
MONTHS_BETWEEN(date1, date2)
LAST_DAY(date)
NEXT_DAY(date, 'DAY')
ROUND(date)
TRUNC(date)
TO_DATE('01-06-19', 'DD-MM-YY')  -- Date conversion
DUAL table                        -- Dummy table for SELECT
```

### SQLite Equivalents

```sql
-- SQLite uses date() with modifiers
date('2019-06-01', '+4 months')   -- Add months
julianday() / 30.44               -- Calculate months between
date('2019-02-01', '+1 month', '-1 day')  -- Last day
date calculation with strftime()   -- Next day of week
CASE WHEN time >= 12 THEN +1 day  -- Round
date(datetime_value)              -- Trunc
No DUAL table needed              -- Direct SELECT
```

## Theory Reference

### Date Functions Covered

1. **ADD_MONTHS / date('+N months')**
   - Adds or subtracts months from a date
   - Negative values subtract months

2. **MONTHS_BETWEEN / julianday() calculation**
   - Returns number of months between two dates
   - Can be fractional in Oracle

3. **LAST_DAY / date('start of month', '+1 month', '-1 day')**
   - Returns the last day of a month
   - Handles leap years automatically

4. **NEXT_DAY / date with weekday calculation**
   - Returns the next occurrence of a specific weekday
   - Days: Sunday=0/SUNDAY through Saturday=6/SATURDAY

5. **ROUND / CASE statement with time check**
   - Rounds date to nearest day based on time
   - >= 12:00 PM rounds to next day

6. **TRUNC / date()**
   - Truncates time portion from datetime
   - Always returns date at 00:00:00

## Additional Practice

Both SQL files include additional practice queries covering:

- Age calculations
- Finding specific days of the week
- Date formatting
- Days remaining in month
- First/last day calculations
- Date arithmetic
- Recursive date generation (SQLite)

## Lab Manual Reference

- **Practical No. 5** (Pages as per lab manual)
- **Course Outcome:** CO3 - Manage and Implement database using SQL
- **Skills:** Date function queries, compilation, debugging, executing

## Tips

### For Oracle

- Always use `TO_DATE()` for date string conversion
- Specify format model in `TO_DATE()` to avoid errors
- Use `SYSDATE` for current date/time
- Test with `DUAL` table for quick calculations

### For SQLite

- SQLite stores dates as text, real, or integer
- Use ISO format (YYYY-MM-DD) for best compatibility
- `date('now')` gives current date
- `datetime('now', 'localtime')` for local timezone
- Use `strftime()` for custom date formatting

## Assessment Criteria

According to lab manual:

- Correct query execution: 18-20 marks (Excellent)
- Execution with guidance: 13-17 marks (Good)
- Incorrect output: 7-12 marks (Satisfactory)
- Unable to execute: 0-6 marks (Fair)

## Expected Outcomes

After completing this practical, you should be able to:

1. Use date functions to manipulate and calculate dates
2. Add or subtract time periods from dates
3. Calculate differences between dates
4. Find specific days of the week
5. Round and truncate date values
6. Format dates in different ways

## Resources

- Oracle Documentation: https://docs.oracle.com/en/database/
- SQLite Date Functions: https://www.sqlite.org/lang_datefunc.html
- W3Schools SQL: https://www.w3schools.com/sql/
- GeeksforGeeks DBMS: https://www.geeksforgeeks.org/dbms/

---

**Note:** This practical does not require creating tables or inserting data. All queries work directly using date functions and the system date.
