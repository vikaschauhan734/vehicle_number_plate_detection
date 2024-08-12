## Vehicle Number Plate Recognition System

This project implements a vehicle number plate recognition system using deep learning, optical character recognition (OCR), and database management. The system identifies vehicles by their number plates and logs their entry into a residential complex.

## Project Overview

The project was completed in several key steps:

1. **Database Setup:**
   - Created a MySQL database and a BigQuery database with the following schema:
     - **Towers:** `tower_id` (Primary Key), `tower_name`
     - **Floors:** `floor_id` (Primary Key), `tower_id` (Foreign Key referencing Towers), `floor_number`
     - **Flats:** `flat_number` (Primary Key), `floor_id` (Foreign Key referencing Floors), `flat_name`, `owner_name`
     - **Vehicles:** `vehicle_id` (Primary Key), `vehicle_number`, `flat_number` (Foreign Key referencing Flats), `vehicle_type`
     - **Residents:** `resident_id` (Primary Key), `flat_number` (Foreign Key referencing Flats), `name`, `phone_number`, `email`, `resident_type`
     - **Vehicle_Entry:** `entry_id` (Primary Key), `vehicle_number` (Foreign Key referencing Vehicles), `entry_time`
     - **Vehicle_Exit:** `exit_id` (Primary Key), `vehicle_number` (Foreign Key referencing Vehicles), `exit_time`

2. **Data Fetching:**
   - Developed Python scripts to fetch vehicle data from either MySQL or BigQuery databases.

3. **Model Training:**
   - Trained a YOLOv10 model using a custom dataset containing images of vehicles with annotated number plates.
   - The model was fine-tuned to accurately detect number plates in various conditions.

4. **OCR Implementation:**
   - Integrated EasyOCR to extract text from the number plates detected by the YOLOv10 model.
   - Preprocessed the extracted text to improve accuracy in comparison with the database entries.

5. **Number Plate Matching:**
   - Compared the OCR output with the number plates stored in the database.
   - If a match was found, the system logged the vehicle’s entry time in the `Vehicle_Entry` table.
   - If no match was found, the system still logged the entry but marked the vehicle as unrecognized.

6. **Flask Web Application:**
   - Created a Flask web app that allows users to upload vehicle images.
   - The app predicts the vehicle number using YOLOv10 and EasyOCR, then determines if the vehicle is recognized or not.
   - The results are displayed on the same page along with an animation of an opening fence when the prediction is completed.

## Usage
   - Upload a vehicle image through the web app.
   - The system will predict the number plate, match it with the database, and log the entry.

## Future Enhancements
   - Implement real-time vehicle detection using live video feed.
   - Expand the database schema to include more detailed vehicle and resident information.

## Contributor
   - [Vikas Chauhan](https://github.com/vikaschauhan734)