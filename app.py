from flask import Flask, render_template, request, jsonify
import pandas as pd
from datetime import datetime
from ultralytics import YOLOv10
import easyocr
import cv2
from google.cloud import bigquery
import os
from werkzeug.utils import secure_filename

service_account_path = '/content/drive/MyDrive/vnp/yolov10/oauth-credentials.json'
os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = service_account_path
client = bigquery.Client()

def vehicle_data():
  query = """SELECT * FROM `deep-ethos-427902-u1.vehicle_number_plate.Vehicles`"""
  query_job = client.query(query)
  vehicle_data_df = query_job.result().to_dataframe()
  return vehicle_data_df

def entry_data():
  query = """SELECT * FROM `deep-ethos-427902-u1.vehicle_number_plate.Vehicle_Entry`"""
  query_job = client.query(query)
  entry_data_df = query_job.result().to_dataframe()
  return entry_data_df

def ocr_on_image(img_path, cord_img):
  xmin = int(cord_img[0][0])
  ymin = int(cord_img[0][1])
  xmax = int(cord_img[0][2])
  ymax = int(cord_img[0][3])
  cropped_img = cv2.imread(img_path,cv2.IMREAD_COLOR)[ymin:ymax,xmin:xmax]
  gray_img = cv2.cvtColor(cropped_img, cv2.COLOR_RGB2GRAY)
  ocr_result = ocr.readtext(gray_img)
  if ocr_result == []:
    return "No Text found"
  else:
    return ocr_result[0][1]

def vehicle_number_predictor(img_path):
  results = model.predict(source=img_path)
  cord_img = results[0].boxes.xyxy
  return ocr_on_image(img_path, cord_img)

def no_space(string):
    return string.replace(" ","")

def insert_into_vehicle_data(number_plate, vehicle_data):
    table = client.dataset('vehicle_number_plate').table('Vehicles')
    if vehicle_data['vehicle_id'].shape[0] == 0:
      vehicle_id = 1
    else:
      vehicle_id = int(max(vehicle_data['vehicle_id'])+1)
    row_to_insert = [{"vehicle_id": vehicle_id, "vehicle_number": number_plate,"vehicle_type":"Guest"}]
    errors = client.insert_rows_json(table, row_to_insert)
    if errors:
      print("Errors occurred while inserting rows:", errors)
    else:
      print("Vehicles Data updated successfully")

def insert_into_vehicle_entry(number_plate, time, vehicle_data):
    vehicle_id = vehicle_data[vehicle_data['vehicle_number'] == number_plate]['vehicle_id']
    vehicle_id = int(vehicle_id.iloc[0])
    entry_data_df = entry_data()
    entry_time_str = time.strftime('%Y-%m-%d %H:%M:%S')
    if entry_data_df['entry_id'].shape[0] == 0:
      entry_id = 1
    else:
      entry_id = int(max(entry_data_df['entry_id'])+1)
    table = client.dataset('vehicle_number_plate').table('Vehicle_Entry')
    row_to_insert = [{"entry_id":entry_id, "vehicle_id": vehicle_id,"entry_time":entry_time_str}]
    errors = client.insert_rows_json(table, row_to_insert)
    if errors:
      print("Errors occurred while inserting rows:", errors)
    else:
      print("Vehicles Data updated successfully")

def vehicle_add(vehicle_data, predict, time):
    number_plate = no_space(predict)
    vehicle_data['vehicle_number'] = vehicle_data['vehicle_number'].apply(no_space)
    if vehicle_data[vehicle_data['vehicle_number'] == number_plate].shape[0] == 0:
        insert_into_vehicle_data(number_plate, vehicle_data)
        vehicle_data_df = vehicle_data()
        vehicle_data['vehicle_number'] = vehicle_data['vehicle_number'].apply(no_space)
        insert_into_vehicle_entry(number_plate,time,vehicle_data)
    else:
        insert_into_vehicle_entry(number_plate,time,vehicle_data)
    return number_plate, time
vehicle_data_df = vehicle_data()

model = YOLOv10("/content/drive/MyDrive/vnp/yolov10/best.pt")
ocr = easyocr.Reader(['en'], gpu=True)

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = 'uploads/'
app.config['ALLOWED_EXTENSIONS'] = {'png', 'jpg', 'jpeg', 'gif'}

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in app.config['ALLOWED_EXTENSIONS']

@app.route("/")
def index():
    return render_template('index.html')

@app.route('/predict', methods=['POST'])
def predict():
    if 'file' not in request.files:
        return "No file part", 400
    file = request.files['file']
    if file.filename == '':
        return "No selected file", 400
    if file and allowed_file(file.filename):
        filename = secure_filename(file.filename)
        file_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        file.save(file_path)
        predict = vehicle_number_predictor(file_path)
        time = datetime.now()
        prediction = vehicle_add(vehicle_data_df, predict, time)
        return prediction
    return "File not allowed", 400

if __name__ == '__main__':
    if not os.path.exists(app.config['UPLOAD_FOLDER']):
        os.makedirs(app.config['UPLOAD_FOLDER'])
    app.run(debug=True)

