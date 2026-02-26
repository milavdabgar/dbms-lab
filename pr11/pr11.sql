-- ================================================================================
-- Practical No. 11: User Management (Oracle Version)
-- ================================================================================
-- This practical demonstrates user management and DCL commands in Oracle:
-- CREATE USER, GRANT, REVOKE, ALTER USER, CREATE ROLE
-- ================================================================================
-- NOTE: This practical is Oracle-ONLY. SQLite does not have user management.
-- ================================================================================

SET PAGESIZE 100
SET LINESIZE 200
COL USERNAME FORMAT A20
COL GRANTED_ROLE FORMAT A20
COL PRIVILEGE FORMAT A30
COL GRANTEE FORMAT A20

-- ================================================================================
-- PART 1: CREATE DATABASE and TABLESPACE (Administrative setup)
-- ================================================================================

PROMPT ========================================
PROMPT Part 1: Database and Tablespace Setup
PROMPT ========================================

-- Note: These commands typically require SYSDBA privileges
-- Uncomment if you have appropriate privileges

/*
-- Create tablespace for user data
CREATE TABLESPACE te_cs 
DATAFILE 'C:\oraclexe\app\oracle\product\10.2.0\server\usr.dbf' 
SIZE 50M
AUTOEXTEND ON NEXT 10M MAXSIZE 200M;

PROMPT Tablespace created successfully!
*/

-- ================================================================================
-- PART 2: CREATE USER
-- ================================================================================

PROMPT ========================================
PROMPT Part 2: Create Users
PROMPT ========================================

-- Create first user: james
CREATE USER james IDENTIFIED BY bob123;

PROMPT User 'james' created successfully!

-- Create second user: steve
CREATE USER steve IDENTIFIED BY steve123;

PROMPT User 'steve' created successfully!

-- At this point, users exist but have NO privileges
-- They cannot even login

-- ================================================================================
-- PART 3: GRANT SYSTEM PRIVILEGES
-- ================================================================================

PROMPT ========================================
PROMPT Part 3: Grant System Privileges
PROMPT ========================================

-- Grant basic connection privileges to james
GRANT CREATE SESSION TO james;
GRANT CREATE TABLE TO james;
GRANT CREATE VIEW TO james;

PROMPT System privileges granted to 'james'!

-- Grant more comprehensive privileges to steve
GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW, CREATE SEQUENCE TO steve;

PROMPT System privileges granted to 'steve'!

-- Grant connect and resource roles (convenient privilege bundles)
GRANT CONNECT, RESOURCE TO james;

PROMPT CONNECT and RESOURCE roles granted to 'james'!

-- ================================================================================
-- PART 4: GRANT OBJECT PRIVILEGES
-- ================================================================================

PROMPT ========================================
PROMPT Part 4: Grant Object Privileges
PROMPT ========================================

-- Grant SELECT and INSERT on HR.EMPLOYEES table to james
GRANT SELECT, INSERT ON HR.EMPLOYEES TO james;

PROMPT Object privileges (SELECT, INSERT) on HR.EMPLOYEES granted to 'james'!

-- Grant SELECT and UPDATE on specific columns
GRANT SELECT, UPDATE (FIRST_NAME, LAST_NAME, EMAIL) ON HR.EMPLOYEES TO james;

PROMPT Column-specific privileges granted to 'james'!

-- ================================================================================
-- EXERCISE 1: Grant All Privileges on employees table
-- ================================================================================

PROMPT ========================================
PROMPT Exercise 1: Grant All Privileges
PROMPT ========================================

-- Grant all object privileges on employees-like table to another user
-- Note: Using HR.EMPLOYEES as example
GRANT ALL ON HR.EMPLOYEES TO steve;

PROMPT All privileges on HR.EMPLOYEES granted to 'steve'!

-- ================================================================================
-- EXERCISE 2: Grant Some Privileges
-- ================================================================================

PROMPT ========================================
PROMPT Exercise 2: Grant Some Privileges
PROMPT ========================================

-- Grant specific privileges (not all) on departments table
GRANT SELECT, INSERT, UPDATE ON HR.DEPARTMENTS TO james;

PROMPT Specific privileges (SELECT, INSERT, UPDATE) on HR.DEPARTMENTS granted to 'james'!

-- ================================================================================
-- PART 5: GRANT WITH GRANT OPTION
-- ================================================================================

PROMPT ========================================
PROMPT Part 5: Grant with GRANT OPTION
PROMPT ========================================

-- Allow james to grant his privileges to others
GRANT SELECT, INSERT ON HR.EMPLOYEES TO james WITH GRANT OPTION;

PROMPT Privileges granted to 'james' WITH GRANT OPTION!
PROMPT Now 'james' can grant these privileges to other users!

-- ================================================================================
-- PART 6: CREATE ROLE
-- ================================================================================

PROMPT ========================================
PROMPT Part 6: Create and Use Roles
PROMPT ========================================

-- Create a custom role
CREATE ROLE custom_role;

PROMPT Role 'custom_role' created!

-- Grant privileges to the role
GRANT CREATE TABLE, CREATE VIEW TO custom_role;
GRANT SELECT, INSERT ON HR.EMPLOYEES TO custom_role;

PROMPT Privileges granted to 'custom_role'!

-- Assign role to users
GRANT custom_role TO james, steve;

PROMPT Role 'custom_role' granted to 'james' and 'steve'!

-- ================================================================================
-- PART 7: ALTER USER (Change Password)
-- ================================================================================

PROMPT ========================================
PROMPT Part 7: Change User Password
PROMPT ========================================

-- Change password for user james
ALTER USER james IDENTIFIED BY sam456;

PROMPT Password for 'james' changed successfully!

-- ================================================================================
-- PART 8: REVOKE PRIVILEGES
-- ================================================================================

PROMPT ========================================
PROMPT Part 8: Revoke Privileges
PROMPT ========================================

-- Revoke system privileges
REVOKE CREATE TABLE FROM james;

PROMPT CREATE TABLE privilege revoked from 'james'!

-- ================================================================================
-- EXERCISE 4: Revoke All Privileges
-- ================================================================================

PROMPT ========================================
PROMPT Exercise 4: Revoke All Privileges
PROMPT ========================================

-- Revoke all object privileges
REVOKE ALL ON HR.EMPLOYEES FROM steve;

PROMPT All privileges on HR.EMPLOYEES revoked from 'steve'!

-- ================================================================================
-- EXERCISE 5: Revoke Some Privileges
-- ================================================================================

PROMPT ========================================
PROMPT Exercise 5: Revoke Some Privileges
PROMPT ========================================

-- Revoke specific privileges
REVOKE INSERT, UPDATE ON HR.DEPARTMENTS FROM james;

PROMPT Specific privileges (INSERT, UPDATE) on HR.DEPARTMENTS revoked from 'james'!

-- ================================================================================
-- PART 9: REVOKE ROLE
-- ================================================================================

PROMPT ========================================
PROMPT Part 9: Revoke Role
PROMPT ========================================

-- Revoke role from user
REVOKE custom_role FROM steve;

PROMPT Role 'custom_role' revoked from 'steve'!

-- ================================================================================
-- PART 10: VIEW USER PRIVILEGES
-- ================================================================================

PROMPT ========================================
PROMPT Part 10: View User Privileges
PROMPT ========================================

-- View system privileges
SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE IN ('JAMES', 'STEVE');

PROMPT
PROMPT System privileges for JAMES and STEVE:

-- View object privileges
SELECT GRANTEE, TABLE_NAME, PRIVILEGE
FROM DBA_TAB_PRIVS
WHERE GRANTEE IN ('JAMES', 'STEVE')
ORDER BY GRANTEE, TABLE_NAME;

PROMPT
PROMPT Object privileges for JAMES and STEVE:

-- View role assignments
SELECT GRANTEE, GRANTED_ROLE
FROM DBA_ROLE_PRIVS
WHERE GRANTEE IN ('JAMES', 'STEVE')
ORDER BY GRANTEE;

-- ================================================================================
-- PART 11: DROP USER
-- ================================================================================

PROMPT ========================================
PROMPT Part 11: Drop Users (Cleanup)
PROMPT ========================================

-- Drop users (commented out by default to preserve for practice)
-- Uncomment these lines to actually drop the users

/*
DROP USER james CASCADE;
PROMPT User 'james' dropped successfully!

DROP USER steve CASCADE;
PROMPT User 'steve' dropped successfully!

DROP ROLE custom_role;
PROMPT Role 'custom_role' dropped successfully!
*/

-- ================================================================================
-- SUMMARY OF DCL COMMANDS
-- ================================================================================

PROMPT ========================================
PROMPT DCL COMMANDS SUMMARY
PROMPT ========================================
PROMPT 
PROMPT CREATE USER: Creates a new database user
PROMPT GRANT: Grants privileges/roles to users
PROMPT REVOKE: Removes privileges/roles from users
PROMPT ALTER USER: Modifies user properties (password, etc.)
PROMPT DROP USER: Removes user from database
PROMPT CREATE ROLE: Creates a named group of privileges
PROMPT 
PROMPT PRIVILEGE TYPES:
PROMPT 1. System Privileges: CREATE SESSION, CREATE TABLE, CREATE VIEW, etc.
PROMPT 2. Object Privileges: SELECT, INSERT, UPDATE, DELETE, ALTER, INDEX
PROMPT 3. Roles: Predefined collections of privileges (CONNECT, RESOURCE, DBA)
PROMPT 
PROMPT IMPORTANT OPTIONS:
PROMPT WITH GRANT OPTION: Allows grantee to grant privileges to others
PROMPT WITH ADMIN OPTION: For system privileges, similar to GRANT OPTION
PROMPT CASCADE: Used with DROP USER to remove user's objects
PROMPT PUBLIC: Grants privilege to all users

-- ================================================================================
-- ADDITIONAL EXAMPLES
-- ================================================================================

PROMPT ========================================
PROMPT Additional Examples
PROMPT ========================================

-- Example 1: Grant to PUBLIC (all users)
-- GRANT SELECT ON HR.DEPARTMENTS TO PUBLIC;

-- Example 2: Create user with tablespace quota
-- CREATE USER john IDENTIFIED BY john123
-- DEFAULT TABLESPACE users
-- QUOTA 50M ON users;

-- Example 3: Create user with profile
-- CREATE PROFILE dev_profile LIMIT
--   SESSIONS_PER_USER 3
--   CPU_PER_SESSION 10000
--   CONNECT_TIME 45;
-- 
-- CREATE USER developer IDENTIFIED BY dev123
-- PROFILE dev_profile;

-- Example 4: Lock/Unlock user account
-- ALTER USER james ACCOUNT LOCK;
-- ALTER USER james ACCOUNT UNLOCK;

-- Example 5: Expire password (force change on next login)
-- ALTER USER james PASSWORD EXPIRE;

-- ================================================================================
-- End of Practical 11 (Oracle Version)
-- ================================================================================
