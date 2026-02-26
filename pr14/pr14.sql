-- ============================================================================
-- Practical 14: TCL (Transaction Control Language) and DCL (Data Control Language)
-- Database: Oracle
-- ============================================================================
-- This practical demonstrates:
-- 1. TCL Commands: COMMIT, ROLLBACK, SAVEPOINT
-- 2. DCL Commands: GRANT, REVOKE, CREATE USER
-- ============================================================================

-- ============================================================================
-- PART 1: TCL COMMANDS (Transaction Control Language)
-- ============================================================================

-- Clean up and create sample table
DROP TABLE accounts CASCADE CONSTRAINTS;
DROP TABLE students CASCADE CONSTRAINTS;

-- Create accounts table for banking example
CREATE TABLE accounts (
    account_id      NUMBER(10) PRIMARY KEY,
    account_holder  VARCHAR2(100) NOT NULL,
    balance         NUMBER(12,2) CHECK (balance >= 0),
    account_type    VARCHAR2(20) CHECK (account_type IN ('Savings', 'Current')),
    created_date    DATE DEFAULT SYSDATE
);

-- Create students table for academic example
CREATE TABLE students (
    student_id      NUMBER(10) PRIMARY KEY,
    student_name    VARCHAR2(100) NOT NULL,
    email           VARCHAR2(100) UNIQUE,
    course          VARCHAR2(50),
    semester        NUMBER(2),
    fees_paid       NUMBER(10,2) DEFAULT 0
);

-- Insert initial data
INSERT INTO accounts VALUES (1001, 'Amit Sharma', 50000.00, 'Savings', SYSDATE);
INSERT INTO accounts VALUES (1002, 'Priya Patel', 75000.00, 'Current', SYSDATE);
INSERT INTO accounts VALUES (1003, 'Rahul Kumar', 30000.00, 'Savings', SYSDATE);
INSERT INTO accounts VALUES (1004, 'Sneha Singh', 100000.00, 'Current', SYSDATE);

INSERT INTO students VALUES (101, 'John Doe', 'john@student.edu', 'Computer Science', 4, 50000);
INSERT INTO students VALUES (102, 'Jane Smith', 'jane@student.edu', 'Electronics', 3, 45000);
INSERT INTO students VALUES (103, 'Bob Johnson', 'bob@student.edu', 'Mechanical', 2, 40000);

-- Important: COMMIT the initial data
COMMIT;

-- Display initial state
SELECT '=== Initial Account Balances ===' AS message FROM DUAL;
SELECT * FROM accounts ORDER BY account_id;

-- ============================================================================
-- Example 1: Simple COMMIT
-- ============================================================================

SELECT '=== Example 1: Simple COMMIT ===' AS message FROM DUAL;

-- Update account balance
UPDATE accounts 
SET balance = balance + 5000 
WHERE account_id = 1001;

-- View changes (not yet committed)
SELECT '--- Before COMMIT (session can see changes):' AS message FROM DUAL;
SELECT * FROM accounts WHERE account_id = 1001;

-- Commit the transaction
COMMIT;

-- View committed changes
SELECT '--- After COMMIT (changes permanent):' AS message FROM DUAL;
SELECT * FROM accounts WHERE account_id = 1001;

-- ============================================================================
-- Example 2: Simple ROLLBACK
-- ============================================================================

SELECT '=== Example 2: Simple ROLLBACK ===' AS message FROM DUAL;

-- View current balance
SELECT '--- Before update:' AS message FROM DUAL;
SELECT * FROM accounts WHERE account_id = 1002;

-- Make changes
UPDATE accounts 
SET balance = balance - 10000 
WHERE account_id = 1002;

-- View changes (not yet committed)
SELECT '--- After update (before rollback):' AS message FROM DUAL;
SELECT * FROM accounts WHERE account_id = 1002;

-- Rollback the transaction
ROLLBACK;

-- View after rollback (changes undone)
SELECT '--- After ROLLBACK (changes reverted):' AS message FROM DUAL;
SELECT * FROM accounts WHERE account_id = 1002;

-- ============================================================================
-- Example 3: Bank Transfer Transaction (Atomic Operation)
-- ============================================================================

SELECT '=== Example 3: Bank Transfer (COMMIT) ===' AS message FROM DUAL;

-- View balances before transfer
SELECT '--- Balances before transfer:' AS message FROM DUAL;
SELECT account_id, account_holder, balance 
FROM accounts 
WHERE account_id IN (1001, 1003);

-- Transfer 10,000 from account 1001 to 1003
UPDATE accounts 
SET balance = balance - 10000 
WHERE account_id = 1001;

UPDATE accounts 
SET balance = balance + 10000 
WHERE account_id = 1003;

-- View balances after transfer (before commit)
SELECT '--- Balances after transfer (before commit):' AS message FROM DUAL;
SELECT account_id, account_holder, balance 
FROM accounts 
WHERE account_id IN (1001, 1003);

-- Commit the transaction (make it permanent)
COMMIT;

-- View final balances
SELECT '--- Balances after COMMIT:' AS message FROM DUAL;
SELECT account_id, account_holder, balance 
FROM accounts 
WHERE account_id IN (1001, 1003);

-- ============================================================================
-- Example 4: Failed Transaction with ROLLBACK
-- ============================================================================

SELECT '=== Example 4: Failed Transaction (ROLLBACK) ===' AS message FROM DUAL;

-- Try to transfer more money than available
-- Attempt to transfer 100,000 from account 1003 (only has 40,000)

-- View balances before
SELECT '--- Balances before failed transfer:' AS message FROM DUAL;
SELECT account_id, account_holder, balance 
FROM accounts 
WHERE account_id IN (1003, 1004);

-- Start the transfer
BEGIN
    -- Deduct from source account
    UPDATE accounts 
    SET balance = balance - 100000 
    WHERE account_id = 1003;
    
    -- This will fail due to CHECK constraint (balance >= 0)
    -- In real scenario, you'd check balance first
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Transaction failed and rolled back');
END;
/

-- Alternative: Manual rollback
UPDATE accounts 
SET balance = balance - 50000 
WHERE account_id = 1003;  -- This would violate CHECK constraint

ROLLBACK;  -- Undo the failed transaction

-- View balances after rollback
SELECT '--- Balances after ROLLBACK (unchanged):' AS message FROM DUAL;
SELECT account_id, account_holder, balance 
FROM accounts 
WHERE account_id IN (1003, 1004);

-- ============================================================================
-- Example 5: SAVEPOINT - Multiple Operations with Partial Rollback
-- ============================================================================

SELECT '=== Example 5: SAVEPOINT ===' AS message FROM DUAL;

-- View initial student data
SELECT '--- Initial student data:' AS message FROM DUAL;
SELECT * FROM students ORDER BY student_id;

-- Operation 1: Add a new student
INSERT INTO students VALUES (104, 'Alice Brown', 'alice@student.edu', 'Civil', 1, 35000);
SAVEPOINT after_insert;

-- View after insert
SELECT '--- After INSERT (Savepoint A):' AS message FROM DUAL;
SELECT * FROM students ORDER BY student_id;

-- Operation 2: Update existing student
UPDATE students 
SET fees_paid = fees_paid + 5000 
WHERE student_id = 101;
SAVEPOINT after_update;

-- View after update
SELECT '--- After UPDATE (Savepoint B):' AS message FROM DUAL;
SELECT * FROM students WHERE student_id IN (101, 104);

-- Operation 3: Delete a student
DELETE FROM students WHERE student_id = 103;
SAVEPOINT after_delete;

-- View after delete
SELECT '--- After DELETE (Savepoint C):' AS message FROM DUAL;
SELECT * FROM students ORDER BY student_id;

-- Now rollback to different savepoints

-- Rollback the delete operation only
ROLLBACK TO after_update;

SELECT '--- After ROLLBACK TO after_update (DELETE undone):' AS message FROM DUAL;
SELECT * FROM students ORDER BY student_id;

-- Rollback the update operation as well
ROLLBACK TO after_insert;

SELECT '--- After ROLLBACK TO after_insert (UPDATE also undone):' AS message FROM DUAL;
SELECT * FROM students ORDER BY student_id;

-- Commit only the insert operation
COMMIT;

SELECT '--- After COMMIT (only INSERT remains):' AS message FROM DUAL;
SELECT * FROM students ORDER BY student_id;

-- ============================================================================
-- Example 6: Complex Transaction with Multiple Savepoints
-- ============================================================================

SELECT '=== Example 6: Complex Transaction ===' AS message FROM DUAL;

-- Scenario: Process multiple fee payments

-- Payment 1
UPDATE students SET fees_paid = fees_paid + 10000 WHERE student_id = 101;
SAVEPOINT payment1;
SELECT '--- After Payment 1:' AS message FROM DUAL;
SELECT student_id, student_name, fees_paid FROM students WHERE student_id = 101;

-- Payment 2
UPDATE students SET fees_paid = fees_paid + 8000 WHERE student_id = 102;
SAVEPOINT payment2;
SELECT '--- After Payment 2:' AS message FROM DUAL;
SELECT student_id, student_name, fees_paid FROM students WHERE student_id = 102;

-- Payment 3
UPDATE students SET fees_paid = fees_paid + 7000 WHERE student_id = 104;
SAVEPOINT payment3;
SELECT '--- After Payment 3:' AS message FROM DUAL;
SELECT student_id, student_name, fees_paid FROM students WHERE student_id = 104;

-- Suppose Payment 2 was incorrect, rollback to before Payment 2
ROLLBACK TO payment1;

-- Continue with Payment 3 (corrected)
UPDATE students SET fees_paid = fees_paid + 9000 WHERE student_id = 102;
SAVEPOINT payment2_corrected;

-- Commit all payments
COMMIT;

SELECT '--- Final fees after all payments:' AS message FROM DUAL;
SELECT student_id, student_name, fees_paid FROM students ORDER BY student_id;

-- ============================================================================
-- PART 2: DCL COMMANDS (Data Control Language)
-- ============================================================================
-- Note: DCL commands require appropriate privileges (usually DBA or similar)
-- These examples assume you have the necessary privileges

SELECT '=== DCL Commands (GRANT/REVOKE) ===' AS message FROM DUAL;

-- ============================================================================
-- Example 7: CREATE USER
-- ============================================================================

-- Create new users
-- Note: Requires DBA privileges or CREATE USER system privilege

/*
CREATE USER app_user IDENTIFIED BY password123;
CREATE USER read_only_user IDENTIFIED BY readonly123;
CREATE USER developer IDENTIFIED BY dev123;

-- Grant basic login privilege
GRANT CREATE SESSION TO app_user;
GRANT CREATE SESSION TO read_only_user;
GRANT CREATE SESSION TO developer;

SELECT '--- Users created and granted CREATE SESSION privilege ---' AS message FROM DUAL;
*/

-- ============================================================================
-- Example 8: GRANT System Privileges
-- ============================================================================

/*
-- Grant table creation privileges
GRANT CREATE TABLE TO app_user;
GRANT CREATE VIEW TO app_user;
GRANT CREATE SEQUENCE TO app_user;

-- Grant with resource quota
ALTER USER app_user QUOTA 100M ON USERS;

SELECT '--- System privileges granted to app_user ---' AS message FROM DUAL;
*/

-- ============================================================================
-- Example 9: GRANT Object Privileges
-- ============================================================================

-- Grant SELECT privilege on accounts table
-- GRANT SELECT ON accounts TO read_only_user;

-- Grant multiple privileges to app_user
-- GRANT SELECT, INSERT, UPDATE, DELETE ON accounts TO app_user;
-- GRANT SELECT, INSERT, UPDATE ON students TO app_user;

-- Grant ALL privileges
-- GRANT ALL PRIVILEGES ON accounts TO developer;

-- Grant with GRANT OPTION (allows user to grant to others)
-- GRANT SELECT ON accounts TO app_user WITH GRANT OPTION;

SELECT '--- Object privileges granted ---' AS message FROM DUAL;

-- ============================================================================
-- Example 10: REVOKE Privileges
-- ============================================================================

-- Revoke specific privilege
-- REVOKE DELETE ON accounts FROM app_user;

-- Revoke all privileges
-- REVOKE ALL PRIVILEGES ON accounts FROM developer;

-- Revoke system privilege
-- REVOKE CREATE TABLE FROM app_user;

SELECT '--- Privileges revoked ---' AS message FROM DUAL;

-- ============================================================================
-- Example 11: Role-Based Access Control
-- ============================================================================

/*
-- Create custom role
CREATE ROLE app_role;

-- Grant privileges to role
GRANT SELECT, INSERT, UPDATE ON accounts TO app_role;
GRANT SELECT, INSERT, UPDATE ON students TO app_role;

-- Grant role to users
GRANT app_role TO app_user;
GRANT app_role TO developer;

SELECT '--- Role-based privileges granted ---' AS message FROM DUAL;

-- Revoke role
-- REVOKE app_role FROM developer;

-- Drop role
-- DROP ROLE app_role;
*/

-- ============================================================================
-- Example 12: View Privileges
-- ============================================================================

-- View privileges granted to current user
SELECT '--- Current user privileges ---' AS message FROM DUAL;

SELECT privilege 
FROM user_sys_privs 
ORDER BY privilege;

-- View table privileges
SELECT table_name, privilege 
FROM user_tab_privs 
WHERE table_name IN ('ACCOUNTS', 'STUDENTS')
ORDER BY table_name, privilege;

-- View role privileges
SELECT granted_role 
FROM user_role_privs
ORDER BY granted_role;

-- ============================================================================
-- Best Practices
-- ============================================================================

/*
TRANSACTION BEST PRACTICES:
1. Keep transactions short
2. Use savepoints for complex operations
3. Always handle exceptions with proper rollback
4. Don't mix DDL and DML in same transaction (DDL auto-commits in Oracle)
5. Use explicit COMMIT after successful operations
6. Test transaction logic thoroughly

PRIVILEGE BEST PRACTICES:
1. Follow principle of least privilege
2. Use roles instead of granting privileges directly to users
3. Regularly audit user privileges
4. Revoke unused privileges
5. Document privilege grants
6. Use views to restrict column access
7. Consider using Oracle Label Security for sensitive data
*/

-- ============================================================================
-- Cleanup Examples (commented out)
-- ============================================================================

-- DROP USER app_user CASCADE;
-- DROP USER read_only_user CASCADE;
-- DROP USER developer CASCADE;

-- DROP TABLE accounts CASCADE CONSTRAINTS;
-- DROP TABLE students CASCADE CONSTRAINTS;

SELECT '=== Practical 14 completed ===' AS message FROM DUAL;
