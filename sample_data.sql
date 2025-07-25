-- Citation for use of AI tools
    -- Date accessed: 7/24/25
3   -- Prompt used to generate DB info / (implicitly) SQL
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