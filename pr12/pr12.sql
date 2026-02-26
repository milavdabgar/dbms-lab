-- ============================================================================
-- Practical 12: Integrity Constraints
-- Database: Oracle
-- ============================================================================
-- This practical demonstrates three types of integrity constraints:
-- 1. Domain Integrity (CHECK, NOT NULL, data types)
-- 2. Entity Integrity (PRIMARY KEY, UNIQUE)
-- 3. Referential Integrity (FOREIGN KEY with CASCADE options)
-- ============================================================================

-- Clean up existing tables
DROP TABLE order_items CASCADE CONSTRAINTS;
DROP TABLE orders CASCADE CONSTRAINTS;
DROP TABLE products CASCADE CONSTRAINTS;
DROP TABLE customers CASCADE CONSTRAINTS;
DROP TABLE categories CASCADE CONSTRAINTS;

-- ============================================================================
-- 1. DOMAIN INTEGRITY CONSTRAINTS
-- ============================================================================
-- Domain integrity ensures that column values are valid and appropriate
-- Implemented using: CHECK, NOT NULL, DEFAULT, and appropriate data types

-- Table with domain integrity constraints
CREATE TABLE categories (
    category_id     NUMBER(10) PRIMARY KEY,
    category_name   VARCHAR2(50) NOT NULL,
    description     VARCHAR2(200),
    status          CHAR(1) DEFAULT 'A' CHECK (status IN ('A', 'I')),  -- Active/Inactive
    created_date    DATE DEFAULT SYSDATE NOT NULL
);

CREATE TABLE products (
    product_id      NUMBER(10) PRIMARY KEY,
    product_name    VARCHAR2(100) NOT NULL,
    category_id     NUMBER(10) NOT NULL,
    unit_price      NUMBER(10,2) CHECK (unit_price > 0),  -- Price must be positive
    stock_quantity  NUMBER(10) CHECK (stock_quantity >= 0),  -- Stock cannot be negative
    reorder_level   NUMBER(10) DEFAULT 10 CHECK (reorder_level >= 0),
    discount_pct    NUMBER(5,2) CHECK (discount_pct BETWEEN 0 AND 100),  -- 0-100%
    status          VARCHAR2(20) DEFAULT 'In Stock' 
                    CHECK (status IN ('In Stock', 'Out of Stock', 'Discontinued')),
    -- Multiple CHECK constraints on same column
    expiry_date     DATE CHECK (expiry_date > created_date),
    created_date    DATE DEFAULT SYSDATE NOT NULL
);

CREATE TABLE customers (
    customer_id     NUMBER(10) PRIMARY KEY,
    first_name      VARCHAR2(50) NOT NULL,
    last_name       VARCHAR2(50) NOT NULL,
    email           VARCHAR2(100) NOT NULL UNIQUE,  -- Email must be unique
    phone           VARCHAR2(15) CHECK (LENGTH(phone) >= 10),  -- Min 10 digits
    age             NUMBER(3) CHECK (age >= 18 AND age <= 120),  -- Valid age range
    credit_limit    NUMBER(10,2) DEFAULT 5000 CHECK (credit_limit >= 0),
    join_date       DATE DEFAULT SYSDATE NOT NULL,
    city            VARCHAR2(50),
    state           VARCHAR2(50),
    postal_code     VARCHAR2(10) CHECK (LENGTH(postal_code) = 6)  -- 6-digit PIN
);

-- ============================================================================
-- 2. ENTITY INTEGRITY CONSTRAINTS
-- ============================================================================
-- Entity integrity ensures each row is uniquely identifiable
-- Implemented using: PRIMARY KEY, UNIQUE

CREATE TABLE orders (
    order_id        NUMBER(10) PRIMARY KEY,  -- Entity integrity: unique identifier
    customer_id     NUMBER(10) NOT NULL,
    order_date      DATE DEFAULT SYSDATE NOT NULL,
    order_number    VARCHAR2(20) NOT NULL UNIQUE,  -- Business key must be unique
    total_amount    NUMBER(12,2) CHECK (total_amount >= 0),
    payment_method  VARCHAR2(20) CHECK (payment_method IN ('Cash', 'Card', 'UPI', 'Net Banking')),
    order_status    VARCHAR2(20) DEFAULT 'Pending' 
                    CHECK (order_status IN ('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled')),
    -- Composite UNIQUE constraint
    CONSTRAINT uk_customer_order_date UNIQUE (customer_id, order_date)
);

-- ============================================================================
-- 3. REFERENTIAL INTEGRITY CONSTRAINTS
-- ============================================================================
-- Referential integrity maintains valid relationships between tables
-- Implemented using: FOREIGN KEY with various ON DELETE options

-- Add foreign key to products table
ALTER TABLE products
ADD CONSTRAINT fk_products_category 
    FOREIGN KEY (category_id) 
    REFERENCES categories(category_id)
    ON DELETE CASCADE;  -- Delete products when category is deleted

-- Add foreign key to orders table
ALTER TABLE orders
ADD CONSTRAINT fk_orders_customer 
    FOREIGN KEY (customer_id) 
    REFERENCES customers(customer_id)
    ON DELETE CASCADE;  -- Delete orders when customer is deleted

-- Table with multiple foreign keys and different CASCADE options
CREATE TABLE order_items (
    order_item_id   NUMBER(10) PRIMARY KEY,
    order_id        NUMBER(10) NOT NULL,
    product_id      NUMBER(10) NOT NULL,
    quantity        NUMBER(10) CHECK (quantity > 0) NOT NULL,
    unit_price      NUMBER(10,2) CHECK (unit_price > 0) NOT NULL,
    discount        NUMBER(5,2) DEFAULT 0 CHECK (discount BETWEEN 0 AND 100),
    line_total      NUMBER(12,2) GENERATED ALWAYS AS (quantity * unit_price * (1 - discount/100)) VIRTUAL,
    
    -- Referential integrity with CASCADE
    CONSTRAINT fk_order_items_order 
        FOREIGN KEY (order_id) 
        REFERENCES orders(order_id)
        ON DELETE CASCADE,  -- Delete order items when order is deleted
    
    CONSTRAINT fk_order_items_product 
        FOREIGN KEY (product_id) 
        REFERENCES products(product_id)
        ON DELETE CASCADE,  -- Delete order items when product is deleted
    
    -- Composite UNIQUE to prevent duplicate product in same order
    CONSTRAINT uk_order_product UNIQUE (order_id, product_id)
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
INSERT INTO products (product_id, product_name, category_id, unit_price, stock_quantity, reorder_level, discount_pct, status, expiry_date)
VALUES (101, 'Laptop', 1, 45000.00, 25, 5, 10, 'In Stock', TO_DATE('2026-12-31', 'YYYY-MM-DD'));

INSERT INTO products (product_id, product_name, category_id, unit_price, stock_quantity, reorder_level, discount_pct, status, expiry_date)
VALUES (102, 'Smartphone', 1, 25000.00, 50, 10, 15, 'In Stock', TO_DATE('2026-12-31', 'YYYY-MM-DD'));

INSERT INTO products (product_id, product_name, category_id, unit_price, stock_quantity, reorder_level, discount_pct, status, expiry_date)
VALUES (103, 'T-Shirt', 2, 499.00, 100, 20, 5, 'In Stock', TO_DATE('2027-12-31', 'YYYY-MM-DD'));

INSERT INTO products (product_id, product_name, category_id, unit_price, stock_quantity, reorder_level, discount_pct, status, expiry_date)
VALUES (104, 'Python Programming Book', 3, 599.00, 30, 10, 0, 'In Stock', TO_DATE('2030-12-31', 'YYYY-MM-DD'));

INSERT INTO products (product_id, product_name, category_id, unit_price, stock_quantity, reorder_level, discount_pct, status, expiry_date)
VALUES (105, 'Blender', 4, 2500.00, 15, 5, 20, 'In Stock', TO_DATE('2028-12-31', 'YYYY-MM-DD'));

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

COMMIT;

-- ============================================================================
-- Demonstrating Constraint Violations
-- ============================================================================

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

-- Display data before deletion
SELECT 'Categories before deletion:' AS message FROM DUAL;
SELECT * FROM categories WHERE category_id = 4;

SELECT 'Products in category 4:' AS message FROM DUAL;
SELECT * FROM products WHERE category_id = 4;

-- Delete category - will CASCADE delete all products in that category
DELETE FROM categories WHERE category_id = 4;

SELECT 'Products in category 4 after cascade delete:' AS message FROM DUAL;
SELECT * FROM products WHERE category_id = 4;

ROLLBACK;  -- Restore deleted data for demo

-- ============================================================================
-- Viewing Constraint Information
-- ============================================================================

-- View all constraints in the schema
SELECT constraint_name, constraint_type, table_name, search_condition
FROM user_constraints
WHERE table_name IN ('CATEGORIES', 'PRODUCTS', 'CUSTOMERS', 'ORDERS', 'ORDER_ITEMS')
ORDER BY table_name, constraint_type;

-- View foreign key relationships
SELECT 
    a.table_name AS child_table,
    a.constraint_name,
    a.column_name AS child_column,
    c_pk.table_name AS parent_table,
    b.column_name AS parent_column
FROM 
    user_cons_columns a
    JOIN user_constraints c ON a.constraint_name = c.constraint_name
    JOIN user_constraints c_pk ON c.r_constraint_name = c_pk.constraint_name
    JOIN user_cons_columns b ON c_pk.constraint_name = b.constraint_name
WHERE 
    c.constraint_type = 'R'
    AND a.table_name IN ('PRODUCTS', 'ORDERS', 'ORDER_ITEMS')
ORDER BY 
    a.table_name, a.position;

-- ============================================================================
-- Additional Examples: Adding Constraints to Existing Tables
-- ============================================================================

-- Add CHECK constraint using ALTER TABLE
-- ALTER TABLE products 
-- ADD CONSTRAINT chk_product_name_length 
-- CHECK (LENGTH(product_name) >= 3);

-- Add UNIQUE constraint using ALTER TABLE
-- ALTER TABLE customers 
-- ADD CONSTRAINT uk_customer_phone 
-- UNIQUE (phone);

-- Add NOT NULL constraint using ALTER TABLE
-- ALTER TABLE orders 
-- MODIFY (order_status NOT NULL);

-- ============================================================================
-- Cleanup (commented out - uncomment to drop tables)
-- ============================================================================
-- DROP TABLE order_items CASCADE CONSTRAINTS;
-- DROP TABLE orders CASCADE CONSTRAINTS;
-- DROP TABLE products CASCADE CONSTRAINTS;
-- DROP TABLE customers CASCADE CONSTRAINTS;
-- DROP TABLE categories CASCADE CONSTRAINTS;
