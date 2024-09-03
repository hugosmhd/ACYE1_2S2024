from datetime import datetime
import pymongo

# Configura la conexión a MongoDB
def connect_to_mongo():
    # Colocar su linea de conexion
    uri = ""
    client = pymongo.MongoClient(uri)
    db = client['sensor_data']
    collection = db['temperature_humidity']
    return collection

def send_data_to_mongo(temperature, humidity, collection):
    data = {
        'temperature': temperature,
        'humidity': humidity,
        'timestamp': datetime.now()
    }
    collection.insert_one(data)
    print(f"Data sent to MongoDB: {data}")
