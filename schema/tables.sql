CREATE TABLE IF NOT EXISTS users (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    created_at TIMESTAMP,
    country VARCHAR(50),
    is_seller BOOLEAN
);

CREATE TABLE IF NOT EXISTS sellers (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id INT REFERENCES users (id),
    store_name VARCHAR(100),
    rating DECIMAL(3, 2),
    verified BOOLEAN
);

CREATE TABLE IF NOT EXISTS categories (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100),
    parent_id INT REFERENCES categories (id)
);

CREATE TABLE IF NOT EXISTS products (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    seller_id INT REFERENCES sellers (id),
    category_id INT REFERENCES categories (id),
    name VARCHAR(150),
    price DECIMAL(10, 2),
    stock INT,
    created_at TIMESTAMP,
    is_active BOOLEAN
);

CREATE TABLE IF NOT EXISTS orders (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id INT REFERENCES users (id),
    order_date TIMESTAMP,
    status VARCHAR(30), -- pending, shipped, delivered, cancelled
    total_amount DECIMAL(10, 2)
);

CREATE TABLE IF NOT EXISTS order_items (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id INT REFERENCES orders (id),
    product_id INT REFERENCES products (id),
    quantity INT,
    unit_price DECIMAL(10, 2)
);

CREATE TABLE IF NOT EXISTS payments (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id INT REFERENCES orders (id),
    payment_method VARCHAR(50), -- card, paypal, crypto
    payment_status VARCHAR(30), -- paid, failed, refunded
    paid_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS reviews (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_id INT REFERENCES products (id),
    user_id INT REFERENCES users (id),
    rating INT, -- 1-5
    COMMENT TEXT,
    created_at TIMESTAMP
);
