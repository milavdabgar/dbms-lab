# Practical 9: Retrieve Data using Various Joins

Implementation of SQL Joins in Oracle and SQLite.

## Files

- `pr9.sql` - Oracle version
- `pr9_sqlite.sql` - SQLite version

## Join Types Covered

### 1. INNER JOIN

Returns only rows that have matching values in both tables.

```sql
SELECT * FROM table1
INNER JOIN table2 ON table1.id = table2.id;
```

### 2. LEFT OUTER JOIN (LEFT JOIN)

Returns all rows from the left table and matching rows from the right table.

```sql
SELECT * FROM table1
LEFT JOIN table2 ON table1.id = table2.id;
```

### 3. RIGHT OUTER JOIN (RIGHT JOIN)

Returns all rows from the right table and matching rows from the left table.

| Database | Support | Alternative |
|----------|---------|-------------|
| Oracle | ✅ Supported | N/A |
| SQLite | ❌ Not supported | Use `LEFT JOIN` with reversed tables |

**SQLite Workaround:**

```sql
-- Oracle: RIGHT JOIN
SELECT * FROM employees E
RIGHT JOIN departments D ON E.dept_id = D.dept_id;

-- SQLite equivalent: Reverse the tables
SELECT * FROM departments D
LEFT JOIN employees E ON E.dept_id = D.dept_id;
```

### 4. FULL OUTER JOIN

Returns all rows from both tables, filling NULLs where no match exists.

| Database | Support | Alternative |
|----------|---------|-------------|
| Oracle | ✅ Supported | N/A |
| SQLite | ❌ Not supported | Use `UNION` of `LEFT JOIN`s |

**SQLite Workaround:**

```sql
-- Oracle: FULL OUTER JOIN
SELECT * FROM employees E
FULL OUTER JOIN departments D ON E.dept_id = D.dept_id;

-- SQLite equivalent: UNION of LEFT JOINs
SELECT * FROM employees E
LEFT JOIN departments D ON E.dept_id = D.dept_id
UNION
SELECT * FROM employees E
RIGHT JOIN departments D ON E.dept_id = D.dept_id
WHERE E.id IS NULL;
```

### 5. SELF JOIN

Joins a table to itself.

```sql
-- Find employees and their managers
SELECT 
    E.name AS employee,
    M.name AS manager
FROM employees E
LEFT JOIN employees M ON E.manager_id = M.employee_id;
```

### 6. CROSS JOIN

Returns the Cartesian product of both tables.

```sql
SELECT * FROM table1 CROSS JOIN table2;
```

### 7. NATURAL JOIN

Automatically joins tables on columns with the same name.

```sql
SELECT * FROM employees NATURAL JOIN departments;
```

## Key Differences: Oracle vs SQLite

| Feature | Oracle | SQLite |
|---------|--------|--------|
| INNER JOIN | ✅ Supported | ✅ Supported |
| LEFT JOIN | ✅ Supported | ✅ Supported |
| RIGHT JOIN | ✅ Supported | ❌ Not supported (use LEFT JOIN with reversed tables) |
| FULL OUTER JOIN | ✅ Supported | ❌ Not supported (use UNION of LEFT JOINs) |
| SELF JOIN | ✅ Supported | ✅ Supported |
| CROSS JOIN | ✅ Supported | ✅ Supported |
| NATURAL JOIN | ✅ Supported | ✅ Supported |
| Result Limiting | `FETCH FIRST n ROWS ONLY` | `LIMIT n` |
| Output Formatting | `PROMPT` command | `SELECT '...' AS ''` |

## Usage

### Oracle

```bash
sqlplus username/password@database
@pr9.sql
```

### SQLite

```bash
sqlite3 test_pr9.db < pr9_sqlite.sql
```

## Lab Manual Queries

### Query 1: Sales Department Employees

Retrieve employee ID, name, department name, and job title for Sales department employees.

```sql
SELECT E.EMPLOYEE_ID, E.FIRST_NAME, E.LAST_NAME, D.DEPARTMENT_NAME, J.JOB_TITLE
FROM EMPLOYEES E
INNER JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
INNER JOIN JOBS J ON E.JOB_ID = J.JOB_ID
WHERE D.DEPARTMENT_NAME = 'Sales';
```

### Query 2: Employees with Commission > 10%

Retrieve employee details for those with commission percentage greater than 10%.

```sql
SELECT E.EMPLOYEE_ID, E.FIRST_NAME, E.LAST_NAME, E.SALARY, E.COMMISSION_PCT
FROM EMPLOYEES E
WHERE E.COMMISSION_PCT > 0.10;
```

### Query 3: Employees in Same Dept as Manager

Retrieve employees who work in the same department as their manager.

```sql
SELECT E.EMPLOYEE_ID, E.FIRST_NAME, D.DEPARTMENT_NAME,
       M.FIRST_NAME || ' ' || M.LAST_NAME AS MANAGER_NAME
FROM EMPLOYEES E
INNER JOIN EMPLOYEES M ON E.MANAGER_ID = M.EMPLOYEE_ID
INNER JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE E.DEPARTMENT_ID = M.DEPARTMENT_ID;
```

### Query 4: Employees with Manager "King"

Retrieve employees whose manager's last name is King.

```sql
SELECT E.EMPLOYEE_ID, E.FIRST_NAME, E.LAST_NAME, D.DEPARTMENT_NAME, J.JOB_TITLE
FROM EMPLOYEES E
INNER JOIN EMPLOYEES M ON E.MANAGER_ID = M.EMPLOYEE_ID
LEFT JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
LEFT JOIN JOBS J ON E.JOB_ID = J.JOB_ID
WHERE M.LAST_NAME = 'King';
```

### Query 5: Employees in Same Dept as Employee 176

Retrieve employees in the same department as employee ID 176.

```sql
SELECT E.EMPLOYEE_ID, E.FIRST_NAME, D.DEPARTMENT_NAME, J.JOB_TITLE, E.SALARY
FROM EMPLOYEES E
INNER JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
INNER JOIN JOBS J ON E.JOB_ID = J.JOB_ID
WHERE E.DEPARTMENT_ID = (SELECT DEPARTMENT_ID FROM EMPLOYEES WHERE EMPLOYEE_ID = 176);
```

## Important Notes

1. **Column Matching:** JOIN conditions typically use `=` (equijoin), but can use other operators (non-equijoin)
2. **Aliases:** Use table aliases to simplify queries and avoid ambiguity
3. **NULL Handling:** OUTER JOINs produce NULL values where no match exists
4. **Performance:** INNER JOINs are generally faster than OUTER JOINs
5. **Order Matters:** In OUTER JOINs, the table order affects results (LEFT vs RIGHT)
6. **Multiple Joins:** You can chain multiple JOINs in a single query
7. **NATURAL JOIN:** Be cautious - it matches ALL columns with same names

## Troubleshooting

### "ambiguous column name"

- Use table aliases to qualify column names: `E.EMPLOYEE_ID` instead of just `EMPLOYEE_ID`

### "RIGHT JOIN not supported" (SQLite)

- Reverse the table order and use LEFT JOIN instead

### "FULL OUTER JOIN not supported" (SQLite)

- Use UNION of two LEFT JOINs (one with each table as the left table)

### "column doesn't exist in table"

- Check spelling and case sensitivity
- Verify the column exists in the specified table
- Ensure you're referencing the correct table alias
