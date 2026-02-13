-- 6. Total revenue per seller (only delivered orders).
SELECT p.seller_id, SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM
    order_items oi
    JOIN orders o ON oi.order_id = o.id
    JOIN products p ON oi.product_id = p.id
WHERE
    o.status = 'delivered'
GROUP BY
    p.seller_id
ORDER BY p.seller_id;

-- 7. Top 5 users by total spending.
SELECT u.id, SUM(o.total_amount) AS total_spending
FROM users u
    JOIN orders o ON u.id = o.user_id
GROUP BY
    u.id
ORDER BY total_spending DESC
LIMIT 5;

-- 8. Average product rating per seller.
SELECT p.seller_id, ROUND(AVG(r.rating), 2) AS average_rating
FROM products p
    LEFT JOIN reviews r ON r.product_id = p.id
GROUP BY
    p.seller_id
ORDER BY p.seller_id;

-- 9. Category with highest revenue.
SELECT c.name, sum(oi.quantity * oi.unit_price) AS total_revenue
FROM
    order_items oi
    JOIN orders o ON oi.order_id = o.id
    JOIN products p ON oi.product_id = p.id
    JOIN categories c ON p.category_id = c.id
WHERE
    o.status = 'delivered'
GROUP BY
    c.id,
    c.name
ORDER BY total_revenue DESC
LIMIT 1;

-- 10. Monthly revenue for the last 6 months.
-- Turns out my data has orders from dates that haven't happened yet so it shows more months than it should
SELECT TO_CHAR(
        date_trunc('month', o.order_date), 'YYYY-MM'
    ) AS MONTH, sum(o.total_amount) AS monthly_revenue
FROM orders o
WHERE
    o.status = 'delivered'
    AND o.order_date >= CURRENT_DATE - INTERVAL '6 months'
GROUP BY
    MONTH
ORDER BY MONTH DESC
