CREATE TABLE IF NOT EXISTS users (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    country VARCHAR(50),
    is_seller BOOLEAN DEFAULT FALSE NOT NULL
);

CREATE TABLE IF NOT EXISTS sellers (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id INT REFERENCES users (id) UNIQUE NOT NULL,
    store_name VARCHAR(100) NOT NULL,
    rating DECIMAL(3, 2) CHECK (rating BETWEEN 1 AND 5),
    verified BOOLEAN DEFAULT FALSE NOT NULL
);

CREATE TABLE IF NOT EXISTS categories (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    parent_id INT REFERENCES categories (id)
);

CREATE TABLE IF NOT EXISTS products (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    seller_id INT REFERENCES sellers (id) NOT NULL,
    category_id INT REFERENCES categories (id) NOT NULL,
    name VARCHAR(150) NOT NULL,
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    stock INT NOT NULL DEFAULT 0 CHECK (stock >= 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    is_active BOOLEAN NOT NULL
);

CREATE TYPE order_status AS ENUM (
    'pending','shipped', 'delivered', 'cancelled'
);

CREATE TABLE IF NOT EXISTS orders (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id INT REFERENCES users (id) NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    status order_status NOT NULL,
    total_amount DECIMAL(10, 2) DEFAULT 0 NOT NULL
);

CREATE TABLE IF NOT EXISTS order_items (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id INT REFERENCES orders (id) NOT NULL,
    product_id INT REFERENCES products (id) NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10, 2) NOT NULL
);

CREATE TYPE payment_method AS ENUM (
    'card', 'paypal', 'crypto'
);

CREATE TYPE payment_status AS ENUM (
    'paid', 'failed', 'refunded'
);

CREATE TABLE IF NOT EXISTS payments (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id INT REFERENCES orders (id) NOT NULL,
    payment_method payment_method NOT NULL,
    payment_status payment_status NOT NULL,
    paid_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS reviews (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_id INT REFERENCES products (id) NOT NULL,
    user_id INT REFERENCES users (id) NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    COMMENT TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);
