# Practical 7: Conversion Functions and Group Functions

Implementation of SQL Conversion Functions, Miscellaneous Functions (DECODE), and Group (Aggregate) Functions.

## 📁 Files Overview

- **pr7.sql** - Oracle version with TO_NUMBER, TO_CHAR, TO_DATE, DECODE
- **pr7_sqlite.sql** - SQLite version with CAST, strftime, printf, CASE

## 🎯 Practical Objectives

Implement SQL queries using:
1. **Conversion Functions** - Convert data between types (number, character, date)
2. **DECODE/CASE** - Conditional logic for IF-THEN-ELSE operations
3. **Group Functions** - Aggregate calculations (AVG, MIN, MAX, SUM, COUNT)

## 📋 Queries Covered

### Conversion Functions (5 queries)

1. **TO_NUMBER** - Convert string '+01234.78' to number
2. **TO_CHAR (Number)** - Format 123789 as '9,99,999'
3. **TO_CHAR (Date)** - Format hire date as 'Saturday, 14th Feb, 2009'
4. **TO_CHAR (Date)** - Format hire date as '23-March-1985'
5. **DECODE/CASE** - Conditional logic for MAX/MIN/EQUAL values

### Group Functions (6 queries)

6. **MAX** - Find maximum salary
7. **MIN** - Find minimum salary
8. **SUM** - Calculate sum of all and distinct salaries
9. **AVG** - Calculate average of all and distinct salaries
10. **COUNT(*)** - Count total employees
11. **COUNT(column)** - Count non-NULL values per column

## 🔧 Database Setup & Execution

### Oracle Database

```bash
# Connect to Oracle
sqlplus username/password@localhost:1521/XE

# Run queries
SQL> @pr7.sql
```

### SQLite Database

```bash
# Run all queries
sqlite3 conversions.db < pr7_sqlite.sql

# Or interactively
sqlite3 conversions.db
sqlite> .read pr7_sqlite.sql
```

## 🔍 Key Differences: Oracle vs SQLite

### Conversion Functions

| Oracle | SQLite | Notes |
|--------|--------|-------|
| `TO_NUMBER('+123.45')` | `CAST('+123.45' AS REAL)` | String to number |
| `TO_CHAR(12345, '99,999')` | `printf('%,d', 12345)` | Number formatting |
| `TO_CHAR(date, 'DD-MON-YY')` | `strftime('%d-%m-%Y', date)` | Date formatting |
| `TO_DATE('17-SEP-03', 'DD-MON-YY')` | `date('2003-09-17')` | String to date |
| `SYSDATE` | `date('now')` | Current date |

### Conditional Logic

| Oracle | SQLite |
|--------|--------|
| `DECODE(val, 'A', 1, 'B', 2, 0)` | `CASE val WHEN 'A' THEN 1 WHEN 'B' THEN 2 ELSE 0 END` |

### Group Functions (Fully Compatible ✓)

| Function | Oracle | SQLite | Notes |
|----------|--------|--------|-------|
| AVG | ✅ | ✅ | Calculate average |
| MIN | ✅ | ✅ | Find minimum |
| MAX | ✅ | ✅ | Find maximum |
| SUM | ✅ | ✅ | Calculate sum |
| COUNT | ✅ | ✅ | Count rows |
| DISTINCT | ✅ | ✅ | With all aggregates |

## 📊 Examples

### 1. TO_NUMBER / CAST

**Oracle:**
```sql
SELECT TO_NUMBER('+01234.78') FROM DUAL;
-- Result: 1234.78
```

**SQLite:**
```sql
SELECT CAST('+01234.78' AS REAL);
-- Result: 1234.78
```

### 2. TO_CHAR Number Formatting

**Oracle:**
```sql
SELECT TO_CHAR(123789, '9,99,999') FROM DUAL;
-- Result: 1,23,789
```

**SQLite:**
```sql
SELECT printf('%,d', 123789);
-- Result: 123,789 (US format)
-- Manual for Indian format: '1,23,789'
```

### 3. Date Formatting

**Oracle:**
```sql
SELECT TO_CHAR(HIRE_DATE, 'Day, DDth Mon, YYYY') 
FROM HR.EMPLOYEES;
-- Result: Tuesday, 17th Jun, 2003
```

**SQLite:**
```sql
SELECT strftime('%A, %d %b, %Y', HIRE_DATE) 
FROM employees_sample;
-- Result: Tuesday, 17 Jun, 2003
-- Note: SQLite doesn't support ordinal (th/st/nd/rd)
```

### 4. DECODE vs CASE

**Oracle:**
```sql
SELECT DECODE('MAX', 
              'MAX', 'this is maximum',
              'MIN', 'this is minimum',
              'this is equal') 
FROM DUAL;
-- Result: this is maximum
```

**SQLite:**
```sql
SELECT CASE 'MAX'
           WHEN 'MAX' THEN 'this is maximum'
           WHEN 'MIN' THEN 'this is minimum'
           ELSE 'this is equal'
       END;
-- Result: this is maximum
```

### 5. Group Functions

**Both Oracle and SQLite (Same syntax):**
```sql
-- Maximum salary
SELECT MAX(SALARY) FROM EMPLOYEES;

-- Average all vs distinct
SELECT 
    AVG(SALARY) AS "All Average",
    AVG(DISTINCT SALARY) AS "Distinct Average"
FROM EMPLOYEES;

-- Count rows
SELECT COUNT(*) FROM EMPLOYEES;        -- All rows
SELECT COUNT(COMMISSION_PCT) FROM EMPLOYEES;  -- Non-NULL only
```

## 📝 Date Format Codes

### Oracle TO_CHAR / TO_DATE Formats

| Format | Description | Example |
|--------|-------------|---------|
| `DD` | Day of month (01-31) | 17 |
| `MM` | Month number (01-12) | 06 |
| `MON` | 3-letter month | JUN |
| `MONTH` | Full month name | JUNE |
| `YY` | 2-digit year | 03 |
| `YYYY` | 4-digit year | 2003 |
| `DY` | 3-letter day | TUE |
| `DAY` | Full day name | TUESDAY |
| `HH24` | Hour (00-23) | 14 |
| `MI` | Minute (00-59) | 30 |
| `SS` | Second (00-59) | 45 |
| `TH` | Ordinal suffix | 17TH |
| `SP` | Spell out number | SEVENTEEN |

### SQLite strftime Formats

| Format | Description | Example |
|--------|-------------|---------|
| `%d` | Day of month (01-31) | 17 |
| `%m` | Month number (01-12) | 06 |
| `%b` | 3-letter month | Jun |
| `%B` | Full month name | June |
| `%y` | 2-digit year | 03 |
| `%Y` | 4-digit year | 2003 |
| `%a` | 3-letter day | Tue |
| `%A` | Full day name | Tuesday |
| `%H` | Hour (00-23) | 14 |
| `%M` | Minute (00-59) | 30 |
| `%S` | Second (00-59) | 45 |
| `%w` | Day of week (0-6) | 2 |
| `%j` | Day of year (001-366) | 168 |

## ⚠️ Important Notes

### Oracle-Specific

1. **DUAL Table** - Required for standalone queries:
   ```sql
   SELECT TO_NUMBER('123') FROM DUAL;  -- ✓ Correct
   SELECT TO_NUMBER('123');            -- ✗ Error
   ```

2. **Date Formats** - Case-insensitive but conventional uppercase:
   ```sql
   TO_CHAR(date, 'DD-MON-YYYY')  -- Recommended
   TO_CHAR(date, 'dd-mon-yyyy')  -- Works but not standard
   ```

3. **Number Formats**:
   - `9` - Digit placeholder (no leading zeros)
   - `0` - Digit placeholder (with leading zeros)
   - `,` - Thousands separator
   - `.` - Decimal point

### SQLite-Specific

1. **No DUAL Table** - Not needed:
   ```sql
   SELECT CAST('123' AS INTEGER);  -- ✓ Works directly
   ```

2. **Date Storage** - Use TEXT in ISO 8601 format:
   ```sql
   '2003-09-17'           -- ✓ Correct (YYYY-MM-DD)
   '17-SEP-2003'          -- ✗ Won't work with date functions
   ```

3. **printf Formats**:
   - `%d` - Integer
   - `%f` - Float
   - `%.2f` - Float with 2 decimal places
   - `%,d` - Integer with comma separator (SQLite 3.26+)
   - `%08d` - Zero-padded integer (width 8)

4. **No Ordinal Suffixes** - SQLite strftime doesn't support 'th', 'st', 'nd', 'rd':
   ```sql
   -- Oracle: 17th Jun
   -- SQLite: 17 Jun (ordinal must be added manually)
   ```

## 🧪 Testing the Scripts

### Test Oracle Version

```bash
# Using SQL*Plus
sqlplus username/password@XE @pr7.sql
```

### Test SQLite Version

```bash
# Create test database
sqlite3 test_conversions.db < pr7_sqlite.sql

# Verify results
sqlite3 test_conversions.db "SELECT MAX(SALARY), MIN(SALARY) FROM employees_sample;"
```

## 🐛 Troubleshooting

### Oracle Errors

**ORA-01722: invalid number**
```sql
-- Check: Ensure string contains only valid number characters
SELECT TO_NUMBER('+123.45') FROM DUAL;  -- ✓
SELECT TO_NUMBER('123ABC') FROM DUAL;   -- ✗ Error
```

**ORA-01843: not a valid month**
```sql
-- Check: Date format must match input string
SELECT TO_DATE('17-09-2003', 'DD-MM-YYYY') FROM DUAL;  -- ✓
SELECT TO_DATE('17-SEP-2003', 'DD-MM-YYYY') FROM DUAL; -- ✗ Error
```

### SQLite Errors

**No such function: TO_NUMBER**
```sql
-- Use CAST instead
SELECT CAST('123' AS INTEGER);  -- ✓
```

**Date functions not working**
```sql
-- Ensure dates are in YYYY-MM-DD format
SELECT date('2003-09-17');   -- ✓
SELECT date('17-SEP-2003');  -- ✗ Returns NULL
```

## 📚 Learning Outcomes

After completing this practical, you should be able to:
- ✅ Convert between data types (number, character, date)
- ✅ Format numbers with custom patterns
- ✅ Format dates in various display formats
- ✅ Use conditional logic with DECODE/CASE
- ✅ Apply aggregate functions (AVG, MIN, MAX, SUM, COUNT)
- ✅ Understand difference between ALL and DISTINCT in aggregates
- ✅ Count NULL vs non-NULL values
- ✅ Understand Oracle vs SQLite conversion function differences

## 🔗 References

- [Oracle TO_CHAR Function](https://docs.oracle.com/en/database/oracle/oracle-database/21/sqlrf/TO_CHAR-number.html)
- [Oracle TO_NUMBER Function](https://docs.oracle.com/en/database/oracle/oracle-database/21/sqlrf/TO_NUMBER.html)
- [Oracle TO_DATE Function](https://docs.oracle.com/en/database/oracle/oracle-database/21/sqlrf/TO_DATE.html)
- [Oracle DECODE Function](https://docs.oracle.com/en/database/oracle/oracle-database/21/sqlrf/DECODE.html)
- [Oracle Aggregate Functions](https://docs.oracle.com/en/database/oracle/oracle-database/21/sqlrf/Aggregate-Functions.html)
- [SQLite Date Functions](https://www.sqlite.org/lang_datefunc.html)
- [SQLite printf Function](https://www.sqlite.org/printf.html)
- [W3Schools SQL Aggregate Functions](https://www.w3schools.com/sql/sql_count_avg_sum.asp)

## 💡 Tips

1. **Test format strings** with simple examples before applying to complex queries
2. **Always verify date formats** - Oracle and SQLite use different conventions
3. **Use DISTINCT carefully** - It affects performance on large datasets
4. **COUNT(*) vs COUNT(column)** - COUNT(*) includes NULL, COUNT(column) excludes NULL
5. **CASE is more powerful** than DECODE - supports complex conditions
6. **Printf is SQLite 3.8.3+** - Verify your SQLite version supports printf
