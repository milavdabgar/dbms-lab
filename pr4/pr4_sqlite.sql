-- Practical No. 4: Implement SQL queries to perform various DML Commands on HRMS Database
-- SQLite Version

-- Note: Ensure hrms_schema_sqlite.sql has been run to create the necessary tables before running these DML commands.
-- Please note constraints (foreign keys) require parent records to exist before child records can be inserted.

-- Enable foreign key support (required for SQLite)
PRAGMA foreign_keys = ON;

-- =============================================================================
-- 1. INSERT Data into various tables
-- =============================================================================

-- Insert into REGIONS
INSERT INTO REGIONS (REGION_ID, REGION_NAME) VALUES (1, 'Europe');
INSERT INTO REGIONS (REGION_ID, REGION_NAME) VALUES (2, 'Americas');
INSERT INTO REGIONS (REGION_ID, REGION_NAME) VALUES (3, 'Asia');

-- Insert into COUNTRIES (must reference existing REGION_ID)
INSERT INTO COUNTRIES (COUNTRY_ID, COUNTRY_NAME, REGION_ID) VALUES ('UK', 'United Kingdom', 1);
INSERT INTO COUNTRIES (COUNTRY_ID, COUNTRY_NAME, REGION_ID) VALUES ('US', 'United States', 2);
INSERT INTO COUNTRIES (COUNTRY_ID, COUNTRY_NAME, REGION_ID) VALUES ('IN', 'India', 3);

-- Insert into LOCATIONS (must reference existing COUNTRY_ID)
INSERT INTO LOCATIONS (LOCATION_ID, STREET_ADDRESS, POSTAL_CODE, CITY, STATE_PROVINCE, COUNTRY_ID) 
VALUES (1000, '1297 Via Cola di Rie', '00989', 'Roma', NULL, 'UK');

INSERT INTO LOCATIONS (LOCATION_ID, STREET_ADDRESS, POSTAL_CODE, CITY, STATE_PROVINCE, COUNTRY_ID) 
VALUES (2000, '2004 Charade Rd', '98199', 'Seattle', 'Washington', 'US');

-- Insert into DEPARTMENTS (must reference existing LOCATION_ID, MANAGER_ID can be NULL initially)
INSERT INTO DEPARTMENTS (DEPARTMENT_ID, DEPARTMENT_NAME, MANAGER_ID, LOCATION_ID) 
VALUES (10, 'Administration', NULL, 1000);

INSERT INTO DEPARTMENTS (DEPARTMENT_ID, DEPARTMENT_NAME, MANAGER_ID, LOCATION_ID) 
VALUES (20, 'Marketing', NULL, 2000);

INSERT INTO DEPARTMENTS (DEPARTMENT_ID, DEPARTMENT_NAME, MANAGER_ID, LOCATION_ID) 
VALUES (30, 'Purchasing', NULL, 1000);

-- Insert into JOBS
INSERT INTO JOBS (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY) 
VALUES ('AD_ASST', 'Administration Assistant', 3000, 6000);

INSERT INTO JOBS (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY) 
VALUES ('MK_MAN', 'Marketing Manager', 9000, 15000);

INSERT INTO JOBS (JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY) 
VALUES ('PU_CLERK', 'Purchasing Clerk', 2500, 5500);

-- Insert into EMPLOYEES (must reference existing JOB_ID and DEPARTMENT_ID)
-- Note: SQLite uses date format 'YYYY-MM-DD' instead of Oracle's TO_DATE function
INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID) 
VALUES (200, 'Jennifer', 'Whalen', 'JWHALEN', '515.123.4444', '2003-09-17', 'AD_ASST', 4400, NULL, NULL, 10);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID) 
VALUES (201, 'Michael', 'Hartstein', 'MHARTSTE', '515.123.5555', '2004-02-17', 'MK_MAN', 13000, NULL, NULL, 20);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID) 
VALUES (202, 'Pat', 'Fay', 'PFAY', '603.123.6666', '2005-08-17', 'MK_MAN', 6000, NULL, 201, 20);

INSERT INTO EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID) 
VALUES (203, 'Susan', 'Mavris', 'SMAVRIS', '515.123.7777', '2002-06-07', 'PU_CLERK', 3200, NULL, NULL, 30);

-- Update departments to point to existing employees as managers
UPDATE DEPARTMENTS SET MANAGER_ID = 200 WHERE DEPARTMENT_ID = 10;
UPDATE DEPARTMENTS SET MANAGER_ID = 201 WHERE DEPARTMENT_ID = 20;

-- =============================================================================
-- 2. SELECT Data: Retrieve all fields from EMPLOYEES
-- =============================================================================
SELECT '-- Query 2: SELECT all employees' AS QUERY;
SELECT * FROM EMPLOYEES;

-- =============================================================================
-- 3. SELECT Data with specific columns
-- =============================================================================
SELECT '-- Query 3: SELECT specific columns' AS QUERY;
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY FROM EMPLOYEES;

-- =============================================================================
-- 4. SELECT Data using Logical Operators (AND, OR, NOT)
-- =============================================================================

-- Using AND operator
SELECT '-- Query 4a: SELECT with AND operator' AS QUERY;
SELECT * FROM EMPLOYEES WHERE SALARY > 4000 AND DEPARTMENT_ID = 10;

-- Using OR operator
SELECT '-- Query 4b: SELECT with OR operator' AS QUERY;
SELECT * FROM DEPARTMENTS WHERE DEPARTMENT_ID = 10 OR LOCATION_ID = 2000;

-- Using NOT operator
SELECT '-- Query 4c: SELECT with NOT operator' AS QUERY;
SELECT * FROM EMPLOYEES WHERE NOT (SALARY > 5000);

-- =============================================================================
-- 5. SELECT Data using Comparison Operators (BETWEEN, IN, LIKE)
-- =============================================================================

-- Using BETWEEN operator
SELECT '-- Query 5a: SELECT with BETWEEN' AS QUERY;
SELECT * FROM EMPLOYEES WHERE SALARY BETWEEN 3000 AND 5000;

-- Using IN operator
SELECT '-- Query 5b: SELECT with IN' AS QUERY;
SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID IN (10, 20, 30);

-- Using LIKE operator (pattern matching)
SELECT '-- Query 5c: SELECT with LIKE' AS QUERY;
SELECT * FROM EMPLOYEES WHERE LAST_NAME LIKE 'W%';
SELECT * FROM EMPLOYEES WHERE LAST_NAME LIKE '%a%';

-- =============================================================================
-- 6. UPDATE Data: Change existing values
-- =============================================================================
SELECT '-- Query 6: UPDATE operation' AS QUERY;

-- Update single employee's salary and phone
UPDATE EMPLOYEES 
SET SALARY = 4500, PHONE_NUMBER = '515.123.9999' 
WHERE EMPLOYEE_ID = 200;

-- Verify the update
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY, PHONE_NUMBER 
FROM EMPLOYEES 
WHERE EMPLOYEE_ID = 200;

-- Update multiple employees (give raise to Marketing department)
UPDATE EMPLOYEES 
SET SALARY = SALARY * 1.10 
WHERE DEPARTMENT_ID = 20;

-- Verify the update
SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY 
FROM EMPLOYEES 
WHERE DEPARTMENT_ID = 20;

-- =============================================================================
-- 7. DELETE Data: Remove rows from tables
-- =============================================================================
SELECT '-- Query 7: DELETE operations' AS QUERY;

-- Must handle foreign key dependencies before deletion
-- First, remove manager references that point to employees we want to delete
UPDATE DEPARTMENTS SET MANAGER_ID = NULL WHERE MANAGER_ID = 200;

-- Remove employee reporting to the employee we want to delete
UPDATE EMPLOYEES SET MANAGER_ID = NULL WHERE MANAGER_ID = 200;

-- Now delete the employee
DELETE FROM EMPLOYEES WHERE EMPLOYEE_ID = 200;

-- Verify deletion
SELECT '-- After deleting employee 200:' AS QUERY;
SELECT * FROM EMPLOYEES;

-- Delete a job (only if no employees reference it)
DELETE FROM JOBS WHERE JOB_ID = 'AD_ASST';

-- Delete a department (must ensure no employees are in it and no job history references it)
DELETE FROM DEPARTMENTS WHERE DEPARTMENT_ID = 10;

-- Delete a location (must ensure no departments reference it)
DELETE FROM LOCATIONS WHERE LOCATION_ID = 1000;

-- Final state of all tables
SELECT '-- Final state of REGIONS:' AS QUERY;
SELECT * FROM REGIONS;

SELECT '-- Final state of COUNTRIES:' AS QUERY;
SELECT * FROM COUNTRIES;

SELECT '-- Final state of LOCATIONS:' AS QUERY;
SELECT * FROM LOCATIONS;

SELECT '-- Final state of DEPARTMENTS:' AS QUERY;
SELECT * FROM DEPARTMENTS;

SELECT '-- Final state of JOBS:' AS QUERY;
SELECT * FROM JOBS;

SELECT '-- Final state of EMPLOYEES:' AS QUERY;
SELECT * FROM EMPLOYEES;
