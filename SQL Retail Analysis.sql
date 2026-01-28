-- =========================
-- 1. CREATE DATABASE
-- =========================
CREATE DATABASE retail_analysis;
USE retail_analysis;

-- =========================
-- 2. CREATE TABLES
-- =========================

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_details (
    order_detail_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- =========================
-- 3. INSERT DATA
-- =========================

INSERT INTO customers VALUES
(1,'Amit','Delhi','India'),
(2,'Sara','Mumbai','India'),
(3,'John','New York','USA'),
(4,'Priya','Bangalore','India');

INSERT INTO products VALUES
(101,'Laptop','Electronics',60000),
(102,'Mobile','Electronics',30000),
(103,'Chair','Furniture',5000),
(104,'Table','Furniture',8000);

INSERT INTO orders VALUES
(201,1,'2025-01-10'),
(202,2,'2025-01-11'),
(203,3,'2025-02-05'),
(204,4,'2025-02-15');

INSERT INTO order_details VALUES
(1,201,101,1),
(2,201,103,2),
(3,202,102,1),
(4,203,101,1),
(5,204,104,1),
(6,204,102,2);

-- =========================
-- 4. DATA ANALYSIS QUERIES
-- ============================

-- 1. Total Revenue
SELECT SUM(p.price * od.quantity) AS total_revenue
FROM order_details od
JOIN products p ON od.product_id = p.product_id;

-- 2. Revenue by Category
SELECT p.category, SUM(p.price * od.quantity) AS revenue
FROM order_details od
JOIN products p ON od.product_id = p.product_id
GROUP BY p.category;

-- 3. Top Selling Products
SELECT p.product_name, SUM(od.quantity) AS total_sold
FROM order_details od
JOIN products p ON od.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC;

-- 4. Revenue by Customer
SELECT c.name, SUM(p.price * od.quantity) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
GROUP BY c.name;

-- 5. Monthly Sales Trend
SELECT MONTH(o.order_date) AS month, 
       SUM(p.price * od.quantity) AS revenue
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
GROUP BY MONTH(o.order_date)
ORDER BY month;

-- 6. Best Customer
SELECT c.name, SUM(p.price * od.quantity) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
GROUP BY c.name
ORDER BY total_spent DESC
LIMIT 1;
