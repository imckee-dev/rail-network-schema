-- IMPORTANT: ADD A `USE cs340_your_onid_database;` Before running.
-- USE cs340_mckeei;

-- Next: Data Manipulation Language (our required queries)


-- SELECT for each table

SELECT * FROM RailYards;

SELECT * FROM Trains;

SELECT * FROM Shipments;

SELECT * FROM Containers;

-- intersection table
SELECT * FROM container_train;



INSERT INTO Containers (capacity_tons, current_railyard_id, shipment_id) VALUES 
(40.00, 103, 3);

UPDATE Containers
SET current_railyard_id = 105
WHERE container_id = 203;

DELETE FROM container_train
WHERE container_id = 202 AND train_id = 301;

