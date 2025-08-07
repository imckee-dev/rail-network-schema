-- Railwork Network DML (Data Manipulation Language) Queries
-- By Ian McKee, Amit Guha
-- CS 340 Su25

-- READ (SELECT) Operations for all entities

-- RailYards
SELECT railyard_id, train_capacity FROM RailYards ORDER BY railyard_id;

-- Trains
SELECT train_id, train_name, engine_type FROM Trains ORDER BY train_id;

-- Shipments with readable yard names
SELECT 
    s.shipment_id, 
    s.description, 
    s.weight_tons,
    CONCAT('Yard ', s.origin_railyard_id) as origin_yard,
    CONCAT('Yard ', s.destination_railyard_id) as destination_yard
FROM Shipments s
ORDER BY s.shipment_id;

-- Containers with shipment details
SELECT 
    c.container_id,
    c.capacity_tons,
    CONCAT('Yard ', c.current_rail_id) as current_location,
    c.shipment_id,
    s.description as shipment_description
FROM Containers c
LEFT JOIN Shipments s ON c.shipment_id = s.shipment_id
ORDER BY c.container_id;

-- Container-Train relationships
SELECT 
    ct.container_id,
    ct.train_id,
    t.train_name,
    c.capacity_tons
FROM container_train ct
JOIN Trains t ON ct.train_id = t.train_id
JOIN Containers c ON ct.container_id = c.container_id
ORDER BY ct.container_id, ct.train_id;

-- CREATE Operations

-- Insert new RailYard
INSERT INTO RailYards (train_capacity) VALUES (?);

-- Insert new Train
INSERT INTO Trains (train_name, engine_type) VALUES (?, ?);

-- Insert new Shipment
INSERT INTO Shipments (description, weight_tons, origin_railyard_id, destination_railyard_id) 
VALUES (?, ?, ?, ?);

-- Insert new Container
INSERT INTO Containers (capacity_tons, current_rail_id, shipment_id) 
VALUES (?, ?, ?);

-- Assign Container to Train
INSERT INTO container_train (container_id, train_id) VALUES (?, ?);

-- UPDATE Operations

-- Update RailYard capacity
UPDATE RailYards SET train_capacity = ? WHERE railyard_id = ?;

-- Update Train details
UPDATE Trains SET train_name = ?, engine_type = ? WHERE train_id = ?;

-- Update Shipment
UPDATE Shipments 
SET description = ?, weight_tons = ?, origin_railyard_id = ?, destination_railyard_id = ?
WHERE shipment_id = ?;

-- Update Container
UPDATE Containers 
SET capacity_tons = ?, current_rail_id = ?, shipment_id = ?
WHERE container_id = ?;

-- DELETE Operations

-- Delete RailYard (must handle foreign key constraints)
DELETE FROM RailYards WHERE railyard_id = ?;

-- Delete Train
DELETE FROM Trains WHERE train_id = ?;

-- Delete Shipment
DELETE FROM Shipments WHERE shipment_id = ?;

-- Delete Container
DELETE FROM Containers WHERE container_id = ?;

-- Remove Container from Train assignment
DELETE FROM container_train WHERE container_id = ? AND train_id = ?;
