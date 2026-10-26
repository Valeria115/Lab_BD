-- 1. UNIQUE: повторяющийся email
BEGIN;
INSERT INTO customers (name, email)
VALUES ('Тестовый покупатель', 'anna@example.com');
ROLLBACK;

-- 2. UNIQUE: повторяющийся телефон
BEGIN;
INSERT INTO customers (name, email, phone)
VALUES ('Тестовый покупатель', 'test@example.com', '+79991112233');
ROLLBACK;

-- 3. CHECK: отрицательная цена товара
BEGIN;
INSERT INTO products (category_id, name, price, stock)
VALUES (1, 'Тестовый товар', -100, 10);
ROLLBACK;

-- 4. CHECK: отрицательный остаток
BEGIN;
INSERT INTO products (category_id, name, price, stock)
VALUES (1, 'Тестовый товар', 100, -5);
ROLLBACK;

-- 5. CHECK: недопустимый статус заказа
BEGIN;
INSERT INTO orders (customer_id, address_id, status)
VALUES (1, 1, 'unknown');
ROLLBACK;

-- 6. FOREIGN KEY: несуществующая категория
BEGIN;
INSERT INTO products (category_id, name, price, stock)
VALUES (9999, 'Тестовый товар', 100, 10);
ROLLBACK;

-- 7. CHECK: нулевое количество в заказе
BEGIN;
INSERT INTO order_items (order_id, product_id, quantity, price)
VALUES (1, 7, 0, 100);
ROLLBACK;

-- 8. CHECK: нулевая цена позиции заказа
BEGIN;
INSERT INTO order_items (order_id, product_id, quantity, price)
VALUES (1, 7, 1, 0);
ROLLBACK;

-- 9. Составной FOREIGN KEY: адрес 1 принадлежит покупателю 1, а заказ оформляется на покупателя 2

BEGIN;
INSERT INTO orders (customer_id, address_id, status)
VALUES (2, 1, 'new');
ROLLBACK;

-- 10. ON DELETE RESTRICT: удаление категории, в которой есть товары
BEGIN;
DELETE FROM categories WHERE id = 1;
ROLLBACK;

-- 11. ON DELETE RESTRICT: удаление товара, который есть в заказах
BEGIN;
DELETE FROM products WHERE id = 1;
ROLLBACK;

-- 12. ON DELETE RESTRICT: удаление покупателя, у которого есть заказы
BEGIN;
DELETE FROM customers WHERE id = 1;
ROLLBACK;
