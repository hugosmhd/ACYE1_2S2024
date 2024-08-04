import RPi.GPIO as GPIO
import time

# Configuración de los pines GPIO
GPIO.setmode(GPIO.BCM)

# Pines de los LEDs
led_pins = [17, 27, 22]
# Pines de los botones
button_pins = [5, 6, 13]
button_5_pressed = False

# Configurar los pines de los LEDs como salida
for pin in led_pins:
    GPIO.setup(pin, GPIO.OUT)

# Configurar los pines de los botones como entrada con pull-up interno
for pin in button_pins:
    GPIO.setup(pin, GPIO.IN, pull_up_down=GPIO.PUD_UP)

# Función para parpadear un LED
def blink_led(pin):
    GPIO.output(pin, GPIO.HIGH)
    time.sleep(0.5)
    GPIO.output(pin, GPIO.LOW)
    time.sleep(0.5)

try:
    while True:
        # Leer el estado de los botones y actualizar los LEDs en consecuencia
        for i in range(len(button_pins)):
            pin = button_pins[i]
            led_pin = led_pins[i]

            if pin == 5:
                if GPIO.input(pin) == GPIO.LOW:  # Botón presionado
                    button_5_pressed = True
                    GPIO.output(led_pin, GPIO.HIGH)
                else:
                    button_5_pressed = False
            else:
                if GPIO.input(pin) == GPIO.LOW:  # Botón presionado
                    GPIO.output(led_pin, GPIO.HIGH)
                    time.sleep(5)
                elif led_pin != 17:
                    GPIO.output(led_pin, GPIO.LOW)

        # Parpadear el LED si button_5_pressed es False
        if not button_5_pressed:
            blink_led(led_pins[0])

        time.sleep(0.1)  # Pequeño retardo para evitar uso intensivo de CPU

except KeyboardInterrupt:
    GPIO.cleanup()