import RPi.GPIO as GPIO
import time

# Configurar el modo de los pines
GPIO.setmode(GPIO.BOARD)

# Configurar el pin GPIO 18 como salida
servo_pin = 11
GPIO.setup(servo_pin, GPIO.OUT)

# Configurar la frecuencia del PWM
pwm = GPIO.PWM(servo_pin, 50)  # 50 Hz para el servomotor

# Iniciar el PWM con un duty cycle de 0 (motor detenido)
pwm.start(0)

try:
    while True:
        # Gira el servomotor a 0 grados
        pwm.ChangeDutyCycle(2.5)
        time.sleep(1)

        # Gira el servomotor a 90 grados
        pwm.ChangeDutyCycle(7.5)
        time.sleep(1)

        # Gira el servomotor a 180 grados
        pwm.ChangeDutyCycle(12.5)
        time.sleep(1)

except KeyboardInterrupt:
    pass

# Detener el PWM y limpiar los pines GPIO
pwm.stop()
GPIO.cleanup()
