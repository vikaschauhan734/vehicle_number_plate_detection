# Vehicle Number Plate Detection

Database Schema:
1. **Towers**:
* `tower_id` (Primary Key)
* `tower_name`

2. **Floors**:
* `floor_id` (Primary Key)
* `tower_id` (Foreign Key referencing Towers)
* `floor_number`

3. **Flats**:
* `flat_number` (Primary Key)
* `floor_id` (Foreign Key referencing Floors)
* `flat_name` 
* `owner_name`

4. **Vehicles**:
* `vehicle_id` (Primary Key)
* `vehicle_number` 
* `flat_number` (Foreign Key referencing Flats)
* `vehicle_type` (owner, tenant, guest)

5. **Residents**:
* `resident_id` (Primary Key)
* `flat_number` (Foreign Key referencing Flats)
* `name`
* `phone_number`
* `email`
* `resident_type` (owner, tenant)

6. **Vehicle_Entry**:
* `entry_id` (Primary Key)
* `vehicle_number` (Foreign Key referencing Vehicles)
* `entry_time`

7. **Vehicle_Exit**:
* `exit_id` (Primary Key)
* `vehicle_number` (Foreign Key referencing Vehicles)
* `exit_time`