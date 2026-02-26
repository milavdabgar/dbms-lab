@echo off
REM ========================================================================
REM DBMS Lab - Quick Test Script for Windows 11
REM ========================================================================
REM This script tests SQLite versions of Practicals 4, 5, and 6
REM Compatible with Windows 11, 10, and Windows Server
REM ========================================================================

echo ========================================================================
echo  DBMS Lab - Testing SQLite Scripts on Windows 11
echo ========================================================================
echo.

REM Check if SQLite is installed
where sqlite3 >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] SQLite not found in PATH!
    echo Please install SQLite from: https://www.sqlite.org/download.html
    echo Or add sqlite3.exe location to your PATH.
    pause
    exit /b 1
)

echo [OK] SQLite found: 
sqlite3 --version
echo.

REM ========================================================================
echo Testing Practical 4: DML Commands
echo ========================================================================

cd pr4
echo Creating HRMS database schema...
sqlite3 test_hrms.db < hrms_schema_sqlite.sql

echo Running DML commands...
sqlite3 test_hrms.db < pr4_sqlite.sql > pr4_output.txt

echo.
echo [DONE] Practical 4 tested. Check pr4_output.txt for results.
echo Sample query result:
sqlite3 test_hrms.db "PRAGMA foreign_keys=ON; SELECT COUNT(*) as 'Total Employees' FROM EMPLOYEES;"
cd ..

echo.
echo ========================================================================
echo Testing Practical 5: Date Functions
echo ========================================================================

echo Running date function queries...
sqlite3 test_date_functions.db < pr5/pr5_sqlite.sql > pr5_output.txt

echo.
echo [DONE] Practical 5 tested. Check pr5_output.txt for results.
echo Sample query result:
sqlite3 test_date_functions.db "SELECT date('now') AS 'Current Date';"

echo.
echo ========================================================================
echo Testing Practical 6: Numeric and Character Functions
echo ========================================================================

echo Running numeric and character function queries...
sqlite3 test_functions.db < pr6/pr6_sqlite.sql > pr6_output.txt

echo.
echo [DONE] Practical 6 tested. Check pr6_output.txt for results.
echo Sample query result:
sqlite3 test_functions.db "SELECT UPPER('hello') AS 'Uppercase';"

echo.
echo ========================================================================
echo  All Tests Completed Successfully!
echo ========================================================================
echo.
echo Output files created:
echo   - pr4\pr4_output.txt
echo   - pr5_output.txt
echo   - pr6_output.txt
echo.
echo Test databases created:
echo   - pr4\test_hrms.db
echo   - test_date_functions.db
echo   - test_functions.db
echo.
echo To clean up test files, run:
echo   del /Q pr4\test_hrms.db pr4\pr4_output.txt test_*.db *_output.txt
echo.
echo ========================================================================
echo  Ready for Oracle Testing!
echo ========================================================================
echo.
echo To test Oracle versions:
echo   1. Ensure Oracle Database is installed and running
echo   2. Connect: sqlplus username/password@localhost:1521/XE
echo   3. Run: @pr4\hrms_schema.sql
echo   4. Run: @pr4\pr4.sql
echo.
pause
