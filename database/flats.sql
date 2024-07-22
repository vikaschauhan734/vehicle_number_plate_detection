CREATE TEMPORARY TABLE NameList (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

INSERT INTO NameList (name) VALUES 
('Ravi Kumar'), ('Neha Sharma'), ('Suresh Patel'), ('Anita Singh'), ('Vikram Gupta'),
('Amitabh Bachchan'), ('Shahrukh Khan'), ('Aishwarya Rai'), ('Sachin Tendulkar'), 
('Priyanka Chopra'), ('Virat Kohli'), ('Deepika Padukone'), ('Ranbir Kapoor'), 
('Alia Bhatt'), ('MS Dhoni'), ('Anushka Sharma'), ('Salman Khan'), ('Kareena Kapoor'),
('Hrithik Roshan'), ('Kangana Ranaut'), ('Rajinikanth'), ('Nayanthara'), ('Pawan Kalyan'),
('Mahesh Babu'), ('Kajal Aggarwal'), ('Vijay'), ('Samantha Akkineni'), ('Dulquer Salmaan'),
('Mammootty'), ('Mohanlal'), ('Parvathy Thiruvothu'), ('Nivin Pauly'), ('Fahadh Faasil'),
('Prithviraj Sukumaran'), ('Manju Warrier'), ('Vikram'), ('Suriya'), ('Jyothika'), 
('Ajith Kumar'), ('Pooja Hegde'), ('Rashmika Mandanna'), ('Yash'), ('Ram Charan'), 
('Allu Arjun'), ('Rana Daggubati'), ('Nani'), ('Rakul Preet Singh');

DELIMITER $$

CREATE PROCEDURE InsertFlats()
BEGIN
    DECLARE flat_id INT DEFAULT 1;
    DECLARE floor_id INT DEFAULT 1;
    DECLARE flat_counter INT DEFAULT 1;
    DECLARE tower_prefix CHAR(1);
    DECLARE floor_number INT;
    DECLARE owner_name VARCHAR(100);
    DECLARE name_count INT;
    DECLARE random_index INT;

    -- Get the count of names
    SELECT COUNT(*) INTO name_count FROM NameList;

    WHILE floor_id <= 50 DO  -- Limit to 50 floors for 300 entries
        SET tower_prefix = CASE 
            WHEN floor_id <= 16 THEN 'A'
            WHEN floor_id <= 32 THEN 'B'
            ELSE 'C'
        END;
        
        SET floor_number = FLOOR((floor_id - 1) / 6) + 1;
        
        WHILE flat_counter <= 6 DO
            -- Randomly select an owner name from the table
            SET random_index = FLOOR(1 + (RAND() * name_count));
            SELECT name INTO owner_name FROM NameList WHERE id = random_index;
            
            INSERT INTO Flats (flat_number, floor_id, flat_name, owner_name)
            VALUES (flat_id, floor_id, 
                    CONCAT(tower_prefix, '-', LPAD(floor_number, 2, '0'), LPAD(flat_counter, 2, '0')), 
                    owner_name);
                    
            SET flat_id = flat_id + 1;
            SET flat_counter = flat_counter + 1;
        END WHILE;
        
        SET flat_counter = 1;
        SET floor_id = floor_id + 1;
    END WHILE;
END$$

DELIMITER ;

CALL InsertFlats();
