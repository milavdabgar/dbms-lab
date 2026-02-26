-- ============================================================================
-- Practical 12: Integrity Constraints
-- Database: SQLite
-- ============================================================================
-- This practical demonstrates three types of integrity constraints:
-- 1. Domain Integrity (CHECK, NOT NULL, data types)
-- 2. Entity Integrity (PRIMARY KEY, UNIQUE)
-- 3. Referential Integrity (FOREIGN KEY with CASCADE options)
-- ============================================================================

-- Enable foreign key support (required in SQLite)
PRAGMA foreign_keys = ON;

-- Clean up existing tables
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS categories;

-- ============================================================================
-- 1. DOMAIN INTEGRITY CONSTRAINTS
-- ============================================================================
-- Domain integrity ensures that column values are valid and appropriate
-- Implemented using: CHECK, NOT NULL, DEFAULT, and appropriate data types

-- Table with domain integrity constraints
CREATE TABLE categories (
    category_id     INTEGER PRIMARY KEY,
    category_name   TEXT NOT NULL,
    description     TEXT,
    status          TEXT DEFAULT 'A' CHECK (status IN ('A', 'I')),  -- Active/Inactive
    created_date    TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE products (
    product_id      INTEGER PRIMARY KEY,
    product_name    TEXT NOT NULL,
    category_id     INTEGER NOT NULL,
    unit_price      REAL CHECK (unit_price > 0),  -- Price must be positive
    stock_quantity  INTEGER CHECK (stock_quantity >= 0),  -- Stock cannot be negative
    reorder_level   INTEGER DEFAULT 10 CHECK (reorder_level >= 0),
    discount_pct    REAL CHECK (discount_pct BETWEEN 0 AND 100),  -- 0-100%
    status          TEXT DEFAULT 'In Stock' 
                    CHECK (status IN ('In Stock', 'Out of Stock', 'Discontinued')),
    expiry_date     TEXT CHECK (expiry_date > created_date),
    created_date    TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE customers (
    customer_id     INTEGER PRIMARY KEY,
    first_name      TEXT NOT NULL,
    last_name       TEXT NOT NULL,
    email           TEXT NOT NULL UNIQUE,  -- Email must be unique
    phone           TEXT CHECK (length(phone) >= 10),  -- Min 10 digits
    age             INTEGER CHECK (age >= 18 AND age <= 120),  -- Valid age range
    credit_limit    REAL DEFAULT 5000 CHECK (credit_limit >= 0),
    join_date       TEXT NOT NULL DEFAULT (date('now')),
    city            TEXT,
    state           TEXT,
    postal_code     TEXT CHECK (length(postal_code) = 6)  -- 6-digit PIN
);

-- ============================================================================
-- 2. ENTITY INTEGRITY CONSTRAINTS
-- ============================================================================
-- Entity integrity ensures each row is uniquely identifiable
-- Implemented using: PRIMARY KEY, UNIQUE

CREATE TABLE orders (
    order_id        INTEGER PRIMARY KEY,  -- Entity integrity: unique identifier
    customer_id     INTEGER NOT NULL,
    order_date      TEXT NOT NULL DEFAULT (date('now')),
    order_number    TEXT NOT NULL UNIQUE,  -- Business key must be unique
    total_amount    REAL CHECK (total_amount >= 0),
    payment_method  TEXT CHECK (payment_method IN ('Cash', 'Card', 'UPI', 'Net Banking')),
    order_status    TEXT DEFAULT 'Pending' 
                    CHECK (order_status IN ('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled')),
    -- Composite UNIQUE constraint
    UNIQUE (customer_id, order_date)
);

-- ============================================================================
-- 3. REFERENTIAL INTEGRITY CONSTRAINTS
-- ============================================================================
-- Referential integrity maintains valid relationships between tables
-- Implemented using: FOREIGN KEY with various ON DELETE options

-- Add foreign key to products table
-- Note: In SQLite, foreign keys must be defined during table creation
DROP TABLE IF EXISTS products;
CREATE TABLE products (
    product_id      INTEGER PRIMARY KEY,
    product_name    TEXT NOT NULL,
    category_id     INTEGER NOT NULL,
    unit_price      REAL CHECK (unit_price > 0),
    stock_quantity  INTEGER CHECK (stock_quantity >= 0),
    reorder_level   INTEGER DEFAULT 10 CHECK (reorder_level >= 0),
    discount_pct    REAL CHECK (discount_pct BETWEEN 0 AND 100),
    status          TEXT DEFAULT 'In Stock' 
                    CHECK (status IN ('In Stock', 'Out of Stock', 'Discontinued')),
    expiry_date     TEXT CHECK (expiry_date > created_date),
    created_date    TEXT NOT NULL DEFAULT (datetime('now')),
    
    -- Referential integrity with CASCADE
    FOREIGN KEY (category_id) 
        REFERENCES categories(category_id)
        ON DELETE CASCADE  -- Delete products when category is deleted
);

-- Recreate orders table with foreign key
DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
    order_id        INTEGER PRIMARY KEY,
    customer_id     INTEGER NOT NULL,
    order_date      TEXT NOT NULL DEFAULT (date('now')),
    order_number    TEXT NOT NULL UNIQUE,
    total_amount    REAL CHECK (total_amount >= 0),
    payment_method  TEXT CHECK (payment_method IN ('Cash', 'Card', 'UPI', 'Net Banking')),
    order_status    TEXT DEFAULT 'Pending' 
                    CHECK (order_status IN ('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled')),
    
    -- Referential integrity with CASCADE
    FOREIGN KEY (customer_id) 
        REFERENCES customers(customer_id)
        ON DELETE CASCADE,  -- Delete orders when customer is deleted
    
    UNIQUE (customer_id, order_date)
);

-- Table with multiple foreign keys and different CASCADE options
CREATE TABLE order_items (
    order_item_id   INTEGER PRIMARY KEY,
    order_id        INTEGER NOT NULL,
    product_id      INTEGER NOT NULL,
    quantity        INTEGER CHECK (quantity > 0) NOT NULL,
    unit_price      REAL CHECK (unit_price > 0) NOT NULL,
    discount        REAL DEFAULT 0 CHECK (discount BETWEEN 0 AND 100),
    line_total      REAL GENERATED ALWAYS AS (quantity * unit_price * (1 - discount/100)) STORED,
    
    -- Referential integrity with CASCADE
    FOREIGN KEY (order_id) 
        REFERENCES orders(order_id)
        ON DELETE CASCADE,  -- Delete order items when order is deleted
    
    FOREIGN KEY (product_id) 
        REFERENCES products(product_id)
        ON DELETE CASCADE,  -- Delete order items when product is deleted
    
    -- Composite UNIQUE to prevent duplicate product in same order
    UNIQUE (order_id, product_id)
);

-- ============================================================================
-- Insert Sample Data
-- ============================================================================

-- Insert categories
INSERT INTO categories (category_id, category_name, description, status) 
VALUES (1, 'Electronics', 'Electronic devices and gadgets', 'A');
INSERT INTO categories (category_id, category_name, description, status) 
VALUES (2, 'Clothing', 'Apparel and fashion items', 'A');
INSERT INTO categories (category_id, category_name, description, status) 
VALUES (3, 'Books', 'Books and publications', 'A');
INSERT INTO categories (category_id, category_name, description, status) 
VALUES (4, 'Home & Kitchen', 'Home appliances and kitchenware', 'A');

-- Insert products
INSERT INTO products (product_id, product_name, category_id, unit_price, stock_quantity, reorder_level, discount_pct, status, expiry_date, created_date)
VALUES (101, 'Laptop', 1, 45000.00, 25, 5, 10, 'In Stock', '2026-12-31', '2026-02-26');

INSERT INTO products (product_id, product_name, category_id, unit_price, stock_quantity, reorder_level, discount_pct, status, expiry_date, created_date)
VALUES (102, 'Smartphone', 1, 25000.00, 50, 10, 15, 'In Stock', '2026-12-31', '2026-02-26');

INSERT INTO products (product_id, product_name, category_id, unit_price, stock_quantity, reorder_level, discount_pct, status, expiry_date, created_date)
VALUES (103, 'T-Shirt', 2, 499.00, 100, 20, 5, 'In Stock', '2027-12-31', '2026-02-26');

INSERT INTO products (product_id, product_name, category_id, unit_price, stock_quantity, reorder_level, discount_pct, status, expiry_date, created_date)
VALUES (104, 'Python Programming Book', 3, 599.00, 30, 10, 0, 'In Stock', '2030-12-31', '2026-02-26');

INSERT INTO products (product_id, product_name, category_id, unit_price, stock_quantity, reorder_level, discount_pct, status, expiry_date, created_date)
VALUES (105, 'Blender', 4, 2500.00, 15, 5, 20, 'In Stock', '2028-12-31', '2026-02-26');

-- Insert customers
INSERT INTO customers (customer_id, first_name, last_name, email, phone, age, credit_limit, city, state, postal_code)
VALUES (1, 'Amit', 'Sharma', 'amit.sharma@email.com', '9876543210', 28, 50000, 'Mumbai', 'Maharashtra', '400001');

INSERT INTO customers (customer_id, first_name, last_name, email, phone, age, credit_limit, city, state, postal_code)
VALUES (2, 'Priya', 'Patel', 'priya.patel@email.com', '9876543211', 32, 75000, 'Ahmedabad', 'Gujarat', '380001');

INSERT INTO customers (customer_id, first_name, last_name, email, phone, age, credit_limit, city, state, postal_code)
VALUES (3, 'Rahul', 'Kumar', 'rahul.kumar@email.com', '9876543212', 25, 40000, 'Delhi', 'Delhi', '110001');

INSERT INTO customers (customer_id, first_name, last_name, email, phone, age, credit_limit, city, state, postal_code)
VALUES (4, 'Sneha', 'Singh', 'sneha.singh@email.com', '9876543213', 30, 60000, 'Bangalore', 'Karnataka', '560001');

INSERT INTO customers (customer_id, first_name, last_name, email, phone, age, credit_limit, city, state, postal_code)
VALUES (5, 'Vikram', 'Rao', 'vikram.rao@email.com', '9876543214', 35, 80000, 'Chennai', 'Tamil Nadu', '600001');

-- Insert orders
INSERT INTO orders (order_id, customer_id, order_number, total_amount, payment_method, order_status)
VALUES (1001, 1, 'ORD-2026-0001', 45000.00, 'Card', 'Delivered');

INSERT INTO orders (order_id, customer_id, order_number, total_amount, payment_method, order_status)
VALUES (1002, 2, 'ORD-2026-0002', 25000.00, 'UPI', 'Shipped');

INSERT INTO orders (order_id, customer_id, order_number, total_amount, payment_method, order_status)
VALUES (1003, 3, 'ORD-2026-0003', 1098.00, 'Cash', 'Processing');

INSERT INTO orders (order_id, customer_id, order_number, total_amount, payment_method, order_status)
VALUES (1004, 4, 'ORD-2026-0004', 2500.00, 'Net Banking', 'Pending');

INSERT INTO orders (order_id, customer_id, order_number, total_amount, payment_method, order_status)
VALUES (1005, 5, 'ORD-2026-0005', 70000.00, 'Card', 'Delivered');

-- Insert order items
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price, discount)
VALUES (10001, 1001, 101, 1, 45000.00, 10);

INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price, discount)
VALUES (10002, 1002, 102, 1, 25000.00, 15);

INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price, discount)
VALUES (10003, 1003, 103, 2, 499.00, 5);

INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price, discount)
VALUES (10004, 1003, 104, 1, 599.00, 0);

INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price, discount)
VALUES (10005, 1004, 105, 1, 2500.00, 20);

INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price, discount)
VALUES (10006, 1005, 101, 1, 45000.00, 10);

INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price, discount)
VALUES (10007, 1005, 102, 1, 25000.00, 15);

-- ============================================================================
-- Display Sample Data
-- ============================================================================

.mode column
.headers on
.width 12 20 30 10 10

SELECT '=== Categories ===' AS '';
SELECT * FROM categories;

SELECT '=== Products ===' AS '';
SELECT product_id, product_name, category_id, unit_price, stock_quantity, status FROM products;

SELECT '=== Customers ===' AS '';
SELECT customer_id, first_name, last_name, email, phone, age FROM customers;

SELECT '=== Orders ===' AS '';
SELECT order_id, customer_id, order_number, total_amount, payment_method, order_status FROM orders;

SELECT '=== Order Items ===' AS '';
SELECT order_item_id, order_id, product_id, quantity, unit_price, discount, line_total FROM order_items;

-- ============================================================================
-- Demonstrating Constraint Violations
-- ============================================================================

SELECT '=== Testing Constraint Violations ===' AS '';

-- Example 1: Domain Integrity Violation - Negative price
-- This will fail: CHECK constraint violated
-- INSERT INTO products (product_id, product_name, category_id, unit_price, stock_quantity)
-- VALUES (106, 'Invalid Product', 1, -100, 10);

-- Example 2: Domain Integrity Violation - Invalid age
-- This will fail: age must be between 18 and 120
-- INSERT INTO customers (customer_id, first_name, last_name, email, phone, age)
-- VALUES (6, 'John', 'Doe', 'john.doe@email.com', '9876543215', 15);

-- Example 3: Entity Integrity Violation - Duplicate PRIMARY KEY
-- This will fail: unique constraint violated
-- INSERT INTO customers (customer_id, first_name, last_name, email, phone, age)
-- VALUES (1, 'Test', 'User', 'test@email.com', '9876543220', 25);

-- Example 4: Entity Integrity Violation - Duplicate UNIQUE key
-- This will fail: email must be unique
-- INSERT INTO customers (customer_id, first_name, last_name, email, phone, age)
-- VALUES (6, 'Another', 'User', 'amit.sharma@email.com', '9876543221', 25);

-- Example 5: Referential Integrity Violation - Invalid foreign key
-- This will fail: category_id 99 doesn't exist
-- INSERT INTO products (product_id, product_name, category_id, unit_price, stock_quantity)
-- VALUES (106, 'Invalid Product', 99, 1000, 10);

-- ============================================================================
-- Demonstrating CASCADE Effects
-- ============================================================================

SELECT '=== Testing CASCADE DELETE ===' AS '';

-- Display data before deletion
SELECT 'Products in category 4 before deletion:' AS '';
SELECT * FROM products WHERE category_id = 4;

-- Begin transaction to test CASCADE
BEGIN TRANSACTION;

-- Delete category - will CASCADE delete all products in that category
DELETE FROM categories WHERE category_id = 4;

SELECT 'Products in category 4 after CASCADE delete:' AS '';
SELECT * FROM products WHERE category_id = 4;

-- Rollback to restore deleted data
ROLLBACK;

SELECT 'Products in category 4 after ROLLBACK:' AS '';
SELECT * FROM products WHERE category_id = 4;

-- ============================================================================
-- Viewing Constraint Information
-- ============================================================================

SELECT '=== Table Schema Information ===' AS '';

-- View table schema with constraints
SELECT sql FROM sqlite_master WHERE type = 'table' AND name = 'products';

-- View foreign key information
PRAGMA foreign_key_list(products);
PRAGMA foreign_key_list(orders);
PRAGMA foreign_key_list(order_items);

-- ============================================================================
-- Test Queries - Verify Data Integrity
-- ============================================================================

SELECT '=== Data Integrity Verification ===' AS '';

-- Check for orphaned records (should return 0)
SELECT 'Orphaned products (products without valid category):' AS '';
SELECT COUNT(*) as orphan_count 
FROM products p 
LEFT JOIN categories c ON p.category_id = c.category_id 
WHERE c.category_id IS NULL;

SELECT 'Orphaned orders (orders without valid customer):' AS '';
SELECT COUNT(*) as orphan_count 
FROM orders o 
LEFT JOIN customers c ON o.customer_id = c.customer_id 
WHERE c.customer_id IS NULL;

-- Verify constraint effectiveness
SELECT 'Products with invalid price (should be 0):' AS '';
SELECT COUNT(*) FROM products WHERE unit_price <= 0;

SELECT 'Customers with invalid age (should be 0):' AS '';
SELECT COUNT(*) FROM customers WHERE age < 18 OR age > 120;

-- ============================================================================
-- SQLite Limitations Note
-- ============================================================================
-- Note: SQLite has some limitations compared to Oracle:
-- 1. Cannot use ALTER TABLE to ADD/DROP constraints (except RENAME)
-- 2. To modify constraints, you must recreate the table
-- 3. No support for DEFERRABLE constraints
-- 4. ON DELETE SET DEFAULT is supported but requires DEFAULT value
-- 5. Generated columns must use STORED (not VIRTUAL like Oracle)
-- ============================================================================
