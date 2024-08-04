# CON HILOS
import RPi.GPIO as GPIO
import time
import threading

# Configuración de los pines GPIO
GPIO.setmode(GPIO.BCM)

# Pines de los LEDs
led_pins = [17, 27, 22]
# Pines de los botones
button_pins = [5, 6, 13]
button_5_pressed = True

# Configurar los pines de los LEDs como salida
for pin in led_pins:
    GPIO.setup(pin, GPIO.OUT)

# Configurar los pines de los botones como entrada con pull-up interno
for pin in button_pins:
    GPIO.setup(pin, GPIO.IN, pull_up_down=GPIO.PUD_UP)

# Función para parpadear un LED
def blink_led(pin):
    global button_5_pressed
    while True:
        if button_5_pressed == False:
            GPIO.output(pin, GPIO.HIGH)
            time.sleep(0.5)
            GPIO.output(pin, GPIO.LOW)
            time.sleep(0.5)

# Función para manejar los botones
def handle_button(pin, led_pin):
    global button_5_pressed
    while True:
        if pin == 5:
            if GPIO.input(pin) == GPIO.LOW:  # Botón presionado
                button_5_pressed = True
                GPIO.output(led_pin, GPIO.HIGH)
            else:
                button_5_pressed = False
        else:
            if GPIO.input(pin) == GPIO.LOW:  # Botón presionado
                GPIO.output(led_pin, GPIO.HIGH)
                time.sleep(0.2)
            elif led_pin != 17:
                GPIO.output(led_pin, GPIO.LOW)

# Crear un hilo para el LED parpadeante
blinking_led_thread = threading.Thread(target=blink_led, args=(led_pins[0],))
blinking_led_thread.start()

# Crear hilos para manejar los botones
button_threads = []
for i in range(len(button_pins)):
    thread = threading.Thread(target=handle_button, args=(button_pins[i], led_pins[i]))
    thread.start()
    button_threads.append(thread)
    
try:
    while True:
        time.sleep(1)
except KeyboardInterrupt:
    GPIO.cleanup()