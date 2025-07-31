
-- Railwork Network SQL define 
-- By Ian McKee, Amit Guha
-- CS 340 Su25

-- Part 1 - create table section

-- our main four

-- Order must be: (Shipments must be after RailYards; Containers must be after RailYards/Shipments)

CREATE TABLE RailYards (
    railyard_id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    train_capacity int
);

CREATE TABLE Trains (
    train_id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    train_name varchar(255),
    engine_type ENUM('diesel','electric','hybrid')
);

CREATE TABLE Shipments (
    shipment_id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    description varchar(255),
    weight_tons decimal(6,2),
    origin_railyard_id int,
    destination_railyard_id int,

    FOREIGN KEY (origin_railyard_id) REFERENCES RailYards(railyard_id),
    FOREIGN KEY (destination_railyard_id) REFERENCES RailYards(railyard_id)
);

CREATE TABLE Containers (
    container_id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    capacity_tons decimal(6,2),
    current_rail_id int,
    shipment_id int,

    FOREIGN KEY (current_rail_id) REFERENCES RailYards(railyard_id),
    FOREIGN KEY (shipment_id) REFERENCES Shipments(shipment_id)

    -- Add constraint such that shipment_id it references weight < its capacity_tons


);


-- intersection table
CREATE TABLE container_train ( -- one train to many containers, and/or many trains to one container
    container_id int,
    train_id int,

    FOREIGN KEY (train_id) REFERENCES Trains(train_id),
    FOREIGN KEY (container_id) REFERENCES Containers(container_id),
    PRIMARY KEY (container_id, train_id)
);


-- End Part 1

-- Part 2 - Insert data section

-- Citation for use of AI tools
    -- Date accessed: 7/24/25
3   -- Prompt used to generate DB info / (implicitly) write the SQL syntax
        -- "Now make 5 pieces of data for each of the four main entities. Please. and use the intersection table when necessary"
    -- AI Source URL: chatgpt.com

-- Note: ChatGPT manually added IDs, when ours is AUTO INC. It does, however, add clarity.

INSERT INTO RailYards (railyard_id, train_capacity) VALUES
(101, 5),
(102, 4),
(103, 3),
(104, 6),
(105, 2);

INSERT INTO Trains (train_id, train_name, engine_type) VALUES
(301, 'Iron Express', 'diesel'),
(302, 'Coastal Runner', 'electric'),
(303, 'Midwest Hauler', 'hybrid'),
(304, 'Mountain Climber', 'diesel'),
(305, 'Sunset Liner', 'electric');


INSERT INTO Shipments (shipment_id, description, weight_tons, origin_railyard_id, destination_railyard_id) VALUES
(1, 'Furniture Delivery', 45.50, 101, 104),
(2, 'Electronics from SF to LA', 12.75, 102, 103),
(3, 'Steel Beams', 65.00, 101, 105),
(4, 'Books Shipment', 8.20, 103, 102),
(5, 'Automobile Parts', 33.00, 104, 105);

INSERT INTO Containers (container_id, capacity_tons, current_rail_id, shipment_id) VALUES
(201, 50.00, 101, 1),
(202, 15.00, 101, 2),
(203, 70.00, 101, 3),
(204, 10.00, 103, 4),
(205, 35.00, 105, 5);


INSERT INTO container_train (container_id, train_id) VALUES
(202, 301),
(203, 302),
(205, 303);