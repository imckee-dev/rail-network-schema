
-- our main four

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