-- Railwork Network PL/SQL (Procedural Language SQL) 
-- By Ian McKee, Amit Guha
-- CS 340 Su25

-- Demo CUD Operation to test RESET functionality
-- This procedure deletes the first shipment and related data to demonstrate that RESET works

DELIMITER //
CREATE OR REPLACE PROCEDURE DeleteFirstShipment()
BEGIN
    -- First, remove container-train assignments for containers linked to shipment 1
    DELETE FROM container_train 
    WHERE container_id IN (SELECT container_id FROM Containers WHERE shipment_id = 1);
    
    -- Then delete containers linked to shipment 1
    DELETE FROM Containers WHERE shipment_id = 1;
    
    -- Finally, delete the shipment itself
    DELETE FROM Shipments WHERE shipment_id = 1;
END //
DELIMITER ;

-- Additional utility procedures (for future use)

-- Procedure to get shipment count (useful for testing)
DELIMITER //
CREATE OR REPLACE PROCEDURE GetShipmentCount()
BEGIN
    SELECT COUNT(*) as shipment_count FROM Shipments;
END //
DELIMITER ;

-- Procedure to get all table counts (useful for verifying RESET worked)
DELIMITER //
CREATE OR REPLACE PROCEDURE GetAllTableCounts()
BEGIN
    SELECT 
        (SELECT COUNT(*) FROM RailYards) as railyard_count,
        (SELECT COUNT(*) FROM Trains) as train_count,
        (SELECT COUNT(*) FROM Shipments) as shipment_count,
        (SELECT COUNT(*) FROM Containers) as container_count,
        (SELECT COUNT(*) FROM container_train) as container_train_count;
END //
DELIMITER ;
