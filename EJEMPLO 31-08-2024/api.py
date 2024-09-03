from flask import Flask, jsonify
from flask_cors import CORS
from pymongo import MongoClient
from datetime import datetime
import RPi.GPIO as GPIO

app = Flask(__name__)
CORS(app)  # Habilitar CORS para todas las rutas

# Conexión a la base de datos MongoDB
# Colocar su linea de conexion
client = MongoClient("")
db = client['sensor_data']
collection = db['temperature_humidity']

GPIO.setmode(GPIO.BOARD)
LED_PIN = 3
GPIO.setup(LED_PIN, GPIO.OUT)
GPIO.output(LED_PIN, GPIO.LOW)

@app.route('/data', methods=['GET'])
def get_data():
    # Obtener todos los registros y ordenar por timestamp en orden descendente
    data = collection.find().sort("timestamp", -1)
    
    # Encontrar el día más reciente
    latest_date = None
    for record in data:
        datetime_obj = record['timestamp']
        day_str = datetime_obj.strftime('%d/%m/%Y')
        if latest_date is None or datetime_obj > latest_date:
            latest_date = datetime_obj
            latest_day_str = day_str

    if not latest_date:
        return jsonify({'dia': None, 'temperaturas': [], 'hora': []})
    
    # Filtrar los datos para el día más reciente
    data = collection.find({
        "timestamp": {
            "$gte": datetime.combine(latest_date.date(), datetime.min.time()),
            "$lt": datetime.combine(latest_date.date(), datetime.max.time())
        }
    }).sort("timestamp", 1)

    grouped_data = {
        'temperaturas': [],
        'hora': []
    }
    
    last_minute = None
    
    for record in data:
        datetime_obj = record['timestamp']
        minute_str = datetime_obj.strftime('%H:%M')
        
        # Añadir la temperatura
        grouped_data['temperaturas'].append(float(record['temperature']))
        
        # Verificar si es un nuevo minuto
        if last_minute == minute_str:
            grouped_data['hora'].append(minute_str)  # Si es el mismo minuto, añadir string vacío
        else:
            grouped_data['hora'].append(minute_str)  # Si es un nuevo minuto, añadir la hora
            last_minute = minute_str

    result = {
        'dia': latest_day_str,
        'temperaturas': grouped_data['temperaturas'],
        'hora': grouped_data['hora']
    }

    return jsonify(result)


@app.route('/led/<state>', methods=['GET'])
def control_led(state):
    if state == 'on':
        GPIO.output(LED_PIN, GPIO.HIGH)
        return jsonify({'status': 'LED encendido'})
    elif state == 'off':
        GPIO.output(LED_PIN, GPIO.LOW)
        return jsonify({'status': 'LED apagado'})
    else:
        return jsonify({'error': 'Estado no válido'}), 400

@app.route('/')
def index():
    return "Server is running"

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000)
