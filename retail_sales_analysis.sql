CREATE DATABASE retail_sales;
USE retail_sales;

CREATE TABLE stores (
    store_id INT PRIMARY KEY,
    store_name VARCHAR(100),
    region VARCHAR(50)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    store_id INT,
    transaction_time DATETIME2,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (store_id) REFERENCES stores(store_id)
);

CREATE TABLE transaction_details (
    detail_id INT PRIMARY KEY,
    transaction_id INT,
    product_id INT,
    quantity INT,
    subtotal DECIMAL(10,2),
    FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO stores VALUES
(1,'Jakarta Store','West'),
(2,'Bandung Store','West'),
(3,'Surabaya Store','East');

INSERT INTO products VALUES
(1,'Laptop','Electronics',1200),
(2,'Mouse','Electronics',25),
(3,'Keyboard','Electronics',45),
(4,'Monitor','Electronics',300);

INSERT INTO transactions VALUES
(101,1,'2025-03-01 10:15:00',1250),
(102,2,'2025-03-01 11:30:00',70),
(103,1,'2025-03-02 14:05:00',300),
(104,3,'2025-03-02 16:20:00',345);

INSERT INTO transaction_details VALUES
(1,101,1,1,1200),
(2,101,2,2,50),
(3,102,2,1,25),
(4,102,3,1,45),
(5,103,4,1,300),
(6,104,3,1,45),
(7,104,4,1,300);

SELECT 
    s.store_name,
    SUM(t.total_amount) AS total_sales
FROM transactions t
JOIN stores s
ON t.store_id = s.store_id
GROUP BY s.store_name
ORDER BY total_sales DESC;

SELECT 
    SUM(total_amount) AS total_revenue
FROM transactions;

SELECT 
    AVG(total_amount) AS avg_transaction_value
FROM transactions;

SELECT 
    CAST(transaction_time AS DATE) AS sales_date,
    SUM(total_amount) AS total_sales
FROM transactions
GROUP BY CAST(transaction_time AS DATE)
ORDER BY sales_date;

SELECT 
    DATEPART(HOUR, transaction_time) AS sales_hour,
    SUM(total_amount) AS total_sales
FROM transactions
GROUP BY DATEPART(HOUR, transaction_time)
ORDER BY sales_hour;

SELECT 
    product_name,
    total_sold,
    RANK() OVER (ORDER BY total_sold DESC) AS sales_rank
FROM (
    SELECT 
        p.product_name,
        SUM(td.quantity) AS total_sold
    FROM transaction_details td
    JOIN products p
        ON td.product_id = p.product_id
    GROUP BY p.product_name
) AS sales_summary;

SELECT 
    p.product_name,
    SUM(td.quantity) AS total_sold
FROM transaction_details td
JOIN products p
ON td.product_id = p.product_id
GROUP BY p.product_name