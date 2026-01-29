import sqlite3
import os
import sys

DB_NAME = "pr3.db"
SQL_FILE = "create_tables.sql"


def create_database():
    print("Setting up Practical 3 Database...")
    
    # Check if SQL file exists
    if not os.path.exists(SQL_FILE):
        print(f"Error: {SQL_FILE} not found in the current directory.")
        sys.exit(1)

    # Remove existing database if it exists to start fresh
    if os.path.exists(DB_NAME):
        print(f"Removing existing {DB_NAME}...")
        try:
            os.remove(DB_NAME)
        except OSError as e:
            print(f"Error removing file: {e}")
            sys.exit(1)

    print(f"Importing {SQL_FILE} into {DB_NAME}...")
    
    try:
        # Read SQL file
        with open(SQL_FILE, 'r') as f:
            sql_script = f.read()
        
        # Connect to database (creates it if it doesn't exist)
        conn = sqlite3.connect(DB_NAME)
        cursor = conn.cursor()
        
        # Enable Foreign Keys support
        cursor.execute("PRAGMA foreign_keys = ON;")
        
        # Execute script
        cursor.executescript(sql_script)
        
        # Commit and close
        conn.commit()
        
        print(f"Success! Database {DB_NAME} created.")
        
        # Verify tables
        cursor = conn.cursor()
        cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
        tables = cursor.fetchall()
        
        print("Tables created:")
        for table in tables:
            print(f"- {table[0]}")
            
        conn.close()

    except sqlite3.Error as e:
        print(f"SQLite error: {e}")
        sys.exit(1)
    except Exception as e:
        print(f"An error occurred: {e}")
        sys.exit(1)

if __name__ == "__main__":
    create_database()
