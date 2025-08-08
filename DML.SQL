-- IMPORTANT: ADD A `USE cs340_your_onid_database;` Before running.
-- USE cs340_mckeei;

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

-- note: shipments are >1, railyards >100, containers >200, trains >300

-- CREATE Operations

-- Insert new RailYard
INSERT INTO RailYards (train_capacity) VALUES (20);

-- Insert new Train
INSERT INTO Trains (train_name, engine_type) VALUES ('Express Alpha', 'Diesel');

-- Insert new Shipment
INSERT INTO Shipments (description, weight_tons, origin_railyard_id, destination_railyard_id) 
VALUES ('Electronics cargo', 15.5, 101, 103);


-- Insert new Container
INSERT INTO Containers (capacity_tons, current_railyard_id, shipment_id) 
VALUES (20, 101, 5);


-- Assign Container to Train
INSERT INTO container_train (container_id, train_id) VALUES (205, 302);

-- UPDATE Operations

-- Update RailYard capacity
UPDATE RailYards SET train_capacity = 25 WHERE railyard_id = 101;

-- Update Train details
UPDATE Trains SET train_name = 'Express Beta', engine_type = 'Electric' WHERE train_id = 302;

-- Update Shipment
UPDATE Shipments 
SET description = 'Updated electronics cargo', weight_tons = 16, origin_railyard_id = 101, destination_railyard_id = 104
WHERE shipment_id = 5;

-- Update Container
UPDATE Containers 
SET capacity_tons = 22, current_railyard_id = 102, shipment_id = 6
WHERE container_id = 205;

-- DELETE Operations

-- Delete RailYard (must handle foreign key constraints)
DELETE FROM RailYards WHERE railyard_id = 103;

-- Delete Train
DELETE FROM Trains WHERE train_id = 304;

-- Delete Shipment
DELETE FROM Shipments WHERE shipment_id = 5;

-- Delete Container
DELETE FROM Containers WHERE container_id = 205;

-- Remove Container from Train assignment
DELETE FROM container_train WHERE container_id = 205 AND train_id = 302;
