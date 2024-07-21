DELIMITER $$

CREATE PROCEDURE InsertFloors()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE t INT DEFAULT 1;
    DECLARE f INT DEFAULT 1;

    WHILE i <= 300 DO
        IF f > 25 THEN
            SET f = 1;
            SET t = t + 1;
        END IF;
        
        INSERT INTO Floors (floor_id, tower_id, floor_number) VALUES (i, t, f);
        
        SET i = i + 1;
        SET f = f + 1;
    END WHILE;
END$$

DELIMITER ;

CALL InsertFloors();