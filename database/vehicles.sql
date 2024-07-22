DELIMITER $$

CREATE PROCEDURE InsertVehicles()
BEGIN
    DECLARE vehicle_id INT DEFAULT 1;
    DECLARE flat_count INT;
    DECLARE flat_number INT;
    DECLARE vehicle_number VARCHAR(20);
    DECLARE vehicle_type ENUM('Owner', 'Tenant', 'Guest');
    DECLARE random_index INT;
    DECLARE types ENUM('Owner', 'Tenant', 'Guest') DEFAULT 'Owner';

    -- Get the total number of flats
    SELECT COUNT(*) INTO flat_count FROM Flats;

    WHILE vehicle_id <= 400 DO
        -- Randomly select a flat number
        SET random_index = FLOOR(1 + (RAND() * flat_count));
        SELECT flat_number INTO flat_number FROM Flats WHERE flat_number = random_index;

        -- Generate a random vehicle number (e.g., "MH12AB1234")
        SET vehicle_number = CONCAT('MH', LPAD(FLOOR(1 + (RAND() * 99)), 2, '0'), 
                                    CHAR(FLOOR(65 + (RAND() * 26))), 
                                    CHAR(FLOOR(65 + (RAND() * 26))), 
                                    LPAD(FLOOR(1 + (RAND() * 9999)), 4, '0'));

        -- Randomly select a vehicle type
        SET types = CASE 
            WHEN vehicle_id % 3 = 0 THEN 'Owner'
            WHEN vehicle_id % 3 = 1 THEN 'Tenant'
            ELSE 'Guest'
        END;

        INSERT INTO Vehicles (vehicle_id, flat_number, vehicle_number, vehicle_type)
        VALUES (vehicle_id, flat_number, vehicle_number, types);

        SET vehicle_id = vehicle_id + 1;
    END WHILE;
END$$

DELIMITER ;

CALL InsertVehicles();
