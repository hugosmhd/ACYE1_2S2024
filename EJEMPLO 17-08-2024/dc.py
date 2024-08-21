import RPi.GPIO as GPIO
import time

GPIO.setwarnings(False)

# Right Motor
en_a = 17
en_b = 17
in1 = 27
in2 = 22
in3 = 20
in4 = 21


GPIO.setmode(GPIO.BCM)
# Configuración de pines
GPIO.setup(in1, GPIO.OUT)
GPIO.setup(in2, GPIO.OUT)
GPIO.setup(en_a, GPIO.OUT)
GPIO.setup(in3, GPIO.OUT)
GPIO.setup(in4, GPIO.OUT)
GPIO.setup(en_b, GPIO.OUT)

# Activar motores
GPIO.output(en_a, GPIO.HIGH)
GPIO.output(en_b, GPIO.HIGH)

# Forward
def move_forward():
    GPIO.output(in1, GPIO.HIGH)
    GPIO.output(in2, GPIO.LOW)
    GPIO.output(in3, GPIO.HIGH)
    GPIO.output(in4, GPIO.LOW)
    
# Backward
def move_backward():
    GPIO.output(in1, GPIO.LOW)
    GPIO.output(in2, GPIO.HIGH)
    GPIO.output(in3, GPIO.LOW)
    GPIO.output(in4, GPIO.HIGH)
    
#Turn Right
def turn_right():
    GPIO.output(in1, GPIO.LOW)
    GPIO.output(in2, GPIO.LOW)
    GPIO.output(in3, GPIO.LOW)
    GPIO.output(in4, GPIO.HIGH)
    
#Turn Left
def turn_left():
    GPIO.output(in1, GPIO.LOW)
    GPIO.output(in2, GPIO.HIGH)
    GPIO.output(in3, GPIO.LOW)
    GPIO.output(in4, GPIO.LOW)
   
#Stop
def stop():
    GPIO.output(in1, GPIO.LOW)
    GPIO.output(in2, GPIO.LOW)
    GPIO.output(in3, GPIO.LOW)
    GPIO.output(in4, GPIO.LOW)
    
try:
    while True:
        move_forward()
        print("Forward")
        time.sleep(2)
        stop()
        print("Stop")
        time.sleep(2)
        move_backward()
        print("Backward")
        time.sleep(2)
        stop()
        print("Stop")
        time.sleep(2)
        
except KeyboardInterrupt:
    print("Program interrupted")
    
finally:
    GPIO.cleanup()  # Limpiar la configuración de GPIO al finalizar

