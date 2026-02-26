# Practical 14: TCL and DCL Commands

Combined implementation of Transaction Control Language (TCL) and Data Control Language (DCL) commands.

## Overview

This practical has two parts:

1. **TCL Commands:** COMMIT, ROLLBACK, SAVEPOINT (works in both Oracle and SQLite)
2. **DCL Commands:** GRANT, REVOKE (Oracle only - see [Practical 11](../pr11))

## Files

- `pr14_tcl_oracle.sql` - Oracle TCL commands
- `pr14_tcl_sqlite.sql` - SQLite TCL commands
- **DCL Commands:** See [Practical 11](../pr11/README.md) for complete DCL documentation

## Part 1: TCL Commands

### What is a Transaction?

A **transaction** is a logical unit of work containing one or more SQL statements. Transactions ensure data integrity through ACID properties:

- **Atomicity:** All operations succeed or all fail
- **Consistency:** Database remains in consistent state
- **Isolation:** Transactions don't interfere with each other
- **Durability:** Committed changes are permanent

### TCL Commands

| Command | Purpose | Oracle | SQLite |
|---------|---------|--------|--------|
| COMMIT | Save changes permanently | ✅ | ✅ |
| ROLLBACK | Undo changes | ✅ | ✅ |
| SAVEPOINT | Create restore point | ✅ | ✅ |

### COMMIT

Makes all changes in the current transaction permanent.

**Oracle:**

```sql
UPDATE employees SET salary = salary * 1.10 WHERE department_id = 50;
COMMIT;  -- Changes are now permanent
```

**SQLite:**

```sql
BEGIN TRANSACTION;
UPDATE employees SET salary = salary * 1.10 WHERE department_id = 50;
COMMIT;  -- Changes are now permanent
```

**Key Differences:**

- **Oracle:** Autocommit OFF by default (must explicitly COMMIT)
- **SQLite:** Autocommit ON by default (must use BEGIN TRANSACTION for manual control)

### ROLLBACK

Undoes all changes in the current transaction.

**Oracle:**

```sql
DELETE FROM employees WHERE employee_id = 999;
-- Realize this was a mistake!
ROLLBACK;  -- Deletion is undone
```

**SQLite:**

```sql
BEGIN TRANSACTION;
DELETE FROM employees WHERE employee_id = 999;
-- Realize this was a mistake!
ROLLBACK;  -- Deletion is undone
```

### SAVEPOINT

Creates a named point within a transaction to which you can later roll back.

**Oracle:**

```sql
INSERT INTO employees VALUES (301, 'John', 'Doe', ...);
SAVEPOINT after_insert;

UPDATE employees SET salary = 5000 WHERE employee_id = 301;
SAVEPOINT after_update;

DELETE FROM employees WHERE employee_id = 301;

-- Undo only the DELETE:
ROLLBACK TO after_update;

-- Or undo UPDATE and DELETE:
ROLLBACK TO after_insert;

-- Or undo everything:
ROLLBACK;
```

**SQLite:**

```sql
BEGIN TRANSACTION;

INSERT INTO employees VALUES (301, 'John', 'Doe', ...);
SAVEPOINT after_insert;

UPDATE employees SET salary = 5000 WHERE employee_id = 301;
SAVEPOINT after_update;

DELETE FROM employees WHERE employee_id = 301;

-- Undo only the DELETE:
ROLLBACK TO after_update;

-- Continue transaction or commit:
COMMIT;
```

## Transaction Examples

### Example 1: Bank Transfer (Atomic Operation)

Both operations must succeed or both must fail:

**Oracle:**

```sql
-- Deduct from Account A:
UPDATE accounts SET balance = balance - 100 WHERE account_id = 'A001';

-- Add to Account B:
UPDATE accounts SET balance = balance + 100 WHERE account_id = 'B001';

-- If both succeed:
COMMIT;

-- If either fails:
ROLLBACK;
```

**SQLite:**

```sql
BEGIN TRANSACTION;

-- Deduct from Account A:
UPDATE accounts SET balance = balance - 100 WHERE account_id = 'A001';

-- Add to Account B:
UPDATE accounts SET balance = balance + 100 WHERE account_id = 'B001';

-- If both succeed:
COMMIT;

-- If either fails (in error handler):
ROLLBACK;
```

### Example 2: Multi-step Data Entry with Savepoints

**Oracle:**

```sql
-- Insert student:
INSERT INTO students VALUES (101, 'John', 'Doe', 'john@example.com');
SAVEPOINT student_added;

-- Enroll in courses:
INSERT INTO enrollments VALUES (101, 'CS101', 'Fall', 2024);
INSERT INTO enrollments VALUES (101, 'CS102', 'Fall', 2024);
SAVEPOINT courses_added;

-- Assign advisor:
UPDATE students SET advisor_id = 201 WHERE student_id = 101;

-- If advisor assignment fails, undo it but keep enrollments:
ROLLBACK TO courses_added;

-- Commit student and course enrollments:
COMMIT;
```

## Key Differences: Oracle vs SQLite

| Feature | Oracle | SQLite |
|---------|--------|--------|
| Default Mode | Manual commit | Autocommit |
| BEGIN TRANSACTION | Implicit | Explicit (required) |
| COMMIT | Required | Required (if BEGIN used) |
| ROLLBACK | Undoes all uncommitted | Undoes to BEGIN TRANSACTION |
| SAVEPOINT | ✅ Full support | ✅ Supported |
| ROLLBACK TO SAVEPOINT | ✅ Supported | ✅ Supported |
| Nested Transactions | ❌ Not supported | ⚠️ Via SAVEPOINT only |
| Transaction Isolation | Multiple levels | Serializable only |

## Part 2: DCL Commands (Oracle Only)

For complete DCL documentation, see [Practical 11](../pr11/README.md).

### Quick Reference

**GRANT:**

```sql
-- System privileges:
GRANT CREATE SESSION, CREATE TABLE TO username;

-- Object privileges:
GRANT SELECT, INSERT, UPDATE ON table_name TO username;

-- All privileges:
GRANT ALL ON table_name TO username;

-- With grant option:
GRANT SELECT ON table_name TO username WITH GRANT OPTION;
```

**REVOKE:**

```sql
-- System privileges:
REVOKE CREATE TABLE FROM username;

-- Object privileges:
REVOKE SELECT, INSERT ON table_name FROM username;

-- All privileges:
REVOKE ALL ON table_name FROM username;
```

**⚠️ SQLite Note:** SQLite does not support DCL commands (no user management).

## Transaction Best Practices

### 1. Keep Transactions Short

```sql
-- BAD: Long-running transaction
BEGIN TRANSACTION;
SELECT * FROM large_table WHERE condition;  -- Takes 10 minutes
UPDATE ...;
COMMIT;

-- GOOD: Short transaction
SELECT * FROM large_table WHERE condition;  -- Outside transaction
BEGIN TRANSACTION;
UPDATE ...;
COMMIT;
```

### 2. Use Savepoints for Complex Operations

```sql
BEGIN TRANSACTION;
    INSERT INTO table1 ...;
    SAVEPOINT after_table1;
    
    INSERT INTO table2 ...;
    SAVEPOINT after_table2;
    
    -- If table3 insert fails, can rollback to after_table2
    INSERT INTO table3 ...;
COMMIT;
```

### 3. Handle Errors Properly

```sql
-- Oracle PL/SQL:
BEGIN
    UPDATE accounts SET balance = balance - 100 WHERE account_id = 'A001';
    UPDATE accounts SET balance = balance + 100 WHERE account_id = 'B001';
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
```

### 4. Don't Mix DDL and DML in Oracle

```sql
-- DDL (CREATE, ALTER, DROP) causes implicit COMMIT in Oracle
-- This is automatically committed:
CREATE TABLE temp (id NUMBER);

-- Subsequent DML is a new transaction:
INSERT INTO temp VALUES (1);
-- Must explicitly commit this
COMMIT;
```

## Transaction Isolation Levels (Oracle)

Oracle supports multiple isolation levels (SQLite only supports SERIALIZABLE):

```sql
-- Set isolation level (Oracle):
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
```

| Level | Dirty Read | Non-repeatable Read | Phantom Read |
|-------|------------|---------------------|--------------|
| READ UNCOMMITTED | Yes | Yes | Yes |
| READ COMMITTED | No | Yes | Yes |
| REPEATABLE READ | No | No | Yes |
| SERIALIZABLE | No | No | No |

## Common Transaction Patterns

### Pattern 1: Try-Commit-Rollback

```sql
BEGIN TRANSACTION;
    BEGIN TRY
        -- Multiple operations
        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
    END CATCH
END;
```

### Pattern 2: Incremental Savepoints

```sql
BEGIN TRANSACTION;
FOR each operation DO
    SAVEPOINT before_operation;
    TRY operation;
    IF success THEN
        RELEASE SAVEPOINT before_operation;  -- Optional cleanup
    ELSE
        ROLLBACK TO before_operation;
    END IF;
END FOR;
COMMIT;
```

## Viewing Transaction Status

### Oracle

```sql
-- Check if transaction is active:
SELECT * FROM V$TRANSACTION;

-- View pending locks:
SELECT * FROM V$LOCK WHERE SID = (SELECT SID FROM V$SESSION WHERE AUDSID = USERENV('SESSIONID'));
```

### SQLite

```sql
-- SQLite doesn't expose transaction state directly
-- Check via PRAGMA:
PRAGMA compile_options;  -- Look for ENABLE_API_ARMOR
```

## Usage

### Oracle

```bash
sqlplus username/password@database
@pr14_tcl_oracle.sql
```

### SQLite

```bash
sqlite3 test.db < pr14_tcl_sqlite.sql
```

## Troubleshooting

### "cannot commit - no transaction is active"

- Oracle: Transaction starts automatically with first DML
- SQLite: Must use BEGIN TRANSACTION explicitly

### "deadlock detected"

- Two transactions waiting for each other's locks
- One transaction will be rolled back automatically
- Retry the rolled-back transaction

### "transaction rolled back" after DDL (Oracle)

- DDL statements cause implicit COMMIT
- Subsequent DML is a new transaction
- Don't mix DDL and DML in critical transactions

### Changes not visible to other sessions

- Changes are not committed yet
- Use COMMIT to make changes visible
- Check transaction isolation level

## References

- Oracle: SQL*Plus automatically commits when you exit (unless you set EXIT ROLLBACK)
- SQLite: Uncommitted changes are lost when connection closes
- Both: Use explicit COMMIT for important changes
- For DCL commands, see [Practical 11](../pr11/README.md)
