-- E-Commerce SQL Data Analysis Project
-- Database: sql_mini_project

CREATE DATABASE IF NOT EXISTS sql_mini_project;
USE sql_mini_project;

-- =========================
-- 1. TABLES
-- =========================

CREATE TABLE IF NOT EXISTS customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50),
    signup_date DATE
);

CREATE TABLE IF NOT EXISTS products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    stock INT
);

CREATE TABLE IF NOT EXISTS orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    status VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10,2)
);

CREATE TABLE IF NOT EXISTS payments (
    payment_id INT PRIMARY KEY,
    order_id INT,
    payment_date DATE,
    payment_method VARCHAR(30),
    payment_status VARCHAR(20),
    amount DECIMAL(10,2)
);

-- =========================
-- 2. SAMPLE DATA
-- =========================

INSERT INTO customers VALUES
(1,'Rahul Sharma','rahul@gmail.com','Bhubaneswar','2026-04-01'),
(2,'Priya Das','priya@gmail.com','Cuttack','2026-04-02'),
(3,'Amit Kumar','amit@gmail.com','Bhubaneswar','2026-04-03'),
(4,'Sneha Patel','sneha@gmail.com','Puri','2026-04-04'),
(5,'Rakesh Singh','rakesh@gmail.com','Bhubaneswar','2026-04-05'),
(6,'Ananya Roy','ananya@gmail.com','Cuttack','2026-04-06'),
(7,'Sourav Das','sourav@gmail.com','Puri','2026-04-07'),
(8,'Neha Mishra','neha@gmail.com','Bhubaneswar','2026-04-08'),
(9,'Vikas Panda','vikas@gmail.com','Dhenkanal','2026-04-09'),
(10,'Pooja Sahu','pooja@gmail.com','Bhubaneswar','2026-04-10');

INSERT INTO products VALUES
(1,'Laptop','Electronics',55000,20),
(2,'Smartphone','Electronics',25000,35),
(3,'Headphones','Electronics',4500,50),
(4,'Keyboard','Accessories',3500,40),
(5,'Smart Watch','Wearable',6000,25),
(6,'Mouse','Accessories',1500,60),
(7,'Tablet','Electronics',75000,15),
(8,'USB Cable','Accessories',300,100),
(9,'Power Bank','Accessories',5500,30),
(10,'Monitor','Electronics',12000,18);

INSERT INTO orders VALUES
(1,1,'2026-05-01',55000,'Delivered'),
(2,2,'2026-05-02',25000,'Delivered'),
(3,3,'2026-05-03',45000,'Shipped'),
(4,4,'2026-05-04',3500,'Delivered'),
(5,5,'2026-05-05',60000,'Pending'),
(6,6,'2026-05-06',15000,'Delivered'),
(7,7,'2026-05-07',75000,'Shipped'),
(8,8,'2026-05-08',3000,'Delivered'),
(9,9,'2026-05-09',5500,'Pending'),
(10,10,'2026-05-10',12000,'Delivered');

INSERT INTO order_items VALUES
(1,1,1,1,55000),
(2,2,2,1,25000),
(3,3,3,10,4500),
(4,4,4,1,3500),
(5,5,5,10,6000),
(6,6,6,10,1500),
(7,7,7,1,75000),
(8,8,8,10,300),
(9,9,9,1,5500),
(10,10,10,1,12000);

INSERT INTO payments VALUES
(1,1,'2026-05-01','UPI','Paid',55000),
(2,2,'2026-05-02','Card','Paid',25000),
(3,3,'2026-05-03','UPI','Paid',45000),
(4,4,'2026-05-04','Cash','Paid',3500),
(5,5,'2026-05-05','Card','Pending',60000),
(6,6,'2026-05-06','UPI','Paid',15000),
(7,7,'2026-05-07','Card','Paid',75000),
(8,8,'2026-05-08','UPI','Paid',3000),
(9,9,'2026-05-09','Cash','Pending',5500),
(10,10,'2026-05-10','UPI','Paid',12000);

-- =========================
-- 3. BASIC ANALYSIS
-- =========================

SELECT customer_name,email FROM customers;
SELECT * FROM products;
SELECT DISTINCT category FROM products;
SELECT * FROM products WHERE price > 1000;
SELECT * FROM products WHERE price BETWEEN 2000 AND 5000;
SELECT * FROM customers WHERE customer_id IN (1,3,5);
SELECT * FROM customers WHERE customer_name LIKE 'A%';
SELECT * FROM products WHERE category='Electronics' AND price < 3000;
SELECT product_name,price FROM products ORDER BY price DESC;
SELECT product_name,price FROM products ORDER BY price DESC,product_name ASC;

-- =========================
-- 4. AGGREGATIONS
-- =========================

SELECT COUNT(*) AS total_orders FROM orders;
SELECT SUM(total_amount) AS total_revenue FROM orders;
SELECT AVG(total_amount) AS average_order_value FROM orders;
SELECT customer_id,COUNT(*) AS order_count FROM orders GROUP BY customer_id;
SELECT customer_id,SUM(total_amount) AS total_sales FROM orders GROUP BY customer_id;
SELECT p.category,SUM(oi.quantity) AS products_sold
FROM products p JOIN order_items oi ON p.product_id=oi.product_id
GROUP BY p.category;
SELECT category,AVG(price) AS average_item_price FROM products GROUP BY category;
SELECT order_date,COUNT(*) AS order_count FROM orders GROUP BY order_date;
SELECT payment_method,SUM(amount) AS total_payments FROM payments GROUP BY payment_method;

-- =========================
-- 5. JOINS
-- =========================

SELECT c.customer_name,o.order_id,o.order_date,o.total_amount,o.status
FROM customers c INNER JOIN orders o ON c.customer_id=o.customer_id;

SELECT o.order_id,p.product_name,p.category,oi.quantity,oi.price
FROM orders o
INNER JOIN order_items oi ON o.order_id=oi.order_id
INNER JOIN products p ON oi.product_id=p.product_id;

SELECT o.order_id,o.order_date,o.total_amount,p.payment_method,p.payment_status,p.amount
FROM orders o INNER JOIN payments p ON o.order_id=p.order_id;

SELECT c.customer_name,o.order_id,o.order_date,o.total_amount,o.status
FROM customers c LEFT JOIN orders o ON c.customer_id=o.customer_id;

SELECT p.product_id,p.product_name,p.category,oi.order_id,oi.quantity
FROM products p LEFT JOIN order_items oi ON p.product_id=oi.product_id;

SELECT p.payment_id,p.order_id,p.payment_method,p.payment_status,p.amount
FROM orders o RIGHT JOIN payments p ON o.order_id=p.order_id;

SELECT customer_id,COUNT(*) AS order_count
FROM orders GROUP BY customer_id HAVING COUNT(*)>1;

SELECT c.customer_name,SUM(o.total_amount) AS total_sales
FROM customers c INNER JOIN orders o ON c.customer_id=o.customer_id
GROUP BY c.customer_id,c.customer_name;

SELECT c.customer_name,AVG(o.total_amount) AS average_order_value
FROM customers c INNER JOIN orders o ON c.customer_id=o.customer_id
GROUP BY c.customer_id,c.customer_name;

SELECT c.customer_name,COUNT(o.order_id) AS total_orders,SUM(o.total_amount) AS total_sales
FROM customers c INNER JOIN orders o ON c.customer_id=o.customer_id
GROUP BY c.customer_id,c.customer_name;

SELECT p.product_name,SUM(oi.quantity) AS total_quantity_sold
FROM products p INNER JOIN order_items oi ON p.product_id=oi.product_id
GROUP BY p.product_id,p.product_name;

-- =========================
-- 6. SUBQUERIES
-- =========================

SELECT product_name,price FROM products
WHERE price > (SELECT AVG(price) FROM products);

SELECT order_id,customer_id,total_amount FROM orders
WHERE total_amount > (SELECT AVG(total_amount) FROM orders);

SELECT product_name,price FROM products
WHERE price=(SELECT MAX(price) FROM products);

SELECT customer_id,customer_name FROM customers
WHERE customer_id IN (SELECT customer_id FROM orders);

SELECT product_id,product_name FROM products
WHERE product_id NOT IN (SELECT product_id FROM order_items);

SELECT order_id,customer_id,total_amount FROM orders
WHERE total_amount=(SELECT MAX(total_amount) FROM orders);

SELECT c.customer_name,SUM(o.total_amount) AS total_spent
FROM customers c INNER JOIN orders o ON c.customer_id=o.customer_id
GROUP BY c.customer_id,c.customer_name
HAVING SUM(o.total_amount)>(SELECT AVG(total_amount) FROM orders);

SELECT o.order_id,o.customer_id,o.total_amount
FROM orders o
WHERE o.total_amount > (
    SELECT AVG(o2.total_amount)
    FROM orders o2
    WHERE o2.customer_id=o.customer_id
);

SELECT customer_id,customer_name FROM customers
WHERE customer_id NOT IN (SELECT customer_id FROM orders);

SELECT o.order_id,o.customer_id,o.total_amount
FROM orders o
WHERE o.total_amount = (
    SELECT MAX(o2.total_amount)
    FROM orders o2
    WHERE o2.customer_id=o.customer_id
);

SELECT c.customer_name,o.order_id,o.total_amount
FROM customers c INNER JOIN orders o ON c.customer_id=o.customer_id
WHERE o.total_amount = (
    SELECT MAX(o2.total_amount)
    FROM orders o2
    WHERE o2.customer_id=o.customer_id
);

-- =========================
-- 7. SET OPERATIONS
-- =========================

SELECT customer_id FROM customers
INTERSECT
SELECT customer_id FROM orders;

SELECT customer_id FROM customers
EXCEPT
SELECT customer_id FROM orders;

SELECT customer_id FROM customers
UNION
SELECT customer_id FROM orders;

SELECT customer_id FROM customers
UNION ALL
SELECT customer_id FROM orders;

SELECT customer_id FROM orders
EXCEPT
SELECT customer_id FROM customers;

SELECT customer_id FROM customers
UNION
SELECT customer_id FROM orders
ORDER BY customer_id;

SELECT customer_id FROM customers
INTERSECT
SELECT customer_id FROM orders
ORDER BY customer_id;

-- =========================
-- 8. FINAL PROJECT KPI
-- =========================

SELECT
    (SELECT COUNT(*) FROM customers) AS total_customers,
    (SELECT COUNT(*) FROM products) AS total_products,
    (SELECT COUNT(*) FROM orders) AS total_orders,
    (SELECT SUM(total_amount) FROM orders) AS total_revenue,
    (SELECT AVG(total_amount) FROM orders) AS average_order_value;
