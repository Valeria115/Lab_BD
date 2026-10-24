CREATE TABLE customers (
    id BIGSERIAL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_customers PRIMARY KEY (id),
    CONSTRAINT uq_customers_email UNIQUE (email),
    CONSTRAINT uq_customers_phone UNIQUE (phone)
);

CREATE TABLE addresses (
    id BIGSERIAL,
    customer_id BIGINT NOT NULL,
    city VARCHAR(100) NOT NULL,
    street VARCHAR(150) NOT NULL,
    house VARCHAR(20) NOT NULL,
    apartment VARCHAR(20),

    CONSTRAINT pk_addresses PRIMARY KEY (id),
    CONSTRAINT fk_addresses_customer
        FOREIGN KEY (customer_id) REFERENCES customers (id)
        ON DELETE CASCADE,
    CONSTRAINT uq_addresses_id_customer UNIQUE (id, customer_id)
);

CREATE TABLE categories (
    id BIGSERIAL,
    name VARCHAR(100) NOT NULL,
    description TEXT,

    CONSTRAINT pk_categories PRIMARY KEY (id),
    CONSTRAINT uq_categories_name UNIQUE (name)
);

CREATE TABLE products (
    id BIGSERIAL,
    category_id BIGINT NOT NULL,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    price NUMERIC(10, 2) NOT NULL,
    stock INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_products PRIMARY KEY (id),
    CONSTRAINT fk_products_category
        FOREIGN KEY (category_id) REFERENCES categories (id)
        ON DELETE RESTRICT,
    CONSTRAINT ck_products_price CHECK (price > 0),
    CONSTRAINT ck_products_stock CHECK (stock >= 0)
);

CREATE TABLE orders (
    id BIGSERIAL,
    customer_id BIGINT NOT NULL,
    address_id BIGINT NOT NULL,
    order_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL,

    CONSTRAINT pk_orders PRIMARY KEY (id),
    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id) REFERENCES customers (id)
        ON DELETE RESTRICT,
    CONSTRAINT fk_orders_addresses_customer
        FOREIGN KEY (address_id, customer_id) REFERENCES addresses (id, customer_id)
        ON DELETE RESTRICT,
    CONSTRAINT ck_orders_status
        CHECK (status IN ('new', 'paid', 'shipped', 'delivered', 'cancelled'))
);

CREATE TABLE order_items (
    order_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INTEGER NOT NULL,
    price NUMERIC(10, 2) NOT NULL,

    CONSTRAINT pk_order_items PRIMARY KEY (order_id, product_id),
    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id) REFERENCES orders (id)
        ON DELETE CASCADE,
    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id) REFERENCES products (id)
        ON DELETE RESTRICT,
    CONSTRAINT ck_order_items_quantity CHECK (quantity > 0),
    CONSTRAINT ck_order_items_price CHECK (price > 0)
);
