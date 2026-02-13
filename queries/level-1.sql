-- 1. List all active products with stock = 0
SELECT * FROM products WHERE stock = 0 AND is_active;

-- 2. Find users who have never placed an order
SELECT *
FROM users
WHERE
    NOT EXISTS (
        SELECT 1
        FROM orders
        WHERE
            orders.user_id = users.id
    );

-- 3. Find sellers who are not verified but have rating > 4.5.
SELECT * FROM sellers WHERE NOT verified AND rating > 4.5;

-- 4. List the 10 most expensive products in each category.
WITH
    ranked_products AS (
        SELECT
            c.name AS category_name,
            p.name,
            p.price,
            ROW_NUMBER() OVER (
                PARTITION BY
                    p.category_id
                ORDER BY p.price DESC
            ) AS ranking
        FROM products p
            JOIN categories c ON p.category_id = c.id
    )
SELECT *
FROM ranked_products
WHERE
    ranking <= 10;

-- 5. Find orders where total_amount does NOT match sum(order_items.quantity * unit_price)

-- no diff display ver.
SELECT *
FROM orders o
WHERE
    o.total_amount != (
        SELECT SUM(oi.unit_price * oi.quantity)
        FROM order_items oi
        WHERE
            oi.order_id = o.id
    )

-- with diff display ver.
WITH
    order_totals AS (
        SELECT order_id, sum(unit_price * quantity) AS calculated_amount
        FROM order_items
        GROUP BY
            order_id
    )
SELECT o.*, ot.calculated_amount
FROM orders o
    JOIN order_totals ot ON o.id = ot.order_id
WHERE
    o.total_amount != ot.calculated_amount
