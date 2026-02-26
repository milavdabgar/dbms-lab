-- ============================================================================
-- Practical 14: TCL (Transaction Control Language) Commands
-- Database: SQLite
-- ============================================================================
-- This practical demonstrates:
-- 1. TCL Commands: BEGIN TRANSACTION, COMMIT, ROLLBACK, SAVEPOINT
-- 
-- Note: SQLite does NOT support DCL commands (GRANT, REVOKE, CREATE USER)
-- SQLite is a file-based database without user authentication or access control
-- ============================================================================

-- Enable output
.mode column
.headers on
.width 12 20 15 15 12

-- ============================================================================
-- PART 1: TCL COMMANDS (Transaction Control Language)
-- ============================================================================

-- Clean up and create sample tables
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS students;

-- Create accounts table for banking example
CREATE TABLE accounts (
    account_id      INTEGER PRIMARY KEY,
    account_holder  TEXT NOT NULL,
    balance         REAL CHECK (balance >= 0),
    account_type    TEXT CHECK (account_type IN ('Savings', 'Current')),
    created_date    TEXT DEFAULT (datetime('now'))
);

-- Create students table for academic example
CREATE TABLE students (
    student_id      INTEGER PRIMARY KEY,
    student_name    TEXT NOT NULL,
    email           TEXT UNIQUE,
    course          TEXT,
    semester        INTEGER,
    fees_paid       REAL DEFAULT 0
);

-- Insert initial data
INSERT INTO accounts VALUES (1001, 'Amit Sharma', 50000.00, 'Savings', datetime('now'));
INSERT INTO accounts VALUES (1002, 'Priya Patel', 75000.00, 'Current', datetime('now'));
INSERT INTO accounts VALUES (1003, 'Rahul Kumar', 30000.00, 'Savings', datetime('now'));
INSERT INTO accounts VALUES (1004, 'Sneha Singh', 100000.00, 'Current', datetime('now'));

INSERT INTO students VALUES (101, 'John Doe', 'john@student.edu', 'Computer Science', 4, 50000);
INSERT INTO students VALUES (102, 'Jane Smith', 'jane@student.edu', 'Electronics', 3, 45000);
INSERT INTO students VALUES (103, 'Bob Johnson', 'bob@student.edu', 'Mechanical', 2, 40000);

-- Display initial state
SELECT '=== Initial Account Balances ===' AS '';
SELECT * FROM accounts ORDER BY account_id;

SELECT '=== Initial Student Data ===' AS '';
SELECT * FROM students ORDER BY student_id;

-- ============================================================================
-- Important: SQLite Transaction Modes
-- ============================================================================
-- SQLite has AUTOCOMMIT mode ON by default
-- To use transactions, explicitly use BEGIN TRANSACTION
-- Three types of transactions:
-- 1. BEGIN TRANSACTION / BEGIN - Deferred transaction (default)
-- 2. BEGIN IMMEDIATE - Lock database immediately
-- 3. BEGIN EXCLUSIVE - Exclusive lock on database
-- ============================================================================

-- ============================================================================
-- Example 1: Simple COMMIT
-- ============================================================================

SELECT '=== Example 1: Simple COMMIT ===' AS '';

-- Start transaction
BEGIN TRANSACTION;

-- Update account balance
UPDATE accounts 
SET balance = balance + 5000 
WHERE account_id = 1001;

-- View changes (within transaction)
SELECT '--- Before COMMIT:' AS '';
SELECT * FROM accounts WHERE account_id = 1001;

-- Commit the transaction
COMMIT;

-- View committed changes
SELECT '--- After COMMIT (changes permanent):' AS '';
SELECT * FROM accounts WHERE account_id = 1001;

-- ============================================================================
-- Example 2: Simple ROLLBACK
-- ============================================================================

SELECT '=== Example 2: Simple ROLLBACK ===' AS '';

-- View current balance
SELECT '--- Before update:' AS '';
SELECT * FROM accounts WHERE account_id = 1002;

-- Start transaction
BEGIN TRANSACTION;

-- Make changes
UPDATE accounts 
SET balance = balance - 10000 
WHERE account_id = 1002;

-- View changes (within transaction)
SELECT '--- After update (before rollback):' AS '';
SELECT * FROM accounts WHERE account_id = 1002;

-- Rollback the transaction
ROLLBACK;

-- View after rollback (changes undone)
SELECT '--- After ROLLBACK (changes reverted):' AS '';
SELECT * FROM accounts WHERE account_id = 1002;

-- ============================================================================
-- Example 3: Bank Transfer Transaction (Atomic Operation)
-- ============================================================================

SELECT '=== Example 3: Bank Transfer (COMMIT) ===' AS '';

-- View balances before transfer
SELECT '--- Balances before transfer:' AS '';
SELECT account_id, account_holder, balance 
FROM accounts 
WHERE account_id IN (1001, 1003);

-- Start transaction
BEGIN TRANSACTION;

-- Transfer 10,000 from account 1001 to 1003
UPDATE accounts 
SET balance = balance - 10000 
WHERE account_id = 1001;

UPDATE accounts 
SET balance = balance + 10000 
WHERE account_id = 1003;

-- View balances after transfer (before commit)
SELECT '--- Balances after transfer (before commit):' AS '';
SELECT account_id, account_holder, balance 
FROM accounts 
WHERE account_id IN (1001, 1003);

-- Commit the transaction (make it permanent)
COMMIT;

-- View final balances
SELECT '--- Balances after COMMIT:' AS '';
SELECT account_id, account_holder, balance 
FROM accounts 
WHERE account_id IN (1001, 1003);

-- ============================================================================
-- Example 4: Failed Transaction with ROLLBACK
-- ============================================================================

SELECT '=== Example 4: Failed Transaction (ROLLBACK) ===' AS '';

-- View balances before
SELECT '--- Balances before failed transfer:' AS '';
SELECT account_id, account_holder, balance 
FROM accounts 
WHERE account_id IN (1003, 1004);

-- Start transaction
BEGIN TRANSACTION;

-- Try to transfer more money than available
-- This will fail due to CHECK constraint (balance >= 0)
-- Attempt to transfer 50,000 from account 1003 (only has 40,000)

-- This UPDATE will be rejected by CHECK constraint
-- UPDATE accounts SET balance = balance - 50000 WHERE account_id = 1003;

-- Instead, demonstrate manual rollback after detecting insufficient funds
UPDATE accounts 
SET balance = balance - 20000 
WHERE account_id = 1003;

UPDATE accounts 
SET balance = balance + 20000 
WHERE account_id = 1004;

-- Suppose we detect an error and need to rollback
ROLLBACK;

-- View balances after rollback
SELECT '--- Balances after ROLLBACK (unchanged):' AS '';
SELECT account_id, account_holder, balance 
FROM accounts 
WHERE account_id IN (1003, 1004);

-- ============================================================================
-- Example 5: SAVEPOINT - Multiple Operations with Partial Rollback
-- ============================================================================

SELECT '=== Example 5: SAVEPOINT ===' AS '';

-- Start transaction
BEGIN TRANSACTION;

-- View initial student data
SELECT '--- Initial student data:' AS '';
SELECT * FROM students ORDER BY student_id;

-- Operation 1: Add a new student
INSERT INTO students VALUES (104, 'Alice Brown', 'alice@student.edu', 'Civil', 1, 35000);
SAVEPOINT after_insert;

-- View after insert
SELECT '--- After INSERT (Savepoint A):' AS '';
SELECT * FROM students ORDER BY student_id;

-- Operation 2: Update existing student
UPDATE students 
SET fees_paid = fees_paid + 5000 
WHERE student_id = 101;
SAVEPOINT after_update;

-- View after update
SELECT '--- After UPDATE (Savepoint B):' AS '';
SELECT student_id, student_name, fees_paid FROM students WHERE student_id IN (101, 104);

-- Operation 3: Delete a student
DELETE FROM students WHERE student_id = 103;
SAVEPOINT after_delete;

-- View after delete
SELECT '--- After DELETE (Savepoint C):' AS '';
SELECT * FROM students ORDER BY student_id;

-- Now rollback to different savepoints

-- Rollback the delete operation only
ROLLBACK TO after_update;

SELECT '--- After ROLLBACK TO after_update (DELETE undone):' AS '';
SELECT * FROM students ORDER BY student_id;

-- Rollback the update operation as well
ROLLBACK TO after_insert;

SELECT '--- After ROLLBACK TO after_insert (UPDATE also undone):' AS '';
SELECT * FROM students ORDER BY student_id;

-- Commit only the insert operation
COMMIT;

SELECT '--- After COMMIT (only INSERT remains):' AS '';
SELECT * FROM students ORDER BY student_id;

-- ============================================================================
-- Example 6: Complex Transaction with Multiple Savepoints
-- ============================================================================

SELECT '=== Example 6: Complex Transaction ===' AS '';

-- Scenario: Process multiple fee payments
BEGIN TRANSACTION;

-- Payment 1
UPDATE students SET fees_paid = fees_paid + 10000 WHERE student_id = 101;
SAVEPOINT payment1;
SELECT '--- After Payment 1:' AS '';
SELECT student_id, student_name, fees_paid FROM students WHERE student_id = 101;

-- Payment 2
UPDATE students SET fees_paid = fees_paid + 8000 WHERE student_id = 102;
SAVEPOINT payment2;
SELECT '--- After Payment 2:' AS '';
SELECT student_id, student_name, fees_paid FROM students WHERE student_id = 102;

-- Payment 3
UPDATE students SET fees_paid = fees_paid + 7000 WHERE student_id = 104;
SAVEPOINT payment3;
SELECT '--- After Payment 3:' AS '';
SELECT student_id, student_name, fees_paid FROM students WHERE student_id = 104;

-- Suppose Payment 2 was incorrect, rollback to before Payment 2
ROLLBACK TO payment1;

-- Continue with Payment 3 (corrected)
UPDATE students SET fees_paid = fees_paid + 9000 WHERE student_id = 102;
SAVEPOINT payment2_corrected;

-- Commit all payments
COMMIT;

SELECT '--- Final fees after all payments:' AS '';
SELECT student_id, student_name, fees_paid FROM students ORDER BY student_id;

-- ============================================================================
-- Example 7: Transaction Types in SQLite
-- ============================================================================

SELECT '=== Example 7: Transaction Types ===' AS '';

-- BEGIN DEFERRED (default)
-- Database is locked only when first read/write occurs
BEGIN;
SELECT '--- DEFERRED transaction started ---' AS '';
SELECT COUNT(*) as account_count FROM accounts;
COMMIT;

-- BEGIN IMMEDIATE
-- Database is locked immediately (prevents other writers)
BEGIN IMMEDIATE;
SELECT '--- IMMEDIATE transaction started ---' AS '';
UPDATE accounts SET balance = balance + 100 WHERE account_id = 1001;
COMMIT;

-- BEGIN EXCLUSIVE
-- Database is locked exclusively (prevents all other connections)
BEGIN EXCLUSIVE;
SELECT '--- EXCLUSIVE transaction started ---' AS '';
UPDATE accounts SET balance = balance - 100 WHERE account_id = 1001;
COMMIT;

-- ============================================================================
-- Example 8: Demonstrating AUTOCOMMIT Behavior
-- ============================================================================

SELECT '=== Example 8: AUTOCOMMIT Behavior ===' AS '';

-- Without explicit BEGIN TRANSACTION, each statement auto-commits
SELECT '--- Without transaction (autocommit):' AS '';
UPDATE accounts SET balance = balance + 1000 WHERE account_id = 1002;
-- Above statement is automatically committed

-- To rollback, must be inside a transaction
BEGIN TRANSACTION;
UPDATE accounts SET balance = balance - 1000 WHERE account_id = 1002;
ROLLBACK;  -- This works because we're in a transaction

SELECT '--- After ROLLBACK in transaction:' AS '';
SELECT * FROM accounts WHERE account_id = 1002;

-- ============================================================================
-- Example 9: Nested Savepoints
-- ============================================================================

SELECT '=== Example 9: Nested Savepoints ===' AS '';

BEGIN TRANSACTION;

INSERT INTO students VALUES (105, 'Charlie Davis', 'charlie@student.edu', 'IT', 1, 30000);
SAVEPOINT level1;

UPDATE students SET fees_paid = fees_paid + 5000 WHERE student_id = 105;
SAVEPOINT level2;

UPDATE students SET semester = 2 WHERE student_id = 105;
SAVEPOINT level3;

SELECT '--- All changes made:' AS '';
SELECT * FROM students WHERE student_id = 105;

-- Rollback to level2 (undo semester change)
ROLLBACK TO level2;

SELECT '--- After rollback to level2:' AS '';
SELECT * FROM students WHERE student_id = 105;

-- Release savepoint (cannot rollback to it anymore)
RELEASE level2;

-- Commit remaining changes
COMMIT;

SELECT '--- Final state after commit:' AS '';
SELECT * FROM students WHERE student_id = 105;

-- ============================================================================
-- Example 10: Transaction with Error Handling
-- ============================================================================

SELECT '=== Example 10: Error Handling Pattern ===' AS '';

-- Demonstrate proper error handling pattern
BEGIN TRANSACTION;

-- This will succeed
UPDATE accounts SET balance = balance + 2000 WHERE account_id = 1001;

-- View intermediate state
SELECT '--- After first update:' AS '';
SELECT * FROM accounts WHERE account_id = 1001;

-- This might fail (simulating an error)
-- In a real application, you'd check conditions before executing
-- For demo, we'll just rollback manually

-- Rollback due to "error"
ROLLBACK;

SELECT '--- After ROLLBACK (no changes):' AS '';
SELECT * FROM accounts WHERE account_id = 1001;

-- ============================================================================
-- SQLite vs Oracle Transaction Differences
-- ============================================================================

/*
KEY DIFFERENCES:

1. AUTOCOMMIT:
   - Oracle: OFF by default (manual COMMIT required)
   - SQLite: ON by default (use BEGIN TRANSACTION for manual control)

2. TRANSACTION ISOLATION:
   - Oracle: Multiple isolation levels (READ COMMITTED, SERIALIZABLE)
   - SQLite: Only SERIALIZABLE isolation level

3. LOCKING:
   - Oracle: Row-level locking
   - SQLite: Database-level locking

4. DCL COMMANDS:
   - Oracle: Full support (GRANT, REVOKE, CREATE USER)
   - SQLite: NO support (file-based permissions only)

5. DDL IN TRANSACTIONS:
   - Oracle: DDL auto-commits
   - SQLite: DDL can be rolled back

6. TRANSACTION KEYWORDS:
   - Oracle: Just BEGIN/COMMIT/ROLLBACK
   - SQLite: BEGIN [DEFERRED|IMMEDIATE|EXCLUSIVE]
*/

-- ============================================================================
-- Best Practices for SQLite Transactions
-- ============================================================================

/*
TRANSACTION BEST PRACTICES:

1. Always use explicit BEGIN TRANSACTION for multi-statement operations
2. Use SAVEPOINT for complex operations with partial rollback needs
3. Keep transactions as short as possible
4. Use BEGIN IMMEDIATE for write operations to avoid SQLITE_BUSY errors
5. Handle errors properly with ROLLBACK
6. Test transaction logic thoroughly
7. Consider using WAL mode for better concurrency: PRAGMA journal_mode=WAL;
8. Don't keep transactions open for long periods
9. Use RELEASE to remove savepoints you no longer need
10. Remember that DDL can be rolled back in SQLite (unlike Oracle)

TCL COMMAND SUMMARY:

- BEGIN [TRANSACTION]         : Start a new transaction
- BEGIN IMMEDIATE             : Start transaction with immediate write lock
- BEGIN EXCLUSIVE             : Start transaction with exclusive lock
- COMMIT                      : Save all changes permanently
- ROLLBACK                    : Undo all changes since BEGIN
- SAVEPOINT name              : Create a savepoint within transaction
- ROLLBACK TO name            : Rollback to a specific savepoint
- RELEASE name                : Remove a savepoint
*/

-- ============================================================================
-- View Current Transaction State
-- ============================================================================

-- Check if we're in a transaction
-- Note: This is for demonstration - in practice, your application tracks this
SELECT '=== Current Database State ===' AS '';
SELECT 'All transactions completed' AS status;

SELECT '--- Final Account Balances:' AS '';
SELECT * FROM accounts ORDER BY account_id;

SELECT '--- Final Student Data:' AS '';
SELECT * FROM students ORDER BY student_id;

-- ============================================================================
-- Note on DCL in SQLite
-- ============================================================================

SELECT '=== Note: DCL Commands ===' AS '';
SELECT 'SQLite does NOT support DCL commands (GRANT, REVOKE, CREATE USER)' AS note;
SELECT 'Access control is handled at the OS file system level' AS note;
SELECT 'For multi-user databases with access control, use Oracle, MySQL, or PostgreSQL' AS note;

SELECT '=== Practical 14 completed ===' AS '';
