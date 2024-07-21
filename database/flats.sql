DELIMITER $$

CREATE PROCEDURE InsertFlats()
BEGIN
    DECLARE flat_id INT DEFAULT 1;
    DECLARE floor_id INT DEFAULT 1;
    DECLARE flat_counter INT DEFAULT 1;
    DECLARE tower_prefix CHAR(1);
    DECLARE floor_number INT;
    DECLARE owner_name VARCHAR(100);
    
    -- Array of Indian names
    DECLARE name_list TEXT[] DEFAULT ARRAY['Ravi Kumar', 'Neha Sharma', 'Suresh Patel', 'Anita Singh', 'Vikram Gupta',
                                           'Amitabh Bachchan', 'Shahrukh Khan', 'Aishwarya Rai', 'Sachin Tendulkar', 
                                           'Priyanka Chopra', 'Virat Kohli', 'Deepika Padukone', 'Ranbir Kapoor', 
                                           'Alia Bhatt', 'MS Dhoni', 'Anushka Sharma', 'Salman Khan', 'Kareena Kapoor',
                                           'Hrithik Roshan', 'Kangana Ranaut', 'Rajinikanth', 'Nayanthara', 'Pawan Kalyan',
                                           'Mahesh Babu', 'Kajal Aggarwal', 'Vijay', 'Samantha Akkineni', 'Dulquer Salmaan',
                                           'Mammootty', 'Mohanlal', 'Parvathy Thiruvothu', 'Nivin Pauly', 'Fahadh Faasil',
                                           'Prithviraj Sukumaran', 'Manju Warrier', 'Vikram', 'Suriya', 'Jyothika', 'Ajith Kumar',
                                           'Nayanthara', 'Samantha Akkineni', 'Pooja Hegde', 'Rashmika Mandanna', 'Yash', 
                                           'Ram Charan', 'Allu Arjun', 'Rana Daggubati', 'Nani', 'Rakul Preet Singh'];
                                           
    -- Total number of names in the list
    DECLARE name_count INT DEFAULT ARRAY_LENGTH(name_list, 1);
    
    WHILE floor_id <= 300 DO
        SET tower_prefix = CASE 
            WHEN floor_id <= 100 THEN 'A'
            WHEN floor_id <= 200 THEN 'B'
            ELSE 'C'
        END;
        
        SET floor_number = CEIL(floor_id / 12);
        
        WHILE flat_counter <= 6 DO
            -- Randomly select an owner name from the list
            SET owner_name = name_list[FLOOR(1 + (RAND() * name_count))];
            
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
