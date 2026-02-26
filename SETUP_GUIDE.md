# DBMS Lab - Practicals 4, 5, 6 Setup Guide

Complete setup guide for running SQL practicals on **Windows 11, Linux, and macOS**.

## 📋 Overview

All practicals have **two versions**:
- **Oracle version** - Strictly follows GTU lab manual guidelines
- **SQLite version** - Cross-platform alternative for practice

## 💻 Platform Support

| Platform | Oracle | SQLite | Notes |
|----------|--------|--------|-------|
| Windows 11 | ✅ | ✅ | Oracle Express or Standard Edition |
| Linux | ✅ | ✅ | All distributions supported |
| macOS | ✅ | ✅ | Intel & Apple Silicon (M1/M2/M3) |

---

## 🔧 Software Installation

### Oracle Database Setup

#### Windows 11
1. Download Oracle Database Express Edition (XE) from:
   - https://www.oracle.com/database/technologies/xe-downloads.html
2. Run installer: `OracleXE213_Win64.zip`
3. Set password for SYS and SYSTEM users
4. Add to PATH: `C:\app\oracle\product\21c\dbhomeXE\bin`
5. Verify:
   ```cmd
   sqlplus sys as sysdba
   ```

#### Linux (Ubuntu/Debian)
```bash
# Download Oracle XE RPM
wget https://download.oracle.com/otn-pub/otn_software/db-express/oracle-database-xe-21c-1.0-1.ol8.x86_64.rpm

# Convert RPM to DEB (Ubuntu/Debian)
sudo apt install alien
sudo alien --scripts oracle-database-xe-21c-1.0-1.ol8.x86_64.rpm
sudo dpkg -i oracle-database-xe_21c-2_amd64.deb

# Configure
sudo /etc/init.d/oracle-xe-21c configure

# Add to PATH (.bashrc or .zshrc)
export ORACLE_HOME=/opt/oracle/product/21c/dbhomeXE
export PATH=$PATH:$ORACLE_HOME/bin
```

#### macOS (Intel & Apple Silicon)
```bash
# Option 1: Docker (Recommended for Apple Silicon)
docker pull container-registry.oracle.com/database/express:21.3.0-xe
docker run -d -p 1521:1521 -p 5500:5500 \
  -e ORACLE_PWD=YourPassword123 \
  --name oracle-xe \
  container-registry.oracle.com/database/express:21.3.0-xe

# Option 2: Oracle Instant Client + SQL*Plus (Intel only)
brew tap InstantClientTap/instantclient
brew install instantclient-sqlplus
```

### SQLite Setup

#### Windows 11
1. Download from: https://www.sqlite.org/download.html
   - Get: `sqlite-tools-win32-x86-*.zip`
2. Extract to: `C:\sqlite\`
3. Add to PATH:
   - Windows Search → "Environment Variables"
   - Edit System PATH → Add `C:\sqlite\`
4. Verify:
   ```cmd
   sqlite3 --version
   ```

#### Linux
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install sqlite3

# Fedora/RHEL
sudo dnf install sqlite

# Arch
sudo pacman -S sqlite

# Verify
sqlite3 --version
```

#### macOS
```bash
# SQLite comes pre-installed, or install latest:
brew install sqlite

# Verify
sqlite3 --version
```

---

## 📂 File Structure

```
dbms-lab/
├── pr4/                           # Practical 4: DML Commands
│   ├── hrms_schema.sql           # Oracle schema (HR tables)
│   ├── hrms_schema_sqlite.sql    # SQLite schema
│   ├── pr4.sql                   # Oracle DML queries
│   ├── pr4_sqlite.sql            # SQLite DML queries
│   └── README.md                 # Detailed documentation
├── pr5/                           # Practical 5: Date Functions
│   ├── pr5.sql                   # Oracle date functions
│   ├── pr5_sqlite.sql            # SQLite date functions
│   └── README.md
├── pr6/                           # Practical 6: Numeric & Character Functions
│   ├── pr6.sql                   # Oracle functions
│   ├── pr6_sqlite.sql            # SQLite functions
│   └── README.md
└── manual/
    └── DBMS_DI04032011 LAB MANUAL1.md
```

---

## 🚀 Running the Practicals

### Practical 4: DML Commands

#### Oracle Version (Windows CMD/PowerShell)
```cmd
REM Create database schema
sqlplus username/password@localhost:1521/XE @pr4\hrms_schema.sql

REM Run DML commands
sqlplus username/password@localhost:1521/XE @pr4\pr4.sql
```

#### Oracle Version (Linux/Mac Terminal)
```bash
# Create database schema
sqlplus username/password@localhost:1521/XE @pr4/hrms_schema.sql

# Run DML commands
sqlplus username/password@localhost:1521/XE @pr4/pr4.sql
```

#### SQLite Version (All Platforms)
```bash
# Windows CMD/PowerShell, Linux, macOS - same commands:
cd pr4

# Create schema and run queries
sqlite3 hrms.db < hrms_schema_sqlite.sql
sqlite3 hrms.db < pr4_sqlite.sql

# Or interactively:
sqlite3 hrms.db
sqlite> .read hrms_schema_sqlite.sql
sqlite> .read pr4_sqlite.sql
sqlite> .quit
```

---

### Practical 5: Date Functions

#### Oracle Version
```bash
# Windows
sqlplus username/password@localhost:1521/XE @pr5\pr5.sql

# Linux/macOS
sqlplus username/password@localhost:1521/XE @pr5/pr5.sql
```

#### SQLite Version (All Platforms)
```bash
sqlite3 date_functions.db < pr5/pr5_sqlite.sql

# View output
sqlite3 date_functions.db "SELECT * FROM ..."
```

---

### Practical 6: Numeric & Character Functions

#### Oracle Version
```bash
# Windows
sqlplus username/password@localhost:1521/XE @pr6\pr6.sql

# Linux/macOS
sqlplus username/password@localhost:1521/XE @pr6/pr6.sql
```

#### SQLite Version (All Platforms)
```bash
sqlite3 functions.db < pr6/pr6_sqlite.sql
```

---

## ✅ Verification & Testing

### Test Oracle Installation
```sql
-- Connect to Oracle
sqlplus / as sysdba

-- Check version
SELECT * FROM v$version;

-- Test DUAL table (Oracle-specific)
SELECT 'Hello Oracle' FROM DUAL;
```

### Test SQLite Installation
```bash
# Create test database
sqlite3 test.db

# Inside SQLite shell:
sqlite> CREATE TABLE test(id INTEGER, name TEXT);
sqlite> INSERT INTO test VALUES(1, 'Hello SQLite');
sqlite> SELECT * FROM test;
sqlite> .quit
```

---

## 🔍 Key Differences: Oracle vs SQLite

### Date Handling

| Feature | Oracle | SQLite |
|---------|--------|--------|
| Date function | `TO_DATE('17-SEP-2003', 'DD-MON-YYYY')` | `'2003-09-17'` |
| Current date | `SYSDATE` | `date('now')` |
| Add months | `ADD_MONTHS(date, n)` | `date(date, '+n months')` |
| Format date | `TO_CHAR(date, 'DD-MON-YY')` | `strftime('%d-%m-%Y', date)` |

### Data Types

| Oracle | SQLite | Windows Note |
|--------|--------|--------------|
| NUMBER(p,s) | INTEGER / REAL | Both platforms handle same |
| VARCHAR2(n) | TEXT | No length limit in SQLite |
| DATE | TEXT | Use ISO format: YYYY-MM-DD |
| CHAR(n) | TEXT | SQLite doesn't pad spaces |

### Syntax Differences

```sql
-- Oracle: Uses DUAL table for standalone queries
SELECT ADD_MONTHS(SYSDATE, 3) FROM DUAL;

-- SQLite: No DUAL needed
SELECT date('now', '+3 months');
```

---

## 🎯 Lab Manual Compliance

All Oracle scripts strictly follow GTU lab manual requirements:

### Practical 4 (DML Commands)
✅ INSERT - Both value method and address method  
✅ UPDATE - Selected rows and all rows  
✅ DELETE - Selected rows and all rows  
✅ SELECT - All columns, specific columns, with WHERE  
✅ Logical Operators - AND, OR, NOT  
✅ Comparison Operators - BETWEEN, IN, LIKE  

### Practical 5 (Date Functions)
✅ ADD_MONTHS - Add/subtract months from date  
✅ MONTHS_BETWEEN - Difference between dates  
✅ LAST_DAY - Last day of month  
✅ NEXT_DAY - Next occurrence of weekday  
✅ ROUND - Round date to nearest unit  
✅ TRUNC - Truncate date to specified unit  
✅ SYSDATE - Current system date  

### Practical 6 (Functions)
✅ **Numeric**: ABS, CEIL, FLOOR, POWER, MOD, ROUND, TRUNC, SQRT, EXP  
✅ **Character**: INITCAP, UPPER, LOWER, LENGTH, SUBSTR, INSTR, LTRIM, RTRIM, LPAD, RPAD, REPLACE, TRANSLATE, ASCII  

---

## 🐛 Troubleshooting

### Windows-Specific Issues

#### Oracle: "ORA-12560: TNS:protocol adapter error"
```cmd
REM Check Oracle service is running
net start OracleServiceXE
net start OracleXETNSListener

REM Verify ORACLE_HOME
echo %ORACLE_HOME%
REM Should show: C:\app\oracle\product\21c\dbhomeXE
```

#### SQLite: "sqlite3 is not recognized"
```cmd
REM Add to PATH permanently
setx PATH "%PATH%;C:\sqlite\"

REM Or use full path
C:\sqlite\sqlite3.exe database.db
```

#### File Path Issues on Windows
```cmd
REM Use forward slashes (/) or double backslashes (\\)
sqlplus user/pass@XE @pr4/pr4.sql       ✅ Works
sqlplus user/pass@XE @pr4\pr4.sql       ✅ Works
sqlplus user/pass@XE @pr4\\pr4.sql      ✅ Works

REM For SQLite
sqlite3 db.db < pr5/pr5_sqlite.sql      ✅ Works
sqlite3 db.db < pr5\pr5_sqlite.sql      ✅ Works
```

### Linux/Mac-Specific Issues

#### Oracle: Permission Denied
```bash
# Set execute permissions
chmod +x /opt/oracle/product/21c/dbhomeXE/bin/*

# Check Oracle listener
lsnrctl status
lsnrctl start
```

#### SQLite: Command Not Found
```bash
# Install or check PATH
which sqlite3
sudo apt install sqlite3  # Ubuntu/Debian
brew install sqlite       # macOS
```

### Cross-Platform: Foreign Key Errors

**SQLite:**
```sql
-- MUST enable foreign keys for each connection
PRAGMA foreign_keys = ON;
```

**Check if enabled:**
```sql
PRAGMA foreign_keys;  -- Should return 1
```

---

## 📝 Student Instructions for Windows 11

### Quick Start (Oracle)
1. Open Command Prompt or PowerShell
2. Navigate to lab folder:
   ```cmd
   cd C:\Users\YourName\dbms-lab
   ```
3. Connect to Oracle:
   ```cmd
   sqlplus system/password@localhost:1521/XE
   ```
4. Run practical:
   ```sql
   @pr4\hrms_schema.sql
   @pr4\pr4.sql
   ```

### Quick Start (SQLite)
1. Open Command Prompt or PowerShell
2. Navigate to lab folder:
   ```cmd
   cd C:\Users\YourName\dbms-lab\pr4
   ```
3. Run practical:
   ```cmd
   sqlite3 hrms.db < hrms_schema_sqlite.sql
   sqlite3 hrms.db < pr4_sqlite.sql
   ```

---

## 📚 Additional Resources

### Oracle Documentation
- SQL Language Reference: https://docs.oracle.com/en/database/oracle/oracle-database/21/sqlrf/
- SQL*Plus User's Guide: https://docs.oracle.com/en/database/oracle/oracle-database/21/sqpug/

### SQLite Documentation
- Official Docs: https://www.sqlite.org/docs.html
- SQL Syntax: https://www.sqlite.org/lang.html

### GTU Resources
- Lab Manual: Refer to `manual/DBMS_DI04032011 LAB MANUAL1.md`
- W3Schools SQL: https://www.w3schools.com/sql/
- GeeksforGeeks: https://www.geeksforgeeks.org/sql-tutorial/

---

## ✨ Tips for Students

1. **Always backup** your database before running DELETE/UPDATE
2. **Test queries** with SELECT before using UPDATE/DELETE
3. **Enable foreign keys** in SQLite with `PRAGMA foreign_keys = ON;`
4. **Use transactions** for multiple related operations
5. **Read error messages** carefully - they tell you what went wrong
6. **Check file paths** - Windows uses `\` but `/` also works in most cases

---

## 🆘 Getting Help

If you encounter issues:
1. Check the error message carefully
2. Refer to the README.md in each practical folder
3. Verify software installation (Oracle/SQLite)
4. Check file paths and permissions
5. Ensure foreign key constraints are met
6. Review the troubleshooting section above

---

## 📄 License & Credits

- Lab Manual: GTU Diploma Engineering, Semester IV ICT
- Database: Oracle Database Express Edition / SQLite
- Scripts: Strictly follow lab manual guidelines with cross-platform support
