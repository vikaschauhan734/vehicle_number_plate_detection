from flask import Flask, render_template, request, redirect, send_file, url_for, Response
import pandas as pd
from datetime import datetime
from ultralytics import YOLOv10
import easyocr
import cv2
from google.cloud import bigquery
import os


app = Flask(__name__)


@app.route("/")
def home():
    return render_template('index.html')


