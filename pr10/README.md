# Practical 10: Create, Alter, and Update Views

Implementation of Database Views in Oracle and SQLite.

## Files

- `pr10.sql` - Oracle version
- `pr10_sqlite.sql` - SQLite version

## What is a View?

A **view** is a virtual table based on the result set of a SQL query. It contains rows and columns from one or more tables, but doesn't store data itself.

### Benefits:

- Simplifies complex queries
- Provides data abstraction layer
- Enhances security by restricting access to specific columns/rows
- Maintains backward compatibility when table structure changes

## View Operations

### 1. CREATE VIEW

Creates a new view.

**Oracle:**

```sql
CREATE OR REPLACE VIEW view_name AS
SELECT column1, column2
FROM table_name
WHERE condition;
```

**SQLite:**

```sql
DROP VIEW IF EXISTS view_name;  -- No CREATE OR REPLACE in SQLite
CREATE VIEW view_name AS
SELECT column1, column2
FROM table_name
WHERE condition;
```

### 2. ALTER VIEW

Modifies an existing view's definition.

| Database | Support | Method |
|----------|---------|--------|
| Oracle | ✅ Supported | Use `CREATE OR REPLACE VIEW` |
| SQLite | ❌ Not supported | Must `DROP VIEW` and recreate |

**Oracle:**

```sql
CREATE OR REPLACE VIEW employee_info AS
SELECT employee_id, first_name, last_name, salary, hire_date  -- Added hire_date
FROM employees;
```

**SQLite:**

```sql
DROP VIEW IF EXISTS employee_info;
CREATE VIEW employee_info AS
SELECT employee_id, first_name, last_name, salary, hire_date  -- Added hire_date
FROM employees;
```

### 3. DROP VIEW

Removes a view from the database.

**Both Oracle and SQLite:**

```sql
DROP VIEW view_name;

-- Safer approach (SQLite):
DROP VIEW IF EXISTS view_name;
```

## Key Differences: Oracle vs SQLite

| Feature | Oracle | SQLite |
|---------|--------|--------|
| CREATE VIEW | ✅ Supported | ✅ Supported |
| DROP VIEW | ✅ Supported | ✅ Supported |
| CREATE OR REPLACE | ✅ Supported | ❌ Not supported |
| ALTER VIEW | ✅ Via CREATE OR REPLACE | ❌ Must DROP and recreate |
| WITH CHECK OPTION | ✅ Supported | ❌ Not supported |
| WITH READ ONLY | ✅ Supported | ❌ Not supported |
| Updatable Views | ✅ Complex rules | ✅ Single-table only |
| FORCE option | ✅ Supported | ❌ Not supported |
| View Metadata | `USER_VIEWS`, `ALL_VIEWS` | `sqlite_master` table |

## Advanced View Features

### Oracle-Only Features

#### WITH CHECK OPTION

Ensures INSERT/UPDATE operations through the view satisfy the WHERE clause.

```sql
CREATE OR REPLACE VIEW dept_50_emp AS
SELECT employee_id, first_name, salary, department_id
FROM employees
WHERE department_id = 50
WITH CHECK OPTION CONSTRAINT dept_50_check;

-- This will fail (violates WHERE clause):
-- INSERT INTO dept_50_emp VALUES (999, 'John', 5000, 60);
```

#### WITH READ ONLY

Prevents any DML operations through the view.

```sql
CREATE OR REPLACE VIEW readonly_emp AS
SELECT employee_id, first_name, last_name, salary
FROM employees
JOIN departments USING (department_id)
WITH READ ONLY;

-- This will fail (read-only view):
-- UPDATE readonly_emp SET salary = 10000 WHERE employee_id = 100;
```

#### FORCE Option

Creates view even if base tables don't exist.

```sql
CREATE FORCE VIEW future_view AS
SELECT * FROM nonexistent_table;
```

## View Types

### 1. Simple View

- Based on single table
- No aggregate functions
- Usually updatable

```sql
CREATE VIEW simple_emp AS
SELECT employee_id, first_name, last_name, salary
FROM employees
WHERE department_id = 50;
```

### 2. Complex View

- Multiple tables (JOINs)
- Aggregate functions
- GROUP BY clause
- Usually not updatable

```sql
CREATE VIEW dept_summary AS
SELECT d.department_name, COUNT(e.employee_id) AS emp_count, AVG(e.salary) AS avg_sal
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_name;
```

### 3. Inline View (Subquery in FROM clause)

- Temporary view within a single query
- Not stored in database

```sql
SELECT * FROM (
    SELECT employee_id, first_name, salary,
           RANK() OVER (ORDER BY salary DESC) AS salary_rank
    FROM employees
) WHERE salary_rank <= 10;
```

## Updatable Views

A view is updatable if it allows INSERT, UPDATE, and DELETE operations.

### Oracle Requirements:

- No DISTINCT keyword
- No aggregate functions (COUNT, SUM, AVG, etc.)
- No GROUP BY or HAVING clause
- No set operators (UNION, INTERSECT, MINUS)
- No rownum or analytic functions
- If multiple tables, key-preserved table must be updateable

### SQLite Requirements:

- Must be based on single table
- No DISTINCT, GROUP BY, HAVING
- No aggregate functions
- No UNION, INTERSECT, EXCEPT
- Much more restrictive than Oracle

## Lab Manual Queries

### Query 1: Create employee_info View

```sql
CREATE VIEW employee_info AS
SELECT E.FIRST_NAME, E.LAST_NAME, J.JOB_TITLE, D.DEPARTMENT_NAME, E.SALARY
FROM EMPLOYEES E
LEFT JOIN JOBS J ON E.JOB_ID = J.JOB_ID
LEFT JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;
```

### Query 2: Add hire_date Column

Oracle:

```sql
CREATE OR REPLACE VIEW employee_info AS
SELECT E.FIRST_NAME, E.LAST_NAME, J.JOB_TITLE, D.DEPARTMENT_NAME, E.SALARY, E.HIRE_DATE
FROM EMPLOYEES E
LEFT JOIN JOBS J ON E.JOB_ID = J.JOB_ID
LEFT JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;
```

SQLite:

```sql
DROP VIEW IF EXISTS employee_info;
CREATE VIEW employee_info AS
SELECT E.FIRST_NAME, E.LAST_NAME, J.JOB_TITLE, D.DEPARTMENT_NAME, E.SALARY, E.HIRE_DATE
FROM EMPLOYEES E
LEFT JOIN JOBS J ON E.JOB_ID = J.JOB_ID
LEFT JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID;
```

### Query 3: Filter for Salary > $50,000

```sql
-- Oracle: CREATE OR REPLACE
-- SQLite: DROP VIEW IF EXISTS then CREATE
CREATE VIEW employee_info AS
SELECT E.FIRST_NAME, E.LAST_NAME, J.JOB_TITLE, D.DEPARTMENT_NAME, E.SALARY, E.HIRE_DATE
FROM EMPLOYEES E
LEFT JOIN JOBS J ON E.JOB_ID = J.JOB_ID
LEFT JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
WHERE E.SALARY > 50000;
```

### Query 4: Create my_view for Department 20

```sql
CREATE VIEW my_view AS
SELECT E.EMPLOYEE_ID, E.FIRST_NAME, E.LAST_NAME, E.JOB_ID, E.SALARY
FROM EMPLOYEES E
WHERE E.DEPARTMENT_ID = 20;
```

### Query 5: Alter my_view for Department 30

Oracle:

```sql
CREATE OR REPLACE VIEW my_view AS
SELECT E.EMPLOYEE_ID, E.FIRST_NAME, E.LAST_NAME, E.JOB_ID, E.SALARY
FROM EMPLOYEES E
WHERE E.DEPARTMENT_ID = 30;
```

SQLite:

```sql
DROP VIEW IF EXISTS my_view;
CREATE VIEW my_view AS
SELECT E.EMPLOYEE_ID, E.FIRST_NAME, E.LAST_NAME, E.JOB_ID, E.SALARY
FROM EMPLOYEES E
WHERE E.DEPARTMENT_ID = 30;
```

### Query 6: Drop my_view

```sql
DROP VIEW my_view;

-- Safer (SQLite):
DROP VIEW IF EXISTS my_view;
```

## Usage

### Oracle

```bash
sqlplus username/password@database
@pr10.sql
```

### SQLite

```bash
sqlite3 test_pr10.db < pr10_sqlite.sql
```

## View Metadata

### Oracle

```sql
-- View all your views
SELECT view_name, text_length, read_only
FROM USER_VIEWS;

-- View definition
SELECT text FROM USER_VIEWS WHERE view_name = 'EMPLOYEE_INFO';
```

### SQLite

```sql
-- View all views
SELECT name, sql FROM sqlite_master WHERE type = 'view';

-- View definition
SELECT sql FROM sqlite_master WHERE type = 'view' AND name = 'employee_info';
```

## Troubleshooting

### "view does not exist"

- Check spelling and case sensitivity
- Verify the view was created successfully
- Use `IF EXISTS` clause when dropping

### "cannot modify column in view" (Oracle)

- View must be updatable (see requirements above)
- Check if view has WITH READ ONLY clause

### "cannot INSERT/UPDATE view" (SQLite)

- Ensure view is based on single table
- Remove aggregate functions, GROUP BY, JOIN from view definition

### "CREATE OR REPLACE not supported" (SQLite)

- Use `DROP VIEW IF EXISTS` followed by `CREATE VIEW`
