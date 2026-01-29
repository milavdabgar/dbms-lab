# Practical No.3: SQL DDL Commands

This directory contains the solution for Practical No.3.

## Files
- `create_tables.sql`: The SQL script containing all `CREATE TABLE` commands.
- `insert_data.sql`: DML commands to insert sample data into the tables.
- `queries.sql`: Demo SQL queries to retrieve data.
- `pr3.db`: The SQLite database file (generated after running the scripts).
- `setup_database.py`: Python script to create the database (runs `create_tables.sql`).

- `seed_data.py`: Python script to populate the database (runs `insert_data.sql`).
- `demo_queries.py`: Python script to run demo queries (runs `queries.sql`).

## How to Run

### Option 1: Using the Python Scripts (Recommended for All OS)
These scripts work on Windows, Mac, and Linux. Ensure you have Python installed.

1.  **Create the Database:**
    ```bash
    python setup_database.py
    ```
    This creates `pr3.db` with all empty tables.

2.  **Insert Sample Data:**
    ```bash
    python seed_data.py
    ```
    This populates `pr3.db` with students, courses, users, products, etc.

3.  **Run Demo Queries:**
    ```bash
    python demo_queries.py
    ```
    This executes sample queries to show the data and relationships.

### Option 2: Using "DB Browser for SQLite" (GUI)

1.  **Import Structure:**
    - Open DB Browser.
    - **File** -> **Import** -> **Database from SQL file...**.
    - Select `create_tables.sql`. Save as `pr3.db`.


2.  **Import Data:**
    - With `pr3.db` open, go to the **Execute SQL** tab.
    - Click **Open SQL file** (folder icon) or paste content from `insert_data.sql`.
    - Click **Execute all** (play button).
    - Click **Write Changes** to save.

3.  **Run Queries:**
    - Go to **Execute SQL** tab.
    - Open `queries.sql`.
    - Execute to see results.

### Option 3: Using the Command Line Manually
```bash
# Create Database
sqlite3 pr3.db < create_tables.sql


# Insert Data
sqlite3 pr3.db < insert_data.sql

# Run Queries
sqlite3 pr3.db < queries.sql
```
