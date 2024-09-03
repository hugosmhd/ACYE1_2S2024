import Adafruit_DHT
import time

from send_to_mongo import connect_to_mongo, send_data_to_mongo
# Tipo de sensor: DHT11
sensor = Adafruit_DHT.DHT11

# Pin GPIO al que está conectado el sensor
gpio = 17

def main():
    collection = connect_to_mongo()
    # Bucle infinito para leer los datos del sensor constantemente
    while True:
        # Intentar leer los datos del sensor (retry hasta 15 veces con 2 segundos de espera entre intentos)
        humidity, temperature = Adafruit_DHT.read_retry(sensor, gpio)
        
        # Verificar si las lecturas son válidas
        if humidity is not None and temperature is not None:
            print(f'Temp={temperature:0.1f}*C  Humidity={humidity:0.1f}%')
            send_data_to_mongo(temperature, humidity, collection)
        else:
            print('Failed to get reading. Try again!')
        
        # Esperar 3 segundos antes de la siguiente lectura
        time.sleep(3)

if __name__ == "__main__":
    main()
