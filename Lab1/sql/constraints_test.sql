-- 1. Проверка UNIQUE: повторяющийся email
INSERT INTO customers (name, email)
VALUES ('Тестовый покупатель', '[anna@example.com](mailto:anna@example.com)');

-- 2. Проверка CHECK: отрицательная цена
INSERT INTO products (category_id, name, price, stock)
VALUES (1, 'Тестовый товар', -100, 10);

-- 3. Проверка CHECK: отрицательный остаток
INSERT INTO products (category_id, name, price, stock)
VALUES (1, 'Тестовый товар', 100, -5);

-- 4. Проверка CHECK: недопустимый статус заказа
INSERT INTO orders (customer_id, address_id, status)
VALUES (1, 1, 'unknown');

-- 5. Проверка внешнего ключа: несуществующая категория
INSERT INTO products (category_id, name, price, stock)
VALUES (9999, 'Тестовый товар', 100, 10);

-- 6. Проверка CHECK: нулевое количество товара в заказе
INSERT INTO order_items (order_id, product_id, quantity, price)
VALUES (1, 1, 0, 100);
