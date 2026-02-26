#!/bin/bash
################################################################################
# DBMS Lab - Quick Test Script for Linux/macOS
################################################################################
# This script tests SQLite versions of Practicals 4, 5, and 6
# Compatible with Linux (all distros) and macOS (Intel & Apple Silicon)
################################################################################

set -e  # Exit on error

echo "========================================================================"
echo " DBMS Lab - Testing SQLite Scripts on $(uname -s)"
echo "========================================================================"
echo ""

# Check if SQLite is installed
if ! command -v sqlite3 &> /dev/null; then
    echo "[ERROR] SQLite not found!"
    echo ""
    echo "Installation instructions:"
    echo "  macOS:  brew install sqlite"
    echo "  Ubuntu: sudo apt install sqlite3"
    echo "  Fedora: sudo dnf install sqlite"
    echo "  Arch:   sudo pacman -S sqlite"
    exit 1
fi

echo "[OK] SQLite found:"
sqlite3 --version
echo ""

################################################################################
echo "Testing Practical 4: DML Commands"
echo "========================================================================"

cd pr4
echo "Creating HRMS database schema..."
sqlite3 test_hrms.db < hrms_schema_sqlite.sql

echo "Running DML commands..."
sqlite3 test_hrms.db < pr4_sqlite.sql > pr4_output.txt

echo ""
echo "[DONE] Practical 4 tested. Check pr4_output.txt for results."
echo "Sample query result:"
sqlite3 test_hrms.db "PRAGMA foreign_keys=ON; SELECT COUNT(*) as 'Total Employees' FROM EMPLOYEES;"
cd ..

echo ""
################################################################################
echo "Testing Practical 5: Date Functions"
echo "========================================================================"

echo "Running date function queries..."
sqlite3 test_date_functions.db < pr5/pr5_sqlite.sql > pr5_output.txt

echo ""
echo "[DONE] Practical 5 tested. Check pr5_output.txt for results."
echo "Sample query result:"
sqlite3 test_date_functions.db "SELECT date('now') AS 'Current Date';"

echo ""
################################################################################
echo "Testing Practical 6: Numeric and Character Functions"
echo "========================================================================"

echo "Running numeric and character function queries..."
sqlite3 test_functions.db < pr6/pr6_sqlite.sql > pr6_output.txt

echo ""
echo "[DONE] Practical 6 tested. Check pr6_output.txt for results."
echo "Sample query result:"
sqlite3 test_functions.db "SELECT UPPER('hello') AS 'Uppercase';"

echo ""
################################################################################
echo " All Tests Completed Successfully!"
echo "========================================================================"
echo ""
echo "Output files created:"
echo "  - pr4/pr4_output.txt"
echo "  - pr5_output.txt"
echo "  - pr6_output.txt"
echo ""
echo "Test databases created:"
echo "  - pr4/test_hrms.db"
echo "  - test_date_functions.db"
echo "  - test_functions.db"
echo ""
echo "To clean up test files, run:"
echo "  rm -f pr4/test_hrms.db pr4/pr4_output.txt test_*.db *_output.txt"
echo ""
################################################################################
echo " Ready for Oracle Testing!"
echo "========================================================================"
echo ""
echo "To test Oracle versions:"
echo "  1. Ensure Oracle Database is installed and running"
echo "  2. Connect: sqlplus username/password@localhost:1521/XE"
echo "  3. Run: @pr4/hrms_schema.sql"
echo "  4. Run: @pr4/pr4.sql"
echo ""
