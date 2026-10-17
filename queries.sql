CREATE DATABASE vendor_project;
USE vendor_project;

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    vendor VARCHAR(10),
    order_date DATE,
    promised_date DATE,
    delivery_date DATE,
    qty INT,
    unit_cost INT
);

-- Query 1: lead time aur delay per order
SELECT order_id, vendor,
       DATEDIFF(delivery_date, order_date) AS lead_time,
       DATEDIFF(delivery_date, promised_date) AS delay_days
FROM orders
LIMIT 10;

-- Query 2: vendor scorecard
SELECT vendor,
       COUNT(*) AS total_orders,
       ROUND(AVG(DATEDIFF(delivery_date, order_date)), 1) AS avg_lead_time,
       ROUND(STDDEV_SAMP(DATEDIFF(delivery_date, order_date)), 2) AS lead_time_std,
       ROUND(SUM(delivery_date <= promised_date) * 100.0 / COUNT(*), 1) AS on_time_pct,
       ROUND(AVG(unit_cost), 0) AS avg_cost
FROM orders
GROUP BY vendor
ORDER BY on_time_pct DESC;