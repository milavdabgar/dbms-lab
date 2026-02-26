# Practical 12: Integrity Constraints

**Note:** This practical revisits Practical 3 (DDL) with focus on implementing Domain, Entity, and Referential Integrity constraints.

## Overview

The constraints are already implemented in [pr4/hrms_schema.sql](../pr4/hrms_schema.sql) and [pr4/hrms_schema_sqlite.sql](../pr4/hrms_schema_sqlite.sql). This practical emphasizes understanding and applying these three types of constraints.

## Three Types of Integrity

### 1. Domain Integrity
Ensures values in a column conform to a specified data type and range.

**Implementation:** `CHECK` constraints, `NOT NULL`, data types

**Oracle Examples:**
```sql
CREATE TABLE employees (
    employee_id NUMBER(6) PRIMARY KEY,
    salary NUMBER(8,2) CHECK (salary > 0),
    email VARCHAR2(50) NOT NULL,
    hire_date DATE DEFAULT SYSDATE,
    department_id NUMBER(4) CHECK (department_id BETWEEN 10 AND 270)
);
```

**SQLite Examples:**
```sql
CREATE TABLE employees (
    employee_id INTEGER PRIMARY KEY,
    salary REAL CHECK (salary > 0),
    email TEXT NOT NULL,
    hire_date TEXT DEFAULT (DATE('now')),
    department_id INTEGER CHECK (department_id BETWEEN 10 AND 270)
);
```

### 2. Entity Integrity
Ensures each row is uniquely identifiable.

**Implementation:** `PRIMARY KEY`, `UNIQUE` constraints

**Examples:**
```sql
-- PRIMARY KEY (one per table):
CREATE TABLE departments (
    department_id NUMBER(4) PRIMARY KEY,
    department_name VARCHAR2(30) UNIQUE NOT NULL
);

-- Composite PRIMARY KEY:
CREATE TABLE job_history (
    employee_id NUMBER(6),
    start_date DATE,
    PRIMARY KEY (employee_id, start_date)
);

-- UNIQUE constraint (multiple allowed):
CREATE TABLE employees (
    employee_id NUMBER(6) PRIMARY KEY,
    email VARCHAR2(50) UNIQUE NOT NULL
);
```

### 3. Referential Integrity
Ensures relationships between tables are maintained.

**Implementation:** `FOREIGN KEY` constraints

**Oracle Examples:**
```sql
CREATE TABLE employees (
    employee_id NUMBER(6) PRIMARY KEY,
    department_id NUMBER(4),
    manager_id NUMBER(6),
    CONSTRAINT emp_dept_fk FOREIGN KEY (department_id) 
        REFERENCES departments(department_id) ON DELETE CASCADE,
    CONSTRAINT emp_manager_fk FOREIGN KEY (manager_id)
        REFERENCES employees(employee_id) ON DELETE SET NULL
);
```

**SQLite Examples:**
```sql
PRAGMA foreign_keys = ON;  -- Must enable in SQLite

CREATE TABLE employees (
    employee_id INTEGER PRIMARY KEY,
    department_id INTEGER,
    manager_id INTEGER,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE CASCADE,
    FOREIGN KEY (manager_id) REFERENCES employees(employee_id) ON DELETE SET NULL
);
```

## Constraint Types

| Constraint Type | Purpose | Integrity Type |
|----------------|---------|----------------|
| PRIMARY KEY | Unique identifier for each row | Entity |
| FOREIGN KEY | Link to another table | Referential |
| UNIQUE | Ensure column values are unique | Entity/Domain |
| NOT NULL | Prevent null values | Domain |
| CHECK | Validate column values | Domain |
| DEFAULT | Provide default value | Domain |

## ON DELETE Options (Referential Integrity)

| Option | Behavior | Example |
|--------|----------|---------|
| CASCADE | Delete child rows when parent deleted | Employee deleted → Job history deleted |
| SET NULL | Set foreign key to NULL | Dept deleted → Employee dept_id = NULL |
| SET DEFAULT | Set foreign key to default value | (Oracle only, limited SQLite support) |
| NO ACTION | Prevent deletion if children exist | Can't delete dept if it has employees |
| RESTRICT | Same as NO ACTION | Default in most databases |

## Adding Constraints

### During Table Creation
```sql
CREATE TABLE employees (
    employee_id NUMBER(6) CONSTRAINT emp_pk PRIMARY KEY,
    salary NUMBER(8,2) CONSTRAINT emp_sal_ck CHECK (salary > 0)
);
```

### After Table Creation (ALTER TABLE)
```sql
-- Add PRIMARY KEY:
ALTER TABLE employees
ADD CONSTRAINT emp_pk PRIMARY KEY (employee_id);

-- Add FOREIGN KEY:
ALTER TABLE employees
ADD CONSTRAINT emp_dept_fk FOREIGN KEY (department_id)
REFERENCES departments(department_id);

-- Add CHECK:
ALTER TABLE employees
ADD CONSTRAINT emp_sal_ck CHECK (salary > 0);

-- Add UNIQUE:
ALTER TABLE employees
ADD CONSTRAINT emp_email_uk UNIQUE (email);

-- Add NOT NULL (Oracle):
ALTER TABLE employees
MODIFY email VARCHAR2(50) NOT NULL;
```

## Viewing Constraints

### Oracle
```sql
-- View all constraints:
SELECT constraint_name, constraint_type, table_name
FROM USER_CONSTRAINTS
WHERE table_name = 'EMPLOYEES';

-- View constraint details:
SELECT constraint_name, column_name
FROM USER_CONS_COLUMNS
WHERE table_name = 'EMPLOYEES';
```

### SQLite
```sql
-- View table schema with constraints:
.schema employees

-- Or query:
SELECT sql FROM sqlite_master 
WHERE type='table' AND name='employees';
```

## Dropping Constraints

### Oracle
```sql
ALTER TABLE employees DROP CONSTRAINT emp_sal_ck;
ALTER TABLE employees DROP PRIMARY KEY CASCADE;
```

### SQLite
**⚠️ SQLite Limitation:** Cannot drop constraints directly. Must recreate table.

```sql
-- Workaround: Recreate table without constraint
BEGIN TRANSACTION;
-- Create new table without constraint
-- Copy data
-- Drop old table
-- Rename new table
COMMIT;
```

## Key Differences: Oracle vs SQLite

| Feature | Oracle | SQLite |
|---------|--------|--------|
| Named constraints | ✅ Full support | ✅ Supported |
| DROP CONSTRAINT | ✅ Supported | ❌ Must recreate table |
| ON DELETE CASCADE | ✅ Supported | ✅ Must enable FK |
| ON DELETE SET DEFAULT | ✅ Supported | ⚠️ Limited support |
| CHECK constraints | ✅ Full support | ✅ Supported |
| FOREIGN KEY enforcement | ✅ Always on | ❌ Must enable with `PRAGMA foreign_keys = ON` |
| Deferred constraints | ✅ Supported | ⚠️ Limited support |

## Lab Manual Exercise

The lab manual states: "Implement Practical 3 with Domain Integrity, Entity Integrity and Referential Integrity constraints."

**Practical 3 tables with all three constraint types are already implemented in:**
- Oracle: [pr4/hrms_schema.sql](../pr4/hrms_schema.sql)
- SQLite: [pr4/hrms_schema_sqlite.sql](../pr4/hrms_schema_sqlite.sql)

These files demonstrate:
✅ **Domain Integrity:** CHECK constraints, NOT NULL, appropriate data types  
✅ **Entity Integrity:** PRIMARY KEY on all tables, UNIQUE constraints  
✅ **Referential Integrity:** FOREIGN KEY relationships with CASCADE options  

## Usage

```bash
# Oracle:
sqlplus username/password@database
@pr4/hrms_schema.sql

# SQLite:
sqlite3 test.db < pr4/hrms_schema_sqlite.sql
```

## Best Practices

1. **Name Constraints:** Makes debugging easier and allows dropping/modifying later
2. **Add Constraints During CREATE TABLE:** More efficient than ALTER TABLE
3. **Consider Performance:** Constraints add overhead to INSERT/UPDATE/DELETE
4. **Test Referential Integrity:** Verify CASCADE behavior before production
5. **Document Cascading Deletes:** Ensure team understands deletion consequences

## Troubleshooting

### "integrity constraint violated - parent key not found"
- Trying to insert foreign key value that doesn't exist in parent table
- Insert parent record first, or use existing parent key

### "integrity constraint violated - child record found"
- Trying to delete parent record that has children
- Delete children first, or use ON DELETE CASCADE

### "check constraint violated"
- Value doesn't meet CHECK constraint condition
- Verify value satisfies the constraint expression

### "unique constraint violated"
- Trying to insert duplicate value in PRIMARY KEY or UNIQUE column
- Check existing values before inserting

For complete implementation examples,see Practical 4 schema files.
