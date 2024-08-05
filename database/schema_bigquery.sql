CREATE SCHEMA `vehicle_number_plate` ;

CREATE TABLE vehicle_number_plate.Towers (
tower_id INT64 NOT NULL,
tower_name STRING NOT NULL
);

CREATE TABLE vehicle_number_plate.Floors (
floor_id INT64 NOT NULL,
tower_id INT64,
floor_number INT64
);

CREATE TABLE vehicle_number_plate.Flats (
flat_number INT64 NOT NULL,
floor_id INT64,
flat_name STRING NOT NULL,
owner_name STRING NOT NULL
);

CREATE TABLE vehicle_number_plate.Residents (
resident_id INT64 NOT NULL,
flat_number INT64,
name STRING NOT NULL,
phone_number INT64,
email STRING,
resident_type STRING NOT NULL
);

CREATE TABLE vehicle_number_plate.Vehicles (
vehicle_id INT64 NOT NULL,
flat_number INT64 ,
vehicle_number STRING NOT NULL,
vehicle_type STRING NOT NULL
);

CREATE TABLE vehicle_number_plate.Vehicle_Entry (
entry_id INT64 NOT NULL,
vehicle_id INT64,
entry_time DATETIME NOT NULL
);

CREATE TABLE vehicle_number_plate.Vehicle_Exit (
exit_id INT64 NOT NULL,
vehicle_id INT64,
exit_time DATETIME NOT NULL
);


-- For data insertion
-- INSERT INTO dataset.table (col1, col2) VALUES
-- (1, 11),
-- (2, 22)