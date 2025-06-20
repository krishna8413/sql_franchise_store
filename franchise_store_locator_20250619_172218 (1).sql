
-- --------------------------------------------------
-- Franchise Store Locator & Manager Tool - MySQL 8.0+ Schema
-- Author: Krishna Dubey
-- --------------------------------------------------

-- DROP DATABASE IF EXISTS franchise_locator;
CREATE DATABASE IF NOT EXISTS franchise_locator;
USE franchise_locator;

-- --------------------------------------------------
-- 1. Countries Table
-- --------------------------------------------------
CREATE TABLE countries (
    country_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- --------------------------------------------------
-- 2. States Table
-- --------------------------------------------------
CREATE TABLE states (
    state_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    country_id INT NOT NULL,
    FOREIGN KEY (country_id) REFERENCES countries(country_id) ON DELETE CASCADE
);

-- --------------------------------------------------
-- 3. Cities Table
-- --------------------------------------------------
CREATE TABLE cities (
    city_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    state_id INT NOT NULL,
    FOREIGN KEY (state_id) REFERENCES states(state_id) ON DELETE CASCADE
);

-- --------------------------------------------------
-- 4. Franchises Table
-- --------------------------------------------------
CREATE TABLE franchises (
    franchise_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    contact_email VARCHAR(100),
    contact_phone VARCHAR(20),
    description TEXT
);

-- --------------------------------------------------
-- 5. Stores Table
-- --------------------------------------------------
CREATE TABLE stores (
    store_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    address TEXT,
    city_id INT NOT NULL,
    state_id INT NOT NULL,
    country_id INT NOT NULL,
    postal_code VARCHAR(10),
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6),
    franchise_id INT NOT NULL,
    status ENUM('open', 'closed', 'under renovation') DEFAULT 'open',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (city_id) REFERENCES cities(city_id),
    FOREIGN KEY (state_id) REFERENCES states(state_id),
    FOREIGN KEY (country_id) REFERENCES countries(country_id),
    FOREIGN KEY (franchise_id) REFERENCES franchises(franchise_id)
);

-- --------------------------------------------------
-- 6. Store Managers Table
-- --------------------------------------------------
CREATE TABLE managers (
    manager_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20)
);

CREATE TABLE store_managers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    store_id INT NOT NULL,
    manager_id INT NOT NULL,
    assigned_from DATE,
    assigned_to DATE,
    FOREIGN KEY (store_id) REFERENCES stores(store_id) ON DELETE CASCADE,
    FOREIGN KEY (manager_id) REFERENCES managers(manager_id) ON DELETE CASCADE
);

-- --------------------------------------------------
-- 7. Store Operating Hours Table
-- --------------------------------------------------
CREATE TABLE store_hours (
    hour_id INT AUTO_INCREMENT PRIMARY KEY,
    store_id INT NOT NULL,
    day_of_week ENUM('Mon','Tue','Wed','Thu','Fri','Sat','Sun') NOT NULL,
    open_time TIME,
    close_time TIME,
    FOREIGN KEY (store_id) REFERENCES stores(store_id) ON DELETE CASCADE
);

-- --------------------------------------------------
-- 8. Store Services Table (many-to-many)
-- --------------------------------------------------
CREATE TABLE services (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE store_services (
    id INT AUTO_INCREMENT PRIMARY KEY,
    store_id INT NOT NULL,
    service_id INT NOT NULL,
    FOREIGN KEY (store_id) REFERENCES stores(store_id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES services(service_id) ON DELETE CASCADE
);

-- --------------------------------------------------
-- ✅ SAMPLE DATA INSERTS (10+ rows per core table)
-- --------------------------------------------------

-- Countries
INSERT INTO countries (name) VALUES 
('India'), ('United States'), ('Canada');

-- States
INSERT INTO states (name, country_id) VALUES 
('Maharashtra', 1), ('California', 2), ('Ontario', 3);

-- Cities
INSERT INTO cities (name, state_id) VALUES 
('Mumbai', 1), ('Pune', 1), ('Los Angeles', 2), ('San Francisco', 2), ('Toronto', 3);

-- Franchises
INSERT INTO franchises (name, contact_email, contact_phone, description) VALUES
('Domino’s Pizza', 'contact@dominos.com', '18001010101', 'Global pizza franchise'),
('Starbucks', 'info@starbucks.com', '1800112233', 'Global coffeehouse chain');

-- Stores
INSERT INTO stores (name, address, city_id, state_id, country_id, postal_code, latitude, longitude, franchise_id, status)
VALUES
('Domino’s Andheri', '123 Main Street', 1, 1, 1, '400053', 19.119, 72.846, 1, 'open'),
('Domino’s Bandra', '456 Hill Road', 1, 1, 1, '400050', 19.060, 72.836, 1, 'under renovation'),
('Domino’s Pune Central', '789 MG Road', 2, 1, 1, '411001', 18.516, 73.856, 1, 'closed'),
('Starbucks Lokhandwala', '101 2nd Ave', 1, 1, 1, '400058', 19.140, 72.842, 2, 'open'),
('Starbucks Toronto', '200 King Street', 5, 3, 3, 'M5H 3T4', 43.648, -79.382, 2, 'open');

-- Managers
INSERT INTO managers (full_name, email, phone) VALUES
('Raj Mehta', 'raj@dominos.com', '9000011111'),
('Anjali Rao', 'anjali@starbucks.com', '9000022222'),
('Sahil Khan', 'sahil@dominos.com', '9000033333');

-- Store Managers
INSERT INTO store_managers (store_id, manager_id, assigned_from, assigned_to) VALUES
(1, 1, '2023-01-01', NULL),
(2, 1, '2022-01-01', '2023-01-01'),
(4, 2, '2023-05-01', NULL),
(3, 3, '2023-06-01', NULL);

-- Store Hours
INSERT INTO store_hours (store_id, day_of_week, open_time, close_time) VALUES
(1, 'Mon', '10:00:00', '22:00:00'),
(1, 'Tue', '10:00:00', '22:00:00'),
(1, 'Wed', '10:00:00', '22:00:00'),
(2, 'Mon', '11:00:00', '23:00:00'),
(4, 'Fri', '08:00:00', '20:00:00');

-- Services
INSERT INTO services (name) VALUES 
('Delivery'), ('Pickup'), ('Dine-in');

-- Store Services
INSERT INTO store_services (store_id, service_id) VALUES 
(1, 1), (1, 2), (2, 1), (4, 2), (4, 3), (5, 3);

-- --------------------------------------------------
-- ✅ SEARCH QUERIES
-- --------------------------------------------------

-- 🔍 1. Find stores by city
-- Find all stores in Mumbai
SELECT s.name, s.address
FROM stores s
JOIN cities c ON s.city_id = c.city_id
WHERE c.name = 'Mumbai';

-- 🔍 2. Find stores offering Pickup service
SELECT s.name, f.name AS franchise, sv.name AS service
FROM stores s
JOIN store_services ss ON s.store_id = ss.store_id
JOIN services sv ON ss.service_id = sv.service_id
JOIN franchises f ON s.franchise_id = f.franchise_id
WHERE sv.name = 'Pickup';

-- 🔍 3. Proximity Search (within 5 km of a location in Mumbai)
-- Uses Haversine formula
SELECT s.name, s.latitude, s.longitude,
       (6371 * ACOS(COS(RADIANS(19.119)) * COS(RADIANS(s.latitude)) * COS(RADIANS(s.longitude) - RADIANS(72.846)) + SIN(RADIANS(19.119)) * SIN(RADIANS(s.latitude)))) AS distance_km
FROM stores s
HAVING distance_km < 5;

-- --------------------------------------------------
-- ✅ REPORTING QUERIES
-- --------------------------------------------------

-- 📊 1. Total stores per franchise
SELECT f.name AS franchise, COUNT(*) AS total_stores
FROM stores s
JOIN franchises f ON s.franchise_id = f.franchise_id
GROUP BY f.name;

-- 📊 2. Stores by status
SELECT status, COUNT(*) AS count
FROM stores
GROUP BY status;

-- 📊 3. Managers managing multiple stores
SELECT m.full_name, COUNT(sm.store_id) AS total_stores
FROM store_managers sm
JOIN managers m ON sm.manager_id = m.manager_id
GROUP BY m.full_name
HAVING total_stores > 1;

-- --------------------------------------------------
-- END OF SQL FILE
-- --------------------------------------------------
