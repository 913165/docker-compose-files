-- PostgreSQL initialization script
-- This script runs when the container starts for the first time

-- Create extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Create users table
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    age INTEGER CHECK (age > 0 AND age < 150),
    role VARCHAR(50) NOT NULL,
    skills TEXT[],
    address JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT true
);

-- Create products table
CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(200) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    category VARCHAR(100) NOT NULL,
    brand VARCHAR(100),
    in_stock BOOLEAN DEFAULT true,
    quantity INTEGER DEFAULT 0 CHECK (quantity >= 0),
    specifications JSONB,
    tags TEXT[],
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create orders table
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id VARCHAR(50) UNIQUE NOT NULL,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount >= 0),
    status VARCHAR(50) NOT NULL DEFAULT 'pending',
    shipping_address JSONB,
    order_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    delivery_date TIMESTAMP WITH TIME ZONE,
    notes TEXT
);

-- Create order_items table (normalized approach)
CREATE TABLE order_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
    product_id UUID REFERENCES products(id) ON DELETE CASCADE,
    product_name VARCHAR(200) NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0),
    total_price DECIMAL(10,2) GENERATED ALWAYS AS (quantity * unit_price) STORED
);

-- Create categories table for better data organization
CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    parent_id UUID REFERENCES categories(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample categories
INSERT INTO categories (name, description) VALUES
    ('Electronics', 'Electronic devices and gadgets'),
    ('Home & Kitchen', 'Home appliances and kitchen equipment'),
    ('Books', 'Physical and digital books'),
    ('Clothing', 'Apparel and fashion items'),
    ('Sports & Outdoors', 'Sports equipment and outdoor gear');

-- Insert sample users
INSERT INTO users (name, email, age, role, skills, address) VALUES
    (
        'John Doe',
        'john.doe@example.com',
        30,
        'developer',
        ARRAY['JavaScript', 'Python', 'PostgreSQL', 'Docker'],
        '{"street": "123 Main St", "city": "New York", "state": "NY", "country": "USA", "zipCode": "10001"}'::jsonb
    ),
    (
        'Jane Smith',
        'jane.smith@example.com',
        28,
        'designer',
        ARRAY['UI/UX', 'Figma', 'Adobe Creative Suite', 'Sketch'],
        '{"street": "456 Oak Ave", "city": "San Francisco", "state": "CA", "country": "USA", "zipCode": "94102"}'::jsonb
    ),
    (
        'Bob Johnson',
        'bob.johnson@example.com',
        35,
        'manager',
        ARRAY['Leadership', 'Project Management', 'Strategy', 'Agile'],
        '{"street": "789 Pine Rd", "city": "Seattle", "state": "WA", "country": "USA", "zipCode": "98101"}'::jsonb
    ),
    (
        'Alice Brown',
        'alice.brown@example.com',
        26,
        'data_scientist',
        ARRAY['Python', 'R', 'Machine Learning', 'Statistics'],
        '{"street": "321 Elm St", "city": "Austin", "state": "TX", "country": "USA", "zipCode": "73301"}'::jsonb
    ),
    (
        'Charlie Wilson',
        'charlie.wilson@example.com',
        32,
        'devops',
        ARRAY['Docker', 'Kubernetes', 'AWS', 'Terraform'],
        '{"street": "654 Maple Dr", "city": "Denver", "state": "CO", "country": "USA", "zipCode": "80201"}'::jsonb
    );

-- Insert sample products
INSERT INTO products (name, description, price, category, brand, in_stock, quantity, specifications, tags) VALUES
    (
        'MacBook Pro 16"',
        'High-performance laptop for professionals and creatives',
        2499.99,
        'Electronics',
        'Apple',
        true,
        15,
        '{"processor": "M3 Pro", "ram": "18GB", "storage": "512GB SSD", "screen": "16.2-inch Liquid Retina XDR", "ports": ["Thunderbolt 4", "HDMI", "SDXC"], "weight": "2.1 kg"}'::jsonb,
        ARRAY['laptop', 'professional', 'apple', 'macbook']
    ),
    (
        'Wireless Gaming Mouse',
        'High-precision wireless gaming mouse with RGB lighting',
        79.99,
        'Electronics',
        'Logitech',
        true,
        120,
        '{"connectivity": "2.4GHz wireless + Bluetooth", "dpi": "25600", "battery": "70 hours", "rgb": true, "programmable_buttons": 6}'::jsonb,
        ARRAY['mouse', 'gaming', 'wireless', 'rgb']
    ),
    (
        'Smart Coffee Maker',
        'WiFi-enabled coffee maker with app control and scheduling',
        199.99,
        'Home & Kitchen',
        'Keurig',
        true,
        45,
        '{"capacity": "12 cups", "features": ["WiFi", "App Control", "Programmable", "Auto-brew"], "material": "Stainless Steel", "dimensions": "14.2 x 9.8 x 12.1 inches"}'::jsonb,
        ARRAY['coffee', 'smart', 'wifi', 'programmable']
    ),
    (
        'The Art of PostgreSQL',
        'Complete guide to PostgreSQL database development',
        45.99,
        'Books',
        'Tech Publications',
        true,
        30,
        '{"pages": 450, "format": "Paperback", "isbn": "978-0123456789", "language": "English", "edition": "2nd"}'::jsonb,
        ARRAY['book', 'postgresql', 'database', 'programming']
    ),
    (
        'Running Shoes Pro',
        'Professional running shoes with advanced cushioning',
        129.99,
        'Sports & Outdoors',
        'Nike',
        false,
        0,
        '{"size_range": "6-13", "material": "Mesh and synthetic", "cushioning": "Air Zoom", "weight": "280g", "drop": "10mm"}'::jsonb,
        ARRAY['shoes', 'running', 'sports', 'nike']
    ),
    (
        'Bluetooth Headphones',
        'Noise-cancelling over-ear headphones with 30h battery',
        249.99,
        'Electronics',
        'Sony',
        true,
        75,
        '{"battery_life": "30 hours", "noise_cancelling": true, "connectivity": ["Bluetooth 5.2", "3.5mm jack"], "driver_size": "40mm", "weight": "254g"}'::jsonb,
        ARRAY['headphones', 'bluetooth', 'noise-cancelling', 'sony']
    );

-- Get user and product IDs for orders
DO $$
DECLARE
    john_id UUID;
    jane_id UUID;
    bob_id UUID;
    alice_id UUID;
    macbook_id UUID;
    mouse_id UUID;
    coffee_id UUID;
    book_id UUID;
    headphones_id UUID;
    order1_id UUID;
    order2_id UUID;
    order3_id UUID;
BEGIN
    -- Get user IDs
    SELECT id INTO john_id FROM users WHERE email = 'john.doe@example.com';
    SELECT id INTO jane_id FROM users WHERE email = 'jane.smith@example.com';
    SELECT id INTO bob_id FROM users WHERE email = 'bob.johnson@example.com';
    SELECT id INTO alice_id FROM users WHERE email = 'alice.brown@example.com';
    
    -- Get product IDs
    SELECT id INTO macbook_id FROM products WHERE name = 'MacBook Pro 16"';
    SELECT id INTO mouse_id FROM products WHERE name = 'Wireless Gaming Mouse';
    SELECT id INTO coffee_id FROM products WHERE name = 'Smart Coffee Maker';
    SELECT id INTO book_id FROM products WHERE name = 'The Art of PostgreSQL';
    SELECT id INTO headphones_id FROM products WHERE name = 'Bluetooth Headphones';
    
    -- Insert sample orders
    INSERT INTO orders (order_id, user_id, total_amount, status, shipping_address, order_date, delivery_date) VALUES
        (
            'ORD-2024-001',
            john_id,
            2579.98,
            'delivered',
            '{"street": "123 Main St", "city": "New York", "state": "NY", "country": "USA", "zipCode": "10001"}'::jsonb,
            '2024-08-15 10:30:00',
            '2024-08-18 14:22:00'
        ),
        (
            'ORD-2024-002',
            jane_id,
            449.98,
            'shipped',
            '{"street": "456 Oak Ave", "city": "San Francisco", "state": "CA", "country": "USA", "zipCode": "94102"}'::jsonb,
            '2024-09-01 09:15:00',
            NULL
        ),
        (
            'ORD-2024-003',
            alice_id,
            45.99,
            'pending',
            '{"street": "321 Elm St", "city": "Austin", "state": "TX", "country": "USA", "zipCode": "73301"}'::jsonb,
            '2024-09-05 16:45:00',
            NULL
        );
    
    -- Get order IDs
    SELECT id INTO order1_id FROM orders WHERE order_id = 'ORD-2024-001';
    SELECT id INTO order2_id FROM orders WHERE order_id = 'ORD-2024-002';
    SELECT id INTO order3_id FROM orders WHERE order_id = 'ORD-2024-003';
    
    -- Insert order items
    INSERT INTO order_items (order_id, product_id, product_name, quantity, unit_price) VALUES
        -- Order 1: John's order
        (order1_id, macbook_id, 'MacBook Pro 16"', 1, 2499.99),
        (order1_id, mouse_id, 'Wireless Gaming Mouse', 1, 79.99),
        
        -- Order 2: Jane's order
        (order2_id, coffee_id, 'Smart Coffee Maker', 1, 199.99),
        (order2_id, headphones_id, 'Bluetooth Headphones', 1, 249.99),
        
        -- Order 3: Alice's order
        (order3_id, book_id, 'The Art of PostgreSQL', 1, 45.99);
END $$;

-- Create indexes for better performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_active ON users(is_active);
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_products_brand ON products(brand);
CREATE INDEX idx_products_price ON products(price);
CREATE INDEX idx_products_name_trgm ON products USING gin(name gin_trgm_ops);
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_date ON orders(order_date);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);

-- Create a view for order summary
CREATE VIEW order_summary AS
SELECT 
    o.id,
    o.order_id,
    u.name as customer_name,
    u.email as customer_email,
    o.total_amount,
    o.status,
    o.order_date,
    o.delivery_date,
    COUNT(oi.id) as item_count
FROM orders o
JOIN users u ON o.user_id = u.id
LEFT JOIN order_items oi ON o.id = oi.order_id
GROUP BY o.id, o.order_id, u.name, u.email, o.total_amount, o.status, o.order_date, o.delivery_date
ORDER BY o.order_date DESC;

-- Create a function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers to automatically update updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON products
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Insert some additional sample data for testing
INSERT INTO users (name, email, age, role, skills, address, is_active) VALUES
    (
        'Test User',
        'test@example.com',
        25,
        'tester',
        ARRAY['Testing', 'QA', 'Automation'],
        '{"street": "Test St", "city": "Test City", "state": "TC", "country": "USA", "zipCode": "12345"}'::jsonb,
        false
    );

-- Display initialization summary
DO $$
BEGIN
    RAISE NOTICE '=== PostgreSQL Database Initialization Complete ===';
    RAISE NOTICE 'Database: myapp';
    RAISE NOTICE 'Tables created: users, products, orders, order_items, categories';
    RAISE NOTICE 'Users count: %', (SELECT COUNT(*) FROM users);
    RAISE NOTICE 'Products count: %', (SELECT COUNT(*) FROM products);
    RAISE NOTICE 'Orders count: %', (SELECT COUNT(*) FROM orders);
    RAISE NOTICE 'Order items count: %', (SELECT COUNT(*) FROM order_items);
    RAISE NOTICE 'Categories count: %', (SELECT COUNT(*) FROM categories);
    RAISE NOTICE 'Extensions: uuid-ossp, pgcrypto';
    RAISE NOTICE 'Views created: order_summary';
    RAISE NOTICE 'Indexes and triggers created for performance';
END $$;
