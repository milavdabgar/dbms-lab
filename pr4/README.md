# Practical 4: DML Commands (INSERT, SELECT, UPDATE, DELETE)

Implementation of Data Manipulation Language (DML) commands on the HRMS (Human Resource Management System) database.

## 📁 Files Overview

- **hrms_schema.sql** - Oracle version of HRMS database schema
- **hrms_schema_sqlite.sql** - SQLite version of HRMS database schema
- **pr4.sql** - Oracle DML commands implementation
- **pr4_sqlite.sql** - SQLite DML commands implementation

## 🎯 Practical Objectives

Perform DML operations on the HRMS database including:
1. **INSERT** - Add new records to tables
2. **SELECT** - Query and retrieve data
3. **UPDATE** - Modify existing records
4. **DELETE** - Remove records from tables

## 📋 Queries Covered

### 1. INSERT Operations
- Insert data into REGIONS, COUNTRIES, LOCATIONS, DEPARTMENTS, JOBS, EMPLOYEES
- Handle foreign key dependencies properly
- Insert data in correct order (parent tables before child tables)

### 2. SELECT Operations
- Retrieve all columns: `SELECT *`
- Retrieve specific columns
- Use WHERE clause for filtering

### 3. Logical Operators
- **AND** - Multiple conditions must be true
- **OR** - At least one condition must be true
- **NOT** - Negate a condition

### 4. Comparison Operators
- **BETWEEN** - Range of values (inclusive)
- **IN** - Match any value in a list
- **LIKE** - Pattern matching with wildcards (%, _)

### 5. UPDATE Operations
- Modify single records
- Modify multiple records
- Update with calculations (e.g., salary increase)

### 6. DELETE Operations
- Remove individual records
- Handle foreign key constraints
- Cascade deletions properly

## 🔧 Database Setup & Execution

### Oracle Database

```bash
# 1. Create the schema
sqlplus username/password@database
SQL> @hrms_schema.sql

# 2. Run DML commands
SQL> @pr4.sql
```

### SQLite Database

```bash
# 1. Create the schema
sqlite3 hrms.db < hrms_schema_sqlite.sql

# 2. Run DML commands
sqlite3 hrms.db < pr4_sqlite.sql
```

Or interactively:
```bash
sqlite3 hrms.db
sqlite> .read hrms_schema_sqlite.sql
sqlite> .read pr4_sqlite.sql
```

## 🔍 Key Differences: Oracle vs SQLite

### Date Handling
| Feature | Oracle | SQLite |
|---------|--------|--------|
| Date function | `TO_DATE('17-SEP-2003', 'DD-MON-YYYY')` | `'2003-09-17'` (ISO 8601) |
| Date storage | DATE type | TEXT type |
| Format | Multiple formats supported | YYYY-MM-DD recommended |

### Data Types
| Oracle | SQLite | Notes |
|--------|--------|-------|
| NUMBER | INTEGER / REAL | SQLite uses dynamic typing |
| VARCHAR2 | TEXT | SQLite TEXT has no length limit |
| CHAR | TEXT | SQLite doesn't distinguish fixed/variable |
| DATE | TEXT | Store as 'YYYY-MM-DD' format |

### Foreign Keys
| Feature | Oracle | SQLite |
|---------|--------|--------|
| Default behavior | Enabled by default | Must enable: `PRAGMA foreign_keys = ON;` |
| ALTER TABLE ADD FK | Supported | Not supported (define in CREATE TABLE) |
| Circular dependencies | Handled with ALTER TABLE | Requires careful ordering |

### Schema Differences

**Oracle circular foreign keys:**
```sql
-- Tables created first, then FKs added later
CREATE TABLE DEPARTMENTS (...);
CREATE TABLE EMPLOYEES (...);
ALTER TABLE DEPARTMENTS ADD FOREIGN KEY (MANAGER_ID) REFERENCES EMPLOYEES(EMPLOYEE_ID);
```

**SQLite workaround:**
```sql
-- All FKs defined in CREATE TABLE
CREATE TABLE DEPARTMENTS (
    ...
    MANAGER_ID INTEGER,
    FOREIGN KEY (MANAGER_ID) REFERENCES EMPLOYEES(EMPLOYEE_ID)
);
-- Note: FK only enforced after EMPLOYEES records exist
```

## ⚠️ Important Notes

### Foreign Key Constraint Order

When inserting data, follow this order to satisfy foreign key constraints:

1. **REGIONS** (no dependencies)
2. **COUNTRIES** (depends on REGIONS)
3. **LOCATIONS** (depends on COUNTRIES)
4. **DEPARTMENTS** (depends on LOCATIONS, MANAGER_ID can be NULL)
5. **JOBS** (no dependencies)
6. **EMPLOYEES** (depends on JOBS, DEPARTMENTS)
7. **Update DEPARTMENTS.MANAGER_ID** (after employees exist)

### Deletion Order

When deleting data, reverse the insertion order:

1. Clear foreign key references (set to NULL or delete dependent records)
2. **EMPLOYEES** (or update records referencing them)
3. **JOBS** (only if no employees reference them)
4. **DEPARTMENTS**
5. **LOCATIONS**
6. **COUNTRIES**
7. **REGIONS**

### SQLite-Specific Requirements

1. **Enable Foreign Keys:**
   ```sql
   PRAGMA foreign_keys = ON;
   ```
   This must be executed for **every connection** to the database.

2. **Date Format:**
   Always use ISO 8601 format: `'YYYY-MM-DD'`
   ```sql
   -- Correct
   INSERT INTO EMPLOYEES (..., HIRE_DATE, ...) VALUES (..., '2003-09-17', ...);
   
   -- Incorrect (Oracle syntax)
   INSERT INTO EMPLOYEES (..., HIRE_DATE, ...) VALUES (..., TO_DATE('17-SEP-2003', 'DD-MON-YYYY'), ...);
   ```

3. **Numeric Precision:**
   SQLite stores numbers as INTEGER or REAL (8-byte IEEE floating point).
   Oracle's NUMBER(8,2) becomes REAL in SQLite.

## 📊 Example Queries

### Basic SELECT
```sql
-- All employees
SELECT * FROM EMPLOYEES;

-- Specific columns
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY FROM EMPLOYEES;
```

### WHERE Clause with Operators
```sql
-- Logical AND
SELECT * FROM EMPLOYEES WHERE SALARY > 4000 AND DEPARTMENT_ID = 10;

-- Logical OR
SELECT * FROM DEPARTMENTS WHERE DEPARTMENT_ID = 10 OR LOCATION_ID = 2000;

-- NOT operator
SELECT * FROM EMPLOYEES WHERE NOT (SALARY > 5000);
```

### Comparison Operators
```sql
-- BETWEEN (inclusive range)
SELECT * FROM EMPLOYEES WHERE SALARY BETWEEN 3000 AND 5000;

-- IN (multiple values)
SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID IN (10, 20, 30);

-- LIKE (pattern matching)
SELECT * FROM EMPLOYEES WHERE LAST_NAME LIKE 'W%';  -- Starts with W
SELECT * FROM EMPLOYEES WHERE LAST_NAME LIKE '%a%'; -- Contains 'a'
```

### UPDATE with Calculations
```sql
-- Give 10% raise to Marketing department
UPDATE EMPLOYEES 
SET SALARY = SALARY * 1.10 
WHERE DEPARTMENT_ID = 20;
```

## 🧪 Testing the Scripts

### Test Oracle Version
```bash
# Assuming Oracle SQL*Plus is installed and configured
sqlplus username/password@database @hrms_schema.sql
sqlplus username/password@database @pr4.sql
```

### Test SQLite Version
```bash
# Create fresh database and test
sqlite3 test_hrms.db < hrms_schema_sqlite.sql
sqlite3 test_hrms.db < pr4_sqlite.sql

# Check results
sqlite3 test_hrms.db "SELECT * FROM EMPLOYEES;"
```

## 🐛 Troubleshooting

### Foreign Key Constraint Errors

**Oracle:**
```
ORA-02291: integrity constraint violated - parent key not found
```

**SQLite:**
```
Runtime error: FOREIGN KEY constraint failed
```

**Solutions:**
1. Check insertion order - insert parent records before child records
2. Verify referenced values exist in parent table
3. For SQLite, ensure `PRAGMA foreign_keys = ON;` is set

### Date Format Errors

**Oracle:**
```sql
-- Use TO_DATE with proper format mask
TO_DATE('17-SEP-2003', 'DD-MON-YYYY')
```

**SQLite:**
```sql
-- Use ISO 8601 format
'2003-09-17'
```

### Deletion Errors

If you can't delete a record, check:
1. Are there child records referencing it?
2. Set foreign key columns to NULL before deletion
3. Delete dependent records first

Example:
```sql
-- Before deleting employee 200
UPDATE DEPARTMENTS SET MANAGER_ID = NULL WHERE MANAGER_ID = 200;
UPDATE EMPLOYEES SET MANAGER_ID = NULL WHERE MANAGER_ID = 200;
DELETE FROM EMPLOYEES WHERE EMPLOYEE_ID = 200;
```

## 📚 Learning Outcomes

After completing this practical, you should be able to:
- ✅ Insert data into multiple related tables
- ✅ Handle foreign key dependencies properly
- ✅ Query data using various SELECT statements
- ✅ Filter data with WHERE clause and operators
- ✅ Update existing records
- ✅ Delete records while maintaining referential integrity
- ✅ Understand the differences between Oracle and SQLite DML syntax

## 🔗 References

- [Oracle SQL DML Statements](https://docs.oracle.com/en/database/)
- [SQLite Documentation](https://www.sqlite.org/lang.html)
- [W3Schools SQL Tutorial](https://www.w3schools.com/sql/)
- [GeeksforGeeks SQL Tutorial](https://www.geeksforgeeks.org/sql-tutorial/)

## 💡 Tips

1. Always backup your data before running UPDATE or DELETE operations
2. Test queries with SELECT before converting to UPDATE/DELETE
3. Use transactions to group related operations
4. Verify foreign key relationships in schema before inserting data
5. Use meaningful examples/data for better understanding
