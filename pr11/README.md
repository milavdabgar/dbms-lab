# Practical 11: User Management (CREATE USER, GRANT, REVOKE)

Implementation of User Management and DCL commands - **Oracle Only**.

## Files

- `pr11.sql` - Oracle version
- **No SQLite version** - SQLite does not have user management

## ⚠️ Important Note

**This practical is Oracle-exclusive.** SQLite does not have a user management system. In SQLite:

- There are no users or roles
- There is no authentication system
- File-level permissions (OS-level) control access
- No GRANT or REVOKE commands
- Everyone who can access the database file has full access

If you're using SQLite for learning, you can:

1. Study the Oracle syntax for understanding concepts
2. Practice on Oracle Database (XE recommended for students)
3. Use MySQL/PostgreSQL as alternatives (both support user management)

## User Management Commands

### 1. CREATE USER

Creates a new database user account.

```sql
CREATE USER username IDENTIFIED BY password;

-- With tablespace (Oracle):
CREATE USER username IDENTIFIED BY password
DEFAULT TABLESPACE users
QUOTA 50M ON users;
```

### 2. ALTER USER

Modifies user properties.

```sql
-- Change password:
ALTER USER username IDENTIFIED BY new_password;

-- Lock account:
ALTER USER username ACCOUNT LOCK;

-- Unlock account:
ALTER USER username ACCOUNT UNLOCK;

-- Expire password (force change on next login):
ALTER USER username PASSWORD EXPIRE;
```

### 3. DROP USER

Removes a user from the database.

```sql
DROP USER username;

-- Drop user and all owned objects:
DROP USER username CASCADE;
```

## DCL Commands

### GRANT Command

Grants privileges or roles to users.

**System Privileges:**

```sql
GRANT CREATE SESSION TO username;          -- Allow login
GRANT CREATE TABLE TO username;            -- Allow creating tables
GRANT CREATE VIEW TO username;             -- Allow creating views
GRANT CREATE SEQUENCE TO username;         -- Allow creating sequences

-- Multiple privileges at once:
GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW TO username;
```

**Object Privileges:**

```sql
-- Grant on table:
GRANT SELECT, INSERT ON table_name TO username;
GRANT ALL ON table_name TO username;

-- Grant on specific columns:
GRANT UPDATE (column1, column2) ON table_name TO username;

-- Allow user to grant privileges to others:
GRANT SELECT ON table_name TO username WITH GRANT OPTION;
```

**Roles:**

```sql
-- Grant predefined roles:
GRANT CONNECT TO username;                 -- Basic connection privileges
GRANT RESOURCE TO username;                -- Create objects in own schema
GRANT DBA TO username;                     -- Full admin privileges

-- Grant to all users:
GRANT SELECT ON table_name TO PUBLIC;
```

### REVOKE Command

Removes privileges or roles from users.

**System Privileges:**

```sql
REVOKE CREATE TABLE FROM username;
REVOKE CREATE SESSION, CREATE VIEW FROM username;
```

**Object Privileges:**

```sql
REVOKE SELECT, INSERT ON table_name FROM username;
REVOKE ALL ON table_name FROM username;

-- Revoke column-specific privileges:
REVOKE UPDATE (column1, column2) ON table_name FROM username;
```

**Roles:**

```sql
REVOKE CONNECT FROM username;
REVOKE RESOURCE FROM username;
```

## Roles

### What is a Role?

A **role** is a named group of related privileges. Instead of granting multiple privileges individually to each user, you can:

1. Create a role
2. Grant privileges to the role
3. Grant the role to users

### Creating and Using Roles

```sql
-- Create custom role:
CREATE ROLE developer_role;

-- Grant privileges to role:
GRANT CREATE TABLE, CREATE VIEW TO developer_role;
GRANT SELECT, INSERT, UPDATE ON employees TO developer_role;

-- Grant role to users:
GRANT developer_role TO john, jane, jack;

-- Revoke role from user:
REVOKE developer_role FROM jack;

-- Drop role:
DROP ROLE developer_role;
```

### Predefined Oracle Roles

| Role | Description |
|------|-------------|
| CONNECT | Basic connection and session creation |
| RESOURCE | Create tables, sequences, procedures in own schema |
| DBA | Full database administrator privileges |
| SELECT_CATALOG_ROLE | Query data dictionary views |
| EXECUTE_CATALOG_ROLE | Execute catalog procedures |

## Privilege Types

### System Privileges

Control database-level operations.

| Privilege | Allows User To |
|-----------|----------------|
| CREATE SESSION | Connect to database |
| CREATE TABLE | Create tables in own schema |
| CREATE ANY TABLE | Create tables in any schema |
| DROP TABLE | Drop tables in own schema |
| DROP ANY TABLE | Drop tables in any schema |
| CREATE VIEW | Create views |
| CREATE SEQUENCE | Create sequences |
| CREATE PROCEDURE | Create stored procedures |
| CREATE USER | Create other users (admin) |
| GRANT ANY PRIVILEGE | Grant any system privilege |

### Object Privileges

Control access to specific database objects.

| Privilege | Object Types | Description |
|-----------|--------------|-------------|
| SELECT | Tables, Views, Sequences | Query data |
| INSERT | Tables, Views | Add rows |
| UPDATE | Tables, Views | Modify rows |
| DELETE | Tables, Views | Remove rows |
| ALTER | Tables, Sequences | Modify structure |
| INDEX | Tables | Create indexes |
| REFERENCES | Tables | Create foreign keys |
| EXECUTE | Procedures, Functions | Run code |

## Lab Manual Exercises

### Exercise 1: Create User and Grant Basic Access

```sql
-- Create user:
CREATE USER james IDENTIFIED BY bob123;

-- Grant connection and table creation:
GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW TO james;
```

### Exercise 2: Grant All Privileges on Employees Table

```sql
GRANT ALL ON employees TO james;
```

### Exercise 3: Grant Some Privileges on Departments Table

```sql
GRANT SELECT, INSERT, UPDATE ON departments TO james;
```

### Exercise 4: Revoke All Privileges

```sql
REVOKE ALL ON employees FROM james;
```

### Exercise 5: Revoke Some Privileges

```sql
REVOKE INSERT, UPDATE ON departments FROM james;
```

## Viewing Privileges

### View System Privileges

```sql
-- Your own privileges:
SELECT * FROM USER_SYS_PRIVS;

-- All users (DBA only):
SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE = 'JAMES';
```

### View Object Privileges

```sql
-- Your own privileges:
SELECT * FROM USER_TAB_PRIVS;

-- All users (DBA only):
SELECT GRANTEE, TABLE_NAME, PRIVILEGE
FROM DBA_TAB_PRIVS
WHERE GRANTEE = 'JAMES';
```

### View Role Assignments

```sql
-- Your own roles:
SELECT * FROM USER_ROLE_PRIVS;

-- All users (DBA only):
SELECT GRANTEE, GRANTED_ROLE
FROM DBA_ROLE_PRIVS
WHERE GRANTEE = 'JAMES';
```

## Usage

### Oracle

```bash
# Connect as admin (SYSDBA):
sqlplus sys/password@database as sysdba

# Run script:
@pr11.sql

# Connect as created user:
sqlplus james/bob123@database
```

## Important Notes

1. **SYSDBA Privileges Required:** Creating users typically requires SYSTEM or SYSDBA privileges
2. **CASCADE Option:** When dropping users, use CASCADE to also drop their objects
3. **WITH GRANT OPTION:** Allows users to grant their privileges to others
4. **PUBLIC:** Special username representing all users in the database
5. **Default Roles:** CONNECT and RESOURCE are commonly used for application users
6. **Password Security:** Use strong passwords and change them regularly
7. **Least Privilege Principle:** Grant only the minimum privileges needed

## Alternatives to SQLite

If you need user management for learning:

### MySQL

```sql
-- Similar syntax to Oracle:
CREATE USER 'username'@'localhost' IDENTIFIED BY 'password';
GRANT SELECT, INSERT ON database.table TO 'username'@'localhost';
REVOKE SELECT ON database.table FROM 'username'@'localhost';
DROP USER 'username'@'localhost';
```

### PostgreSQL

```sql
-- Similar conceptual model:
CREATE USER username WITH PASSWORD 'password';
GRANT SELECT, INSERT ON table TO username;
REVOKE SELECT ON table FROM username;
DROP USER username;
```

## Troubleshooting

### "insufficient privileges"

- Connect with a user that has GRANT privileges
- For creating users, need CREATE USER privilege or SYSDBA
- For granting on objects, must be object owner or have GRANT OPTION

### "user does not exist"

- Check spelling and case (Oracle stores usernames in uppercase)
- Verify user was created successfully
- Query DBA_USERS to list all users

### "cannot drop user - user is currently connected"

- Disconnect all sessions for that user first
- Or use `DROP USER username CASCADE` with admin privileges

### "ORA-01031: insufficient privileges" (when trying to connect)

- User needs at least CREATE SESSION privilege
- Grant CONNECT role for basic access
