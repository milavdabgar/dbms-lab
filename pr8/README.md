# Practical 8: Set Operators

Implementation of Set Operators in Oracle and SQLite.

## Files
- `pr8.sql` - Oracle version
- `pr8_sqlite.sql` - SQLite version

## Set Operators Covered

### 1. UNION
Combines results from two queries, removing duplicates.
```sql
-- Both Oracle and SQLite
SELECT ... FROM table1
UNION
SELECT ... FROM table2;
```

### 2. UNION ALL
Combines results from two queries, keeping duplicates.
```sql
-- Both Oracle and SQLite
SELECT ... FROM table1
UNION ALL
SELECT ... FROM table2;
```

### 3. INTERSECT
Returns only rows common to both queries.
```sql
-- Both Oracle and SQLite
SELECT ... FROM table1
INTERSECT
SELECT ... FROM table2;
```

### 4. MINUS / EXCEPT
Returns rows from first query that are not in second query.

| Database | Operator | Syntax |
|----------|----------|--------|
| Oracle | MINUS | `SELECT ... MINUS SELECT ...` |
| SQLite | EXCEPT | `SELECT ... EXCEPT SELECT ...` |

**Important:** EXCEPT and MINUS are functionally identical, just different keywords.

## Key Differences

| Feature | Oracle | SQLite |
|---------|--------|--------|
| UNION | ✅ Supported | ✅ Supported |
| UNION ALL | ✅ Supported | ✅ Supported |
| INTERSECT | ✅ Supported | ✅ Supported |
| MINUS | ✅ Supported | ❌ Not available |
| EXCEPT | ❌ Not available | ✅ Supported (use instead of MINUS) |

## Usage

### Oracle
```bash
sqlplus username/password@database
@pr8.sql
```

### SQLite
```bash
sqlite3 test_pr8.db < pr8_sqlite.sql
```

## Important Rules

1. **Column Count:** All SELECT statements must have the same number of columns
2. **Data Types:** Corresponding columns must have compatible data types
3. **Column Names:** Result uses column names from first SELECT
4. **ORDER BY:** Can only be used at the end of the entire query
5. **Duplicates:** UNION removes duplicates, UNION ALL keeps them
6. **Evaluation:** Set operators have equal precedence, evaluated left-to-right
7. **Parentheses:** Use parentheses to control evaluation order

## Sample Queries

### Example 1: UNION (Employees who are managers OR reps)
```sql
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, JOB_ID
FROM employees
WHERE JOB_ID LIKE '%MAN%'
UNION
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, JOB_ID
FROM employees
WHERE JOB_ID LIKE '%REP%';
```

### Example 2: INTERSECT (Employees who are managers AND in certain depts)
```sql
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME
FROM employees
WHERE JOB_ID LIKE '%MAN%'
INTERSECT
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME
FROM employees
WHERE DEPARTMENT_ID IN (20, 50, 80);
```

### Example 3: MINUS/EXCEPT (Reps who are NOT managers)
Oracle:
```sql
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME
FROM employees
WHERE JOB_ID LIKE '%REP%'
MINUS
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME
FROM employees
WHERE JOB_ID LIKE '%MAN%';
```

SQLite:
```sql
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME
FROM employees
WHERE JOB_ID LIKE '%REP%'
EXCEPT
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME
FROM employees
WHERE JOB_ID LIKE '%MAN%';
```

## Troubleshooting

### "SELECT statements have a different number of columns"
- Ensure both SELECT statements return the same number of columns

### "Data types in corresponding columns don't match"
- Verify compatible data types across queries
- Use CAST to convert if needed

### "MINUS not supported" (SQLite)
- Replace `MINUS` with `EXCEPT`
- Functionality is identical
