import sqlite3
import os
import sys

DB_NAME = "pr3.db"
SQL_FILE = "queries.sql"

def run_queries():
    print("Running Demo Queries...")
    
    if not os.path.exists(SQL_FILE):
        print(f"Error: {SQL_FILE} not found.")
        sys.exit(1)
        
    if not os.path.exists(DB_NAME):
        print(f"Error: {DB_NAME} not found. Please run setup_database.py and seed_data.py first.")
        sys.exit(1)

    try:
        conn = sqlite3.connect(DB_NAME)
        cursor = conn.cursor()
        
        # Read the SQL file
        with open(SQL_FILE, 'r') as f:
            lines = f.readlines()

        # Parse and execute statement by statement to print results nicely
        current_query = ""
        for line in lines:
            stripped = line.strip()
            if not stripped or stripped.startswith("--"):
                continue
            
            current_query += " " + stripped
            if stripped.endswith(";"):
                # Check if it's a print label query (faked with SELECT "string";)
                if current_query.strip().upper().startswith('SELECT "---'):
                     # Just print the label directly, don't query db if possible or query and print result
                     pass
                
                try:
                    cursor.execute(current_query)
                    
                    # Fetch results if any
                    results = cursor.fetchall()
                    
                    # If the query was just a label, print it
                    if len(results) == 1 and len(results[0]) == 1 and str(results[0][0]).startswith("---"):
                        print(f"\n{results[0][0]}")
                        # Print headers? No easy way to get headers for next query contextually without complex parsing
                    elif results:
                        # Get column names
                        names = [description[0] for description in cursor.description]
                        print(f"Columns: {names}")
                        for row in results:
                            print(row)
                    elif not results:
                        # Maybe an INSERT/UPDATE or empty result
                        pass
                        
                except sqlite3.Error as e:
                    print(f"Error executing: {current_query}")
                    print(e)
                
                current_query = ""

        conn.close()
        
    except sqlite3.Error as e:
        print(f"SQLite error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    run_queries()
