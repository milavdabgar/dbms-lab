# Practical No. 6: SQL Numeric and Character Functions

This directory contains solutions for Practical No. 6 - Implementing SQL queries using Numeric and Character functions.

## Objective

To implement SQL queries using:

1. **Numeric functions**: ABS, CEIL, POWER, MOD, ROUND, TRUNC, SQRT, EXP, FLOOR
2. **Character functions**: INITCAP, LOWER, UPPER, LTRIM, RTRIM, REPLACE, SUBSTR, INSTR, LENGTH, LPAD, RPAD, ASCII, TRANSLATE

## Files

### Oracle Database Version

- **`pr6.sql`** - Complete SQL queries for Oracle Database
  - Full implementation of all numeric functions
  - Full implementation of all character functions
  - Uses HR.EMPLOYEES schema for demonstrations
  - Requires Oracle SQL*Plus, SQL Developer, or Oracle Live SQL

### SQLite Database Version

- **`pr6_sqlite.sql`** - SQLite-compatible queries
  - SQLite equivalents and workarounds for missing functions
  - Creates sample employee data for testing
  - Works with any SQLite database
  - Includes notes on function limitations

## Required Practical Queries

### Numeric Functions (11 Queries)

1. Find the absolute value of -15
2. Find the square root of 81
3. Find the value for 3 raised to power 4
4. Find the remainder for 16 divided by 5
5. Find the largest integer >= -27.2 (CEIL)
6. Find the smallest integer <= -24.2 (FLOOR)
7. Round 182.284 to -2 decimal places
8. Round 182.284 to 1 decimal place
9. Truncate 182.284 to -2 decimal places
10. Truncate 182.284 to 1 decimal place
11. Find e raised to power 4

### Character Functions (16 Queries)

1. Count characters in 'Computer Engineering'
2. Count characters in each employee's name
3. Convert 'COMPUTER' to lowercase
4. Display employee first names in lowercase
5. Display employee last names in uppercase
6. Convert 'oracle10g' to uppercase
7. Capitalize first letter of 'character function'
8. Extract 11 characters from 'Computer Engineering' starting at position 12
9. Extract first 3 characters from employee first names
10. Right-justify employee last names with '#' padding (length 20)
11. Left-justify employee last names with '*' padding (length 15)
12. Remove 'gbrsea' from left of 'greatest'
13. Translate 'ornt' to 'xynt' in 'government'
14. Replace 'govern' with 'suppli' in 'government'
15. Display ASCII values of 's', 'A', and 'a'
16. Find first occurrence of 'base' in 'Database'

## How to Run

### Option 1: Oracle Database (As per Lab Manual)

#### Prerequisites

- Oracle Database (11g, 12c, 18c, 19c, or 21c)
- Oracle SQL*Plus or SQL Developer
- HR schema (typically installed by default)

#### Using SQL*Plus

```bash
# Connect to Oracle
sqlplus username/password@database

# Run the complete script
SQL> @pr6.sql

# Or run sections individually
SQL> -- Numeric functions
SQL> SELECT ABS(-15) FROM DUAL;
```

#### Using SQL Developer

1. Open Oracle SQL Developer
2. Connect to your database
3. Open `pr6.sql` file
4. Run entire script (F5) or individual queries (Ctrl+Enter)

#### Verify HR Schema

```sql
-- Check if HR schema exists
SELECT * FROM HR.EMPLOYEES WHERE ROWNUM <= 5;

-- If HR schema is locked, unlock it (as SYSTEM user)
ALTER USER HR IDENTIFIED BY hr ACCOUNT UNLOCK;
```

### Option 2: SQLite (Compatible Version)

#### Prerequisites

- SQLite3 installed

#### Using SQLite Command Line

```bash
# Start SQLite
sqlite3

# Run the script
sqlite> .read pr6_sqlite.sql

# Or create a database file first
sqlite3 pr6.db < pr6_sqlite.sql
```

#### Note on SQLite Limitations

SQLite doesn't have all Oracle functions. The script provides:

- **Workarounds** for missing functions (CEIL, FLOOR, LPAD, RPAD)
- **Sample data** for employee queries
- **Notes** on functions requiring extensions (SQRT, EXP, POWER)

#### SQLite Math Extensions

For full numeric function support, load the math extension:

```bash
# If you have the math extension compiled
sqlite> .load ./math
sqlite> SELECT SQRT(81);
```

## Key Differences Between Oracle and SQLite

### Available in Both

```sql
-- These work in both Oracle and SQLite
ABS(n)              ✓
ROUND(n, d)         ✓
UPPER(str)          ✓
LOWER(str)          ✓
LENGTH(str)         ✓
SUBSTR(str, pos, len) ✓
REPLACE(str, old, new) ✓
LTRIM(str)          ✓
RTRIM(str)          ✓
INSTR(str, substr)  ✓
```

### Oracle Only

```sql
-- These require workarounds in SQLite
CEIL(n)             Oracle: Built-in | SQLite: Use CASE + CAST
FLOOR(n)            Oracle: Built-in | SQLite: Use CAST with logic
POWER(m, n)         Oracle: Built-in | SQLite: Need extension or multiply
SQRT(n)             Oracle: Built-in | SQLite: Need math extension
EXP(n)              Oracle: Built-in | SQLite: Need math extension
TRUNC(n, d)         Oracle: Built-in | SQLite: Use CAST + arithmetic
INITCAP(str)        Oracle: Built-in | SQLite: Use UPPER/LOWER on parts
LPAD(str, n, pad)   Oracle: Built-in | SQLite: String concatenation
RPAD(str, n, pad)   Oracle: Built-in | SQLite: String concatenation
TRANSLATE(str, f, t) Oracle: Built-in | SQLite: Multiple REPLACE
ASCII(chr)          Oracle: Built-in | SQLite: Use UNICODE()
```

### SQLite Workarounds Example

```sql
-- Oracle CEIL
SELECT CEIL(25.4) FROM DUAL;

-- SQLite CEIL equivalent
SELECT 
    CASE WHEN 25.4 = CAST(25.4 AS INTEGER) 
         THEN CAST(25.4 AS INTEGER)
         ELSE CAST(25.4 AS INTEGER) + 1 
    END;

-- Oracle LPAD
SELECT LPAD('hello', 10, '#') FROM DUAL;

-- SQLite LPAD equivalent  
SELECT SUBSTR('##########', 1, 10 - LENGTH('hello')) || 'hello';
```

## Theory Reference

### Numeric Functions

**ABS(n)** - Returns absolute value

```sql
ABS(-15) → 15
ABS(15) → 15
```

**CEIL(n)** - Smallest integer ≥ n

```sql
CEIL(27.1) → 28
CEIL(-27.1) → -27
```

**FLOOR(n)** - Largest integer ≤ n

```sql
FLOOR(27.9) → 27
FLOOR(-27.1) → -28
```

**ROUND(n, d)** - Round to d decimal places

```sql
ROUND(182.284, 1) → 182.3
ROUND(182.284, -2) → 200
```

**TRUNC(n, d)** - Truncate to d decimal places

```sql
TRUNC(182.284, 1) → 182.2
TRUNC(182.284, -2) → 100
```

**MOD(m, n)** - Remainder of m/n

```sql
MOD(16, 5) → 1
```

**POWER(m, n)** - m raised to power n

```sql
POWER(3, 4) → 81
```

**SQRT(n)** - Square root

```sql
SQRT(81) → 9
```

**EXP(n)** - e^n (e ≈ 2.71828)

```sql
EXP(1) → 2.71828
EXP(4) → 54.5982
```

### Character Functions

**UPPER(str)** / **LOWER(str)** - Change case

```sql
UPPER('hello') → 'HELLO'
LOWER('HELLO') → 'hello'
```

**INITCAP(str)** - Capitalize first letter of each word

```sql
INITCAP('hello world') → 'Hello World'
```

**LENGTH(str)** - String length

```sql
LENGTH('Computer') → 8
```

**SUBSTR(str, pos, len)** - Extract substring

```sql
SUBSTR('Computer', 1, 4) → 'Comp'
SUBSTR('Computer', 5) → 'uter'
```

**INSTR(str, substr)** - Find position

```sql
INSTR('Database', 'base') → 5
```

**REPLACE(str, old, new)** - Replace all occurrences

```sql
REPLACE('Hello World', 'World', 'SQLite') → 'Hello SQLite'
```

**LTRIM(str, chars)** / **RTRIM(str, chars)** - Trim characters

```sql
LTRIM('000123', '0') → '123'
RTRIM('Tech123', '123') → 'Tech'
```

**LPAD(str, n, pad)** / **RPAD(str, n, pad)** - Pad string

```sql
LPAD('hello', 10, '#') → '#####hello'
RPAD('hello', 10, '*') → 'hello*****'
```

**ASCII(chr)** - ASCII code

```sql
ASCII('A') → 65
ASCII('a') → 97
```

**TRANSLATE(str, from, to)** - Character-by-character replacement

```sql
TRANSLATE('COMPUTER', 'COMPU', 'HEA') → 'HEATER'
```

## Sample Data

For character function queries on employee data, the Oracle version uses HR.EMPLOYEES table. The SQLite version creates a temporary table:

```sql
CREATE TEMP TABLE employees_sample (
    employee_id INTEGER PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    email TEXT,
    phone_number TEXT,
    salary REAL
);

-- Sample data includes: Steven King, Neena Kochhar, etc.
```

## Common Use Cases

### Data Cleaning

```sql
-- Remove leading/trailing spaces
SELECT TRIM(first_name) FROM employees;

-- Standardize case
SELECT UPPER(email) FROM employees;

-- Extract domain from email
SELECT SUBSTR(email, INSTR(email, '@') + 1) FROM employees;
```

### Data Formatting

```sql
-- Format salary
SELECT ROUND(salary, 2) FROM employees;

-- Pad employee codes
SELECT LPAD(employee_id, 10, '0') FROM employees;

-- Create full name
SELECT first_name || ' ' || last_name FROM employees;
```

### Data Validation

```sql
-- Check string length
SELECT * FROM employees WHERE LENGTH(phone_number) = 12;

-- Find records with specific characters
SELECT * FROM employees WHERE INSTR(email, '@') > 0;
```

## Tips

### For Oracle

- Always use `FROM DUAL` for queries without tables
- HR schema is pre-installed but may be locked
- Test complex functions with simple examples first
- Use `DESCRIBE HR.EMPLOYEES` to see table structure

### For SQLite

- No `FROM DUAL` needed - just `SELECT expression;`
- Create sample data for testing employee queries
- Some functions require math extensions
- Use `||` for string concatenation
- `%` operator for modulo instead of MOD()

## Assessment Criteria

According to lab manual:

- Correct query execution: 18-20 marks (Excellent)
- Execution with guidance: 13-17 marks (Good)
- Incorrect output: 7-12 marks (Satisfactory)
- Unable to execute: 0-6 marks (Fair)

## Expected Outcomes

After completing this practical, you should be able to:

1. Use numeric functions for calculations
2. Manipulate strings using character functions
3. Format data for display
4. Extract specific parts of strings
5. Perform case conversions
6. Pad and trim strings
7. Find and replace text
8. Work with ASCII codes

## Common Errors and Solutions

### Oracle

**Error**: "table or view does not exist"

- **Solution**: Ensure HR schema is unlocked and accessible

**Error**: "invalid number"  

- **Solution**: Check data types in function arguments

### SQLite

**Warning**: "no such function: CEIL"

- **Solution**: Use the CASE-based workaround provided

**Warning**: "no such function: POWER"

- **Solution**: Use multiplication or load math extension

## Resources

- Oracle SQL Functions: https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/Functions.html
- SQLite Core Functions: https://www.sqlite.org/lang_corefunc.html
- SQLite Math Extension: https://www.sqlite.org/src/file/ext/misc/math.c
- W3Schools SQL Functions: https://www.w3schools.com/sql/sql_ref_sqlserver.asp
- GeeksforGeeks SQL: https://www.geeksforgeeks.org/sql-tutorial/

## Practice Quiz Answers

1. **Character functions can**: C. Accept character arguments and can return both character and number values
2. **SELECT lower(upper(initcap('Hello World')))**: D. hello world
3. **Use UPPER when**: B. The text values might be mixed-case
4. **Measure length**: B. LENGTH (in Oracle and SQLite)
5. **Replace string at position**: D. REPLACE

---

**Note:** This practical uses both system functions and table data (HR.EMPLOYEES in Oracle, sample data in SQLite). All queries include examples and explanations.
