-- Запрос 2.1.1
-- Задача: оператору нужна полная картина по каждой позиции каждого заказа: кто купил, куда доставить, какой товар и из какой категории
SELECT
    o.id AS order_id,
    o.order_date::date AS order_date,
    o.status,
    c.name AS customer,
    a.city,
    a.street || ', д. ' || a.house || COALESCE(', кв. ' || a.apartment, '') AS address,
    cat.name AS category,
    p.name AS product,
    oi.quantity,
    oi.price,
    oi.quantity * oi.price AS line_total
FROM orders o
JOIN customers c ON c.id = o.customer_id
JOIN addresses a ON a.id = o.address_id AND a.customer_id = o.customer_id
JOIN order_items oi ON oi.order_id = o.id
JOIN products p ON p.id = oi.product_id
JOIN categories cat ON cat.id = p.category_id
ORDER BY o.order_date, o.id, p.name;


-- Запрос 2.1.2
-- Задача: нужен список зарегистрированных, но ни разу не покупавших клиентов, с их адресами
SELECT
    c.id,
    c.name,
    c.email,
    COALESCE(c.phone, 'не указан') AS phone,
    COALESCE(a.city, 'адрес не указан') AS city,
    a.street
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.id
LEFT JOIN addresses a ON a.customer_id = c.id
WHERE o.id IS NULL
ORDER BY c.id;


-- Запрос 2.1.3
-- Задача: найти позиции заказов, одновременно удовлетворяющие условиям:
--  - адрес доставки в Москве;
--  - товар из категории «Электроника»;
--  - заказ не отменён и сделан с 01.09.2026;
--  - сумма позиции не меньше 5000.
SELECT
    o.id AS order_id,
    o.order_date::date AS order_date,
    o.status,
    c.name AS customer,
    p.name AS product,
    oi.quantity * oi.price AS line_total
FROM orders o
JOIN customers c ON c.id = o.customer_id
JOIN addresses a ON a.id = o.address_id AND a.customer_id = o.customer_id
JOIN order_items oi ON oi.order_id = o.id
JOIN products p ON p.id = oi.product_id
JOIN categories cat ON cat.id = p.category_id
WHERE a.city = 'Москва'
  AND cat.name = 'Электроника'
  AND o.status <> 'cancelled'
  AND o.order_date >= '2026-09-01'
  AND oi.quantity * oi.price >= 5000
ORDER BY line_total DESC;


-- Запрос 2.2.1
-- Задача: сколько заказов, единиц и денег приносит каждая категория, каков разброс цен продажи
SELECT
    cat.name AS category,
    COUNT(DISTINCT o.id) AS orders_cnt,
    SUM(oi.quantity) AS units_sold,
    SUM(oi.quantity * oi.price) AS revenue,
    ROUND(AVG(oi.price), 2) AS avg_unit_price,
    MIN(oi.price) AS min_unit_price,
    MAX(oi.price) AS max_unit_price
FROM categories cat
JOIN products p ON p.category_id = cat.id
JOIN order_items oi ON oi.product_id = p.id
JOIN orders o ON o.id = oi.order_id
WHERE o.status <> 'cancelled'
GROUP BY cat.id, cat.name
ORDER BY revenue DESC;


-- Запрос 2.2.2
-- Задача: найти покупателей, сделавших не менее двух заказов и потративших больше 10_000
SELECT
    c.name,
    COUNT(DISTINCT o.id) AS orders_cnt,
    SUM(oi.quantity * oi.price) AS total_spent,
    ROUND(SUM(oi.quantity * oi.price) / COUNT(DISTINCT o.id), 2) AS avg_check,
    MAX(o.order_date)::date AS last_order_date
FROM customers c
JOIN orders o ON o.customer_id = c.id
JOIN order_items oi ON oi.order_id = o.id
WHERE o.status <> 'cancelled'
GROUP BY c.id, c.name
HAVING COUNT(DISTINCT o.id) >= 2
   AND SUM(oi.quantity * oi.price) > 10000
ORDER BY total_spent DESC;


-- Запрос 2.2.3
-- Задача: как менялись активность и доля отмен от месяца к месяцу
SELECT
    to_char(o.order_date, 'YYYY-MM') AS month,
    COUNT(DISTINCT o.id) AS orders_total,
    COUNT(DISTINCT o.id) FILTER (WHERE o.status = 'cancelled') AS cancelled_cnt,
    SUM(oi.quantity * oi.price) FILTER (WHERE o.status <> 'cancelled') AS revenue,
    ROUND(AVG(oi.quantity * oi.price) FILTER (WHERE o.status <> 'cancelled'), 2) AS avg_line_total,
    MAX(oi.quantity * oi.price) FILTER (WHERE o.status <> 'cancelled') AS max_line_total
FROM orders o
JOIN order_items oi ON oi.order_id = o.id
GROUP BY to_char(o.order_date, 'YYYY-MM')
ORDER BY month;

-- Запрос 3.1. Товары дороже средней цены своей категории
SELECT
    p.id,
    p.name,
    cat.name AS category,
    p.price,
    ROUND(ca.avg_price, 2) AS category_avg_price,
    ROUND(p.price - ca.avg_price, 2) AS above_avg_by
FROM products p
JOIN categories cat ON cat.id = p.category_id
JOIN (
    SELECT category_id, AVG(price) AS avg_price
    FROM products
    GROUP BY category_id
) ca ON ca.category_id = p.category_id
WHERE p.price > ca.avg_price
ORDER BY cat.name, p.price DESC;


-- Запрос 3.2. EXISTS: покупатели с недавними отменёнными заказами
SELECT c.id, c.name, c.email, c.phone
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.id
      AND o.status = 'cancelled'
      AND o.order_date >= '2026-09-01'
)
ORDER BY c.id;


-- Запрос 3.3. NOT EXISTS: «уснувшие» клиенты
-- Покупал до октября, но в октябре заказов нет: кандидат на возвращающую рассылку
SELECT
    c.id,
    c.name,
    c.email,
    (SELECT MAX(o.order_date)::date
     FROM orders o
     WHERE o.customer_id = c.id) AS last_order_date
FROM customers c
WHERE EXISTS (
        SELECT 1
        FROM orders o
        WHERE o.customer_id = c.id
          AND o.status <> 'cancelled'
          AND o.order_date < '2026-10-01'
    )
  AND NOT EXISTS (
        SELECT 1
        FROM orders o
        WHERE o.customer_id = c.id
          AND o.order_date >= '2026-10-01'
    )
ORDER BY last_order_date;


-- Запрос 3.4. Коррелированные подзапросы: профиль каждого покупателя
SELECT
    c.id,
    c.name,
    (SELECT MAX(o.order_date)::date
     FROM orders o
     WHERE o.customer_id = c.id
       AND o.status <> 'cancelled') AS last_order_date,
    (SELECT COUNT(*)
     FROM orders o
     WHERE o.customer_id = c.id
       AND o.status = 'delivered') AS delivered_cnt,
    (SELECT COALESCE(SUM(oi.quantity * oi.price), 0)
     FROM orders o
     JOIN order_items oi ON oi.order_id = o.id
     WHERE o.customer_id = c.id
       AND o.status <> 'cancelled') AS total_spent
FROM customers c
ORDER BY total_spent DESC, c.id;



-- ЧАСТЬ 4. Комплексный отчёт с использованием CTE
-- Какие покупатели приносят больше всего выручки, какой у них средний чек и любимая категория, и к какому сегменту их отнести?
WITH params AS (
    SELECT DATE '2026-10-24' AS report_date,
           30000::numeric AS vip_threshold,
           3 AS regular_orders,
           21 AS dormant_days
),
order_lines AS (
    -- строки неотменённых заказов с категорией и суммой
    SELECT o.id AS order_id,
           o.customer_id,
           o.order_date::date AS order_day,
           cat.name AS category_name,
           oi.quantity * oi.price AS line_total
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.id
    JOIN products p ON p.id = oi.product_id
    JOIN categories cat ON cat.id = p.category_id
    WHERE o.status <> 'cancelled'
),
order_totals AS (
    -- сумма по каждому заказу
    SELECT order_id,
           customer_id,
           order_day,
           SUM(line_total) AS order_total
    FROM order_lines
    GROUP BY order_id, customer_id, order_day
),
customer_stats AS (
    -- показатели по покупателям
    SELECT customer_id,
           COUNT(*) AS orders_cnt,
           SUM(order_total) AS revenue,
           ROUND(AVG(order_total), 2) AS avg_check,
           MAX(order_day) AS last_order_day
    FROM order_totals
    GROUP BY customer_id
),
category_spend AS (
    -- выручка по категориям для каждого покупателя
    SELECT customer_id,
           category_name,
           SUM(line_total) AS category_revenue,
           ROW_NUMBER() OVER (
               PARTITION BY customer_id
               ORDER BY SUM(line_total) DESC, category_name
           ) AS rn
    FROM order_lines
    GROUP BY customer_id, category_name
)
-- итоговый отчёт
SELECT
    c.id,
    c.name,
    COALESCE(s.orders_cnt, 0) AS orders_cnt,
    COALESCE(s.revenue, 0) AS revenue,
    s.avg_check,
    fav.category_name AS favorite_category,
    s.last_order_day,
    prm.report_date - s.last_order_day AS days_since_last_order,
    ROUND(100.0 * s.revenue / SUM(s.revenue) OVER (), 1) AS revenue_share_pct,
    CASE
        WHEN s.customer_id IS NULL THEN 'Нет покупок'
        WHEN s.revenue >= prm.vip_threshold THEN 'VIP'
        WHEN s.orders_cnt >= prm.regular_orders THEN 'Постоянный'
        WHEN prm.report_date - s.last_order_day >= prm.dormant_days THEN 'Уснувший'
        ELSE 'Активный'
END AS segment
FROM customers c
CROSS JOIN params prm
LEFT JOIN customer_stats s ON s.customer_id = c.id
LEFT JOIN category_spend fav ON fav.customer_id = c.id AND fav.rn = 1
ORDER BY s.revenue DESC NULLS LAST, c.name;
