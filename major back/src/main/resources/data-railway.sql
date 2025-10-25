-- Railway PostgreSQL Database Initialization
-- This script initializes the database with required data

-- Insert sample products for testing
INSERT INTO products (id, name, description, base_price, carbon_footprint, category, manufacturer, created_at) VALUES
(1, 'Eco-Friendly Laptop', 'Energy-efficient laptop with low carbon footprint', 50000.00, 125.0, 'Electronics', 'GreenTech Inc', NOW()),
(2, 'Solar Panel Kit', 'Residential solar panel installation kit', 25000.00, 50.0, 'Energy', 'SolarCorp', NOW()),
(3, 'Electric Vehicle', 'Zero-emission electric car', 500000.00, 200.0, 'Transportation', 'EcoMotors', NOW()),
(4, 'Organic Cotton T-Shirt', 'Sustainable clothing made from organic cotton', 500.00, 2.5, 'Clothing', 'EcoWear', NOW()),
(5, 'LED Light Bulb', 'Energy-efficient LED lighting', 200.00, 0.5, 'Lighting', 'BrightGreen', NOW())
ON CONFLICT (id) DO NOTHING;

-- Insert sample green projects
INSERT INTO green_projects (id, name, description, target_funding, current_funding, carbon_reduction_target, status, created_at) VALUES
(1, 'Solar Farm Initiative', 'Large-scale solar farm to reduce carbon emissions', 10000000.00, 0.00, 5000.0, 'ACTIVE', NOW()),
(2, 'Tree Planting Program', 'Community tree planting for carbon sequestration', 500000.00, 0.00, 1000.0, 'ACTIVE', NOW()),
(3, 'Wind Energy Project', 'Offshore wind farm development', 50000000.00, 0.00, 10000.0, 'PLANNING', NOW())
ON CONFLICT (id) DO NOTHING;

-- Insert sample users
INSERT INTO users (id, username, email, wallet_address, role, created_at) VALUES
(1, 'admin', 'admin@carbontax.com', '0x1234567890123456789012345678901234567890', 'ADMIN', NOW()),
(2, 'government', 'gov@carbontax.com', '0x2345678901234567890123456789012345678901', 'GOVERNMENT', NOW()),
(3, 'citizen', 'citizen@carbontax.com', '0x3456789012345678901234567890123456789012', 'CITIZEN', NOW())
ON CONFLICT (id) DO NOTHING;
