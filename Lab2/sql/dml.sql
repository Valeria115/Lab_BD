-- Задание 1.1
BEGIN;

INSERT INTO customers (id, name, email, phone) VALUES
(5,  'Елена Волкова',    'elena@example.com',   '+79994445566'),
(6,  'Дмитрий Орлов',    'dmitry@example.com',  '+79995556677'),
(7,  'Ольга Новикова',   'olga@example.com',    NULL),
(8,  'Сергей Фёдоров',   'sergey@example.com',  '+79996667788'),
(9,  'Татьяна Морозова', 'tatyana@example.com', '+79997778899'),
(10, 'Павел Зайцев',     'pavel@example.com',   NULL),
(11, 'Наталья Белова',   'natalia@example.com', '+79998889900'),
(12, 'Артём Громов',     'artem@example.com',   '+79990001122');

INSERT INTO addresses (id, customer_id, city, street, house, apartment) VALUES
(6,  5,  'Москва',          'Мира',             '12', '34'),
(7,  6,  'Санкт-Петербург', 'Садовая',          '8',  '5'),
(8,  6,  'Санкт-Петербург', 'Лиговский проспект', '100', NULL),
(9,  7,  'Казань',          'Пушкина',          '15', '9'),
(10, 8,  'Новосибирск',     'Красный проспект', '22', '71'),
(11, 9,  'Екатеринбург',    'Ленина',           '40', '3'),
(12, 9,  'Москва',          'Покровка',         '5',  NULL),
(13, 10, 'Казань',          'Кремлёвская',      '18', '27'),
(14, 11, 'Москва',          'Арбат',            '20', '14'),
(15, 12, 'Новосибирск',     'Советская',        '9',  '2');

INSERT INTO categories (id, name, description) VALUES
(4, 'Спорт',    'Спортивные товары и инвентарь'),
(5, 'Игрушки',  'Детские игрушки');

INSERT INTO products (id, category_id, name, description, price, stock) VALUES
(8,  1, 'Смартфон',            'Смартфон 128 ГБ',        24990.00, 7),
(9,  1, 'Зарядное устройство', 'Быстрая зарядка 65 Вт',   1590.00, 0),
(10, 2, 'Война и мир',         'Роман Льва Толстого',     1100.00, 20),
(11, 2, 'Чистый код',          NULL,                      1450.00, 11),
(12, 3, 'Плед',                'Тёплый флисовый плед',    1800.00, 15),
(13, 3, 'Набор посуды',        'Набор из 12 предметов',   3500.00, 6),
(14, 4, 'Гантели',             'Гантели 2 по 5 кг',       2800.00, 10),
(15, 4, 'Коврик для йоги',     NULL,                      1300.00, 25),
(16, 4, 'Велосипедный шлем',   'Шлем, размер M',          3200.00, 0),
(17, 1, 'Веб-камера',          'Full HD камера',          3900.00, 8);

-- Август
INSERT INTO orders (id, customer_id, address_id, order_date, status) VALUES
(5,  5,  6,  '2026-08-03 11:20:00', 'delivered'),
(6,  6,  7,  '2026-08-07 14:05:00', 'delivered'),
(7,  1,  1,  '2026-08-12 09:40:00', 'delivered'),
(8,  9,  11, '2026-08-15 19:10:00', 'delivered'),
(9,  11, 14, '2026-08-18 13:30:00', 'delivered'),
(10, 10, 13, '2026-08-21 17:00:00', 'cancelled'),
(11, 2,  3,  '2026-08-25 10:15:00', 'delivered'),
(12, 10, 13, '2026-08-29 15:45:00', 'delivered');

-- Сентябрь
INSERT INTO orders (id, customer_id, address_id, order_date, status) VALUES
(13, 5,  6,  '2026-09-02 12:00:00', 'delivered'),
(14, 6,  8,  '2026-09-05 16:30:00', 'delivered'),
(15, 9,  12, '2026-09-09 11:45:00', 'delivered'),
(16, 8,  10, '2026-09-12 20:10:00', 'cancelled'),
(17, 1,  2,  '2026-09-14 10:25:00', 'delivered'),
(18, 7,  9,  '2026-09-18 18:50:00', 'delivered'),
(19, 3,  4,  '2026-09-21 09:15:00', 'cancelled'),
(20, 5,  6,  '2026-09-24 14:40:00', 'delivered'),
(21, 10, 13, '2026-09-27 13:05:00', 'delivered'),
(22, 11, 14, '2026-09-29 17:35:00', 'delivered');

-- Октябрь
INSERT INTO orders (id, customer_id, address_id, order_date, status) VALUES
(23, 6,  7,  '2026-10-13 12:10:00', 'paid'),
(24, 5,  6,  '2026-10-14 15:20:00', 'shipped'),
(25, 9,  11, '2026-10-16 10:05:00', 'delivered'),
(26, 2,  3,  '2026-10-17 19:30:00', 'paid'),
(27, 5,  6,  '2026-10-19 11:00:00', 'new'),
(28, 1,  1,  '2026-10-20 16:45:00', 'shipped'),
(29, 6,  8,  '2026-10-22 09:30:00', 'new'),
(30, 9,  12, '2026-10-23 14:15:00', 'paid');

-- Состав заказов
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(5,  8,  1, 24990.00),
(5,  9,  1, 1590.00),
(6,  2,  1, 7500.00),
(6,  3,  1, 1990.00),
(7,  10, 1, 1100.00),
(7,  11, 1, 1450.00),
(8,  14, 1, 2800.00),
(8,  15, 2, 1300.00),
(9,  12, 1, 1800.00),
(9,  7,  2, 1200.00),
(10, 1,  1, 4990.00),
(11, 3,  2, 1990.00),
(11, 5,  1, 690.00),
(12, 16, 1, 3200.00),
(12, 15, 1, 1300.00),
(13, 1,  1, 4500.00),
(13, 3,  1, 1990.00),
(14, 11, 1, 1450.00),
(14, 4,  3, 850.00),
(15, 6,  1, 2200.00),
(15, 12, 2, 1800.00),
(16, 8,  1, 24990.00),
(17, 2,  1, 7000.00),
(17, 10, 2, 1100.00),
(18, 14, 1, 2800.00),
(19, 4,  1, 850.00),
(19, 5,  1, 690.00),
(20, 9,  2, 1590.00),
(20, 3,  1, 1990.00),
(21, 16, 1, 3200.00),
(21, 14, 1, 2800.00),
(22, 12, 1, 1800.00),
(22, 6,  1, 2200.00),
(23, 1,  1, 4990.00),
(23, 15, 1, 1300.00),
(24, 8,  1, 24990.00),
(24, 9,  1, 1590.00),
(25, 11, 1, 1450.00),
(25, 10, 1, 1100.00),
(25, 5,  1, 690.00),
(26, 2,  1, 7500.00),
(27, 1,  1, 4990.00),
(27, 7,  1, 1200.00),
(28, 6,  1, 2200.00),
(28, 12, 1, 1800.00),
(29, 14, 2, 2800.00),
(29, 15, 1, 1300.00),
(30, 16, 1, 3200.00),
(30, 7,  3, 1200.00);

SELECT setval(pg_get_serial_sequence('customers',  'id'), (SELECT MAX(id) FROM customers));
SELECT setval(pg_get_serial_sequence('addresses',  'id'), (SELECT MAX(id) FROM addresses));
SELECT setval(pg_get_serial_sequence('categories', 'id'), (SELECT MAX(id) FROM categories));
SELECT setval(pg_get_serial_sequence('products',   'id'), (SELECT MAX(id) FROM products));
SELECT setval(pg_get_serial_sequence('orders',     'id'), (SELECT MAX(id) FROM orders));

COMMIT;

SELECT 'customers' AS table_name, COUNT(*) AS rows_cnt FROM customers
UNION ALL SELECT 'addresses',   COUNT(*) FROM addresses
UNION ALL SELECT 'categories',  COUNT(*) FROM categories
UNION ALL SELECT 'products',    COUNT(*) FROM products
UNION ALL SELECT 'orders',      COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'ИТОГО', (SELECT COUNT(*) FROM customers) + (SELECT COUNT(*) FROM addresses)
    + (SELECT COUNT(*) FROM categories) + (SELECT COUNT(*) FROM products)
    + (SELECT COUNT(*) FROM orders) + (SELECT COUNT(*) FROM order_items);

-- Проверка распределения по статусам и месяцам
SELECT to_char(order_date, 'YYYY-MM') AS month, status, COUNT(*) AS orders_cnt
FROM orders
GROUP BY to_char(order_date, 'YYYY-MM'), status
ORDER BY month, status;


-- Задание 1.2
-- 1. INSERT
BEGIN;

INSERT INTO customers (name, email, phone)
VALUES ('Кирилл Лебедев', 'kirill@example.com', '+79991234567');

INSERT INTO addresses (customer_id, city, street, house, apartment)
SELECT c.id, 'Москва', 'Новый Арбат', '15', '7'
FROM customers c
WHERE c.email = 'kirill@example.com';

INSERT INTO orders (customer_id, address_id, order_date, status)
SELECT a.customer_id, a.id, '2026-10-24 12:00:00', 'new'
FROM addresses a
JOIN customers c ON c.id = a.customer_id
WHERE c.email = 'kirill@example.com';

INSERT INTO order_items (order_id, product_id, quantity, price)
SELECT o.id, p.id, v.qty, p.price
FROM orders o
JOIN customers c ON c.id = o.customer_id AND c.email = 'kirill@example.com'
JOIN (VALUES ('Наушники', 1), ('Мышь', 2)) AS v(product_name, qty) ON TRUE
JOIN products p ON p.name = v.product_name;

COMMIT;

SELECT c.name, o.id AS order_id, o.status, p.name AS product, oi.quantity, oi.price
FROM customers c
JOIN orders o       ON o.customer_id = c.id
JOIN order_items oi ON oi.order_id = o.id
JOIN products p     ON p.id = oi.product_id
WHERE c.email = 'kirill@example.com';

-- 2. UPDATE
UPDATE orders
SET status = 'paid'
WHERE id = 27 AND status = 'new';

SELECT id, status FROM orders WHERE id = 27;


-- 3. Массовый UPDATE по содержательному условию
UPDATE orders
SET status = 'shipped'
WHERE status = 'paid'
  AND order_date < '2026-10-15';

SELECT id, order_date::date AS order_date, status
FROM orders
WHERE order_date >= '2026-10-01'
ORDER BY id;


-- 4. DELETE с учётом ограничений целостности
SELECT COUNT(*) AS items_before FROM order_items WHERE order_id = 10;

DELETE FROM orders
WHERE id = 10 AND status = 'cancelled';

SELECT COUNT(*) AS items_after FROM order_items WHERE order_id = 10;   -- 0

-- Попытка удалить покупателя с заказами нарушает ограничение orders.customer_id ... ON DELETE RESTRICT и завершится ошибкой.
-- DELETE FROM customers WHERE email = 'anna@example.com';

INSERT INTO customers (name, email) VALUES ('Временный покупатель', 'temp@example.com');
INSERT INTO addresses (customer_id, city, street, house)
SELECT id, 'Москва', 'Тестовая', '1' FROM customers WHERE email = 'temp@example.com';

DELETE FROM customers WHERE email = 'temp@example.com';

SELECT COUNT(*) AS temp_left FROM customers WHERE email = 'temp@example.com';   -- 0


-- 5. ROLLBACK
SELECT id, name, price FROM products WHERE category_id = 1 ORDER BY id;

BEGIN;

UPDATE products
SET price = ROUND(price * 1.10, 2)
WHERE category_id = 1;

SELECT id, name, price FROM products WHERE category_id = 1 ORDER BY id;

ROLLBACK;

SELECT id, name, price FROM products WHERE category_id = 1 ORDER BY id;
