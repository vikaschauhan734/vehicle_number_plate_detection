CREATE SCHEMA `vehicle_number_plate` ;

USE `vehicle_number_plate`;

CREATE TABLE Towers (
tower_id INT PRIMARY KEY,
tower_name VARCHAR(10) NOT NULL
);

CREATE TABLE Floors (
floor_id INT PRIMARY KEY,
tower_id INT,
floor_number INT,
FOREIGN KEY (tower_id) REFERENCES Towers(tower_id)
);

CREATE TABLE Flats (
flat_number INT PRIMARY KEY,
floor_id INT,
flat_name VARCHAR(10) NOT NULL,
owner_name VARCHAR(100) NOT NULL,
FOREIGN KEY (floor_id) REFERENCES Floors(floor_id)
);

CREATE TABLE Residents (
resident_id INT PRIMARY KEY,
flat_number INT,
name VARCHAR(100) NOT NULL,
phone_number VARCHAR(15),
email VARCHAR(50),
resident_type VARCHAR(20) NOT NULL,
FOREIGN KEY (flat_number) REFERENCES Flats(flat_number)
);

CREATE TABLE Vehicles (
vehicle_id INT PRIMARY KEY,
flat_number INT,
vehicle_number VARCHAR(20) NOT NULL,
vehicle_type VARCHAR(20) NOT NULL,
FOREIGN KEY (flat_number) REFERENCES Flats(flat_number)
);

CREATE TABLE Vehicle_Entry (
entry_id INT PRIMARY KEY,
vehicle_id INT,
entry_time DATETIME NOT NULL,
FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id)
);

CREATE TABLE Vehicle_Exit (
exit_id INT PRIMARY KEY,
vehicle_id INT,
exit_time DATETIME NOT NULL,
FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id)
);