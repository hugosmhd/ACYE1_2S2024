# Include the library files
import RPi.GPIO as GPIO
from time import sleep

# Include the motor control pins
en_a = 17
in1 = 27
in2 = 22
in3 = 20
in4 = 21

ControlPin = [in1,in2,in3,in4]

GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)
GPIO.setup(en_a,GPIO.OUT)
GPIO.setup(in1,GPIO.OUT)
GPIO.setup(in2,GPIO.OUT)
GPIO.setup(in3,GPIO.OUT)
GPIO.setup(in4,GPIO.OUT)


StepCount = 8
#Seq = range(0, StepCount)

seq = [[1,1,0,0],
       [0,1,1,0],
       [0,0,1,1],
       [1,0,0,1],
]

GPIO.output(en_a, 1)
rotetionNeeded = 0
rotetionCount = 200
    

def forward():
        for i in range (rotetionCount):
            for fullStep in range(4):
                for pin in range (4):
                    GPIO.output(ControlPin[pin],seq[fullStep][pin])
                    sleep(0.001)
    

def backward():
        for i in range (rotetionCount):
            for fullStep in range(4):
                for pin in reversed(range (4)):
                    GPIO.output(ControlPin[pin],seq[fullStep][pin])
                    sleep(0.001)
try:
    while True:
        forward()
        sleep(2)
        backward()
        sleep(2)
except KeyboardInterrupt:
    print("Program interrupted")
    
finally:
    GPIO.cleanup()  # Limpiar la configuración de GPIO al finalizar