import sqlite3
import os
import sys

DB_NAME = "pr3.db"
SQL_FILE = "insert_data.sql"

def seed_database():
    print("Seeding Database with Sample Data...")
    
    if not os.path.exists(SQL_FILE):
        print(f"Error: {SQL_FILE} not found.")
        sys.exit(1)
        
    if not os.path.exists(DB_NAME):
        print(f"Error: {DB_NAME} not found. Please run setup_database.py first.")
        sys.exit(1)

    try:
        with open(SQL_FILE, 'r') as f:
            sql_script = f.read()
        
        conn = sqlite3.connect(DB_NAME)
        cursor = conn.cursor()
        cursor.execute("PRAGMA foreign_keys = ON;")
        
        cursor.executescript(sql_script)
        
        conn.commit()
        conn.close()
        print("Success! Sample data inserted.")
        
    except sqlite3.Error as e:
        print(f"SQLite error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    seed_database()
