.global itoa
.global atoi
.global _start
.data

clear_screen:
    .asciz "\x1B[2J\x1B[H"
    lenClear = .- clear_screen

msg: 
    .asciz "Hola Mundo!!\n"

encabezado_columnas:
    .asciz "          A              B              C              D              E              F              G              H              I              J              K   \n"
    lenEncabezadoColumnas = .- encabezado_columnas


    
value:  .asciz "0000000000000"
    lenValue = .- value // SE ENCARGARA DE GUARDAR EL VALOR DE CADA CELDA (UNICAMENTE 13 espacios)

espacio:  .asciz "  "
    lenEspacio = .- espacio

salto:  .asciz "\n"
    lenSalto = .- salto

ingresoComando:
    .asciz ":"
    lenIngresoComando = .- ingresoComando   // Unicamente se colocan 2 pts para pedir el ingreso del comando

fila:  .asciz "00"
letra:  .asciz "A"
buffer:  .asciz "0\n"
prueba:  .asciz "9223372036854775807\0"
.bss
tablero:
    .skip 253 * 8   // Esta variable es nuestra matriz de 23 * 11 que tiene 64 bits cada numero

num:
    .space 19   // Variable encargada de guardar los parametros que ingrese el usuario (Numero, Celda o Retorno)

comando:
    .zero 50    // Encargado de guardar el comando que ingresa el usuario

num64:
    .skip 8         // Reservar 8 bytes (64 bits) sin inicializar, variable que guarda un numero de 64 bits, uso general

param1:
    .skip 8         // Reservar 8 bytes (64 bits) sin inicializar, variable que guarda un numero de 64 bits, uso general

param2:
    .skip 8         // Reservar 8 bytes (64 bits) sin inicializar, variable que guarda un numero de 64 bits, uso general

fila64:
    .skip 8         // Reservar 8 bytes (64 bits) sin inicializar, guarda fila que se este trabajando (puede ser de uso general)
.text

// Macro para imprimir strings
.macro mPrint reg, len
    MOV x0, 1
    LDR x1, =\reg
    MOV x2, \len
    MOV x8, 64
    SVC 0
.endm

.macro mImprimirValores
    MOV x9, 0                    // Índice inicial (contador)

    imprimir_valores:
        // Verificar si hemos almacenado 253 números
        // CMP  x9, 253                  // Comparar el índice con 253
        // BEQ  end_mImprimirValores     // Si hemos alcanzado 253 números, salir del bucle

        // Limpiamos el valor
        LDR x1, =value
        MOV w7, 13 // Largo del Buffer a limpiar
        mLimpiarValue
        // Cargar el número actual de 64 bits desde memoria
        MOV x0, #-1
        LDR x1, =value
        MOV X2, 13
        // Llamar a la macro que imprimirá el valor
        BL itoa                     // Llamada a una macro que imprime el valor en x0
        mPrint value, 13

        // Incrementar el índice
        ADD x9, x9, 1                 // Incrementar el índice

        // Volver al inicio del bucle
        // B imprimir_valores

    end_mImprimirValores:
.endm

// Macro para limpiar la variable value y regresarla a 13 ceros
.macro mLimpiarValue
    MOV w6, 48

    // Se define una etiqueta local
    1:
        STRB w6, [x1], 1
        SUB w7, w7, 1
        CBNZ w7, 1b
.endm

// Macro para pedirle una entrada al usuario
.macro mRead stdin, buffer, len
    MOV x0, \stdin
    LDR x1, =\buffer
    MOV x2, \len
    MOV x8, 63
    SVC 0
.endm

imprimirCeldas:
    mPrint encabezado_columnas, lenEncabezadoColumnas



    // Esta etiqueta unicamente llena valores en la matriz
    // En su momento fue util para verificar que los metodos iota y atoi funcionaran correctamente
    // Queda aqui por si les sirve!
    /*MOV x0, 0
    MOV x1, #-100
    ADRP x25, tablero
    ADD  x25, x25, :lo12:tablero       // Sumar el offset para la dirección completa
    store_loop:
       // Verificar si hemos almacenado 253 números
       CMP  x0, 253                   // Comparar el índice con 253
       BEQ  end_mImprimirCeldas                      // Si ya hemos almacenado 253 números, salir del bucle
       // Almacenar el valor de 64 bits en la dirección actual
       STR  x1, [x25, x0, lsl 3]      // Guardar x1 en [x25 + x0 * 8] (multiplicar el índice por 8)
       // Incrementar el índice y el valor
       ADD  x0, x0, 1                 // Incrementar el índice
       ADD  x1, x1, 1                 // Incrementar el valor (puedes cambiar la lógica de incremento)
       // Volver al inicio del bucle
       B store_loop*/
    end_mImprimirCeldas:
        MOV x9, 23 // x23 Sera nuestro contador de las filas
        ADRP x25, tablero
        ADD  x25, x25, :lo12:tablero       // Sumar el offset para la dirección completa
        MOV x26, 0 // x26 sera nuestro contador de celdas
    impresion_fila:
        // Guardar el número de fila en la pila
        // En esta parte, unicamente se ubica la fila en la que va el bucle para imprimir la fila en consola
        MOV x0, 24  // x0=24
        LDR x1, =fila // Buffer donde se alamcenara el numero convertido
        MOV w7, 2 // Largo del Buffer a limpiar
        mLimpiarValue
        LDR x1, =fila
        MOV x2, 2       // Tamaño del buffer, sirve para que imprima un cero antes si el numero es de un solo digito
        SUB x0, x0, x9

        SUB sp, sp, #16           // Reservar espacio en la pila (16 bytes)
        STR x9, [sp]             // Almacenar el valor de x11 (número de columnas) en la pila

        STP x29, x30, [SP, -16]!     // Guardar x29 y x30 antes de la llamada
        BL itoa                      // Convierte el número a ASCII
        LDP x29, x30, [SP], 16       // Restaurar x29 y x30 después de la llamada
        
        mPrint fila, 2  // Se imprime la fila en consola
        mPrint espacio, lenEspacio // Se imprime un espacio en consola

        // Recuperar el número de columnas
        LDR x9, [sp]             // Cargar el valor de la columna en x12
        ADD sp, sp, #16           // Liberar el espacio de la pila para la columna

        SUB sp, sp, #16           // Reservar espacio en la pila (16 bytes)
        STR x9, [sp]              // Almacenar el valor de x9 (número de filas) en la pila

        // Inicializar la columna
        // x11 Sera nuestro contador de las filas
        MOV x11, 11               // Reiniciar el número de columnas
    impresion_columna:
        // Guardar el número de columna en la pila
        SUB sp, sp, #16           // Reservar espacio en la pila (16 bytes)
        STR x11, [sp]             // Almacenar el valor de x11 (número de columnas) en la pila

        LDR  x0, [x25, x26, lsl 3]  // Se carga el valor que tenga nuestra matriz en dicha posicion, en el registro x0
        LDR x1, =value // Buffer donde se alamcenara el numero convertido
        MOV w7, 13 // Largo del Buffer a limpiar
        mLimpiarValue // Se limpia el buffer del numero que se va a convertir

        LDR x1, =value // Buffer donde se alamcenara el numero convertido
        MOV x2, 13  // Tamaño del buffer, sirve para que imprima un cero antes si el numero es de un solo digito
        STP x29, x30, [SP, -16]!     // Guardar x29 y x30 antes de la llamada
        BL itoa                      // Convierte el número a ASCII
        LDP x29, x30, [SP], 16       // Restaurar x29 y x30 después de la llamada
        
        mPrint value, lenValue  // Se imprime el valor uno a uno de la matriz
        mPrint espacio, lenEspacio  // Se imprime un espacio por estetica
        // Recuperar el número de columnas
        LDR x11, [sp]             // Cargar el valor de la columna en x12
        ADD sp, sp, #16           // Liberar el espacio de la pila para la columna

        SUB x11, x11, 1           // Disminuir el número de columnas
        CMP x11, 0                // Comparar si llegamos a 0
        ADD  x26, x26, 1        // Aumentamos el contador de celdas impresas
        CBZ x11, fin_columna           // Si es 0, finalizar impresión de columnas
        B impresion_columna        // Volver a imprimir la columna

    fin_columna:
        // Recuperar el número de filas
        mPrint salto, lenSalto
        LDR x9, [sp]             // Cargar el valor de la fila en x13
        ADD sp, sp, #16           // Liberar el espacio de la pila para la fila

        SUB x9, x9, 1             // Disminuir el número de filas
        CMP x9, 0                 // Comparar si llegamos a 0
        CBZ x9, fin                   // Si es 0, finalizar impresión de filas

        B impresion_fila          // Volver a imprimir la fila
    fin:
        RET
        
limpiarParametro:
    adrp x1, num               // Cargar la página base de 'num'
    add x1, x1, :lo12:num      // Obtener la dirección completa de 'num'

    // Escribir un valor de 0 en 'num' para limpiarla
    mov w5, #0                 // Cargar el valor 0 en el registro w0 (32 bits)
    str w5, [x1]               // Almacenar 0 en la dirección de 'num'
    RET

posicionCelda:
    // Se aplica row-major
    // Fila * número de columnas + columna
    // Ejemplo de como viene num='B23'
    ldr x12, =num // Se carga la direccion de memoria del parametro de la celda
    ldrb w5, [x12], 1 // Se carga el primer valor que se espera sea la letra, y ademas se avanza 1 en la lectura
    SUB w20, w5, 65 // Se resta 65 ya que se espera que sea una letra entre A-K
    /* La secuencia de las letras quedara así
    A=0
    B=1
    C=2
    */
    MOV x5, x12 // Se carga el valor de la fila a x5, esto porque ya se hizo la lectura de la letra y se avanzo al siguiente caracter

    // Columna x20, fila x19
    STP x29, x30, [SP, -16]!
    ldr x8, =fila64 // Este parametro se envia unicamente porque lo pide la funcion sin embargo no se usara
    BL atoi // Conversion de el numero de la fila
    LDP x29, x30, [SP], 16
    SUB x7, x7, 1   // De la funcion Atoi, se tiene que x7 tiene el resultado del numero convertido, se le resta 1
    MOV x19, x7 // Fila=x19

    // Se aplica Row-Major
    MOV x5, 11 // 11 es el numero de columnas
    MUL x5, x5, x19    // x5 = x5 * x19 (el resultado se almacena en x5)
    ADD x5, x5, x20 // x5=posicion final en nuestra matriz
    RET

atoi:  // ascii to int
    SUB x5, x5, 1
    a_contarDigitos:
        LDRB w1, [x12], 1 // post - index
        CBZ w1, a_convertir
        CMP w1, 32
        BEQ a_convertir
        B a_contarDigitos

    a_convertir:
        SUB x12, x12, 2 // Index de la cadena a recorrer
        MOV x4, 1   // Multiplicador
        MOV x7, 0  // Resultado
        
    a_convertirChars:
        LDRB w1, [x12], -1
        CMP w1, 45
        BEQ a_negativeNum

        SUB x1, x1, 48
        MUL x1, x1, x4
        ADD x7, x7, x1

        MOV x6, 10
        MUL x4, x4, x6
        
        CMP x12, x5
        BNE a_convertirChars
        B a_endConvertir
    a_negativeNum:
        NEG x7, x7
    a_endConvertir:
        STR x7, [x8] // usando 32 bits
    
    RET


verificarParametro:
    // Retorna en w4, el tipo de parametro
    /*
    w4=1=numero
    w4=2=celda
    */
    LDR x10, =num   // Direccion en memoria donde se almacena el parametro
    MOV x4, 0   // x4=tipo de parametro puede ser: Numero, Celda, Retorno (falta implementar)
                // En la funcion x4 tambien nos servira para llevar el control de caracteres leidos

    v_celda_columna:
        LDRB w20, [x0], #1  // Se Carga en w20 lo que sigue del comando, se espera que ya sea algun parametro
        ADD x4, x4, 1   // Numero de caracteres leidos se aumenta
        CMP w20, #'A'             // Compara w20 con 'A' (65 en ASCII)
        BLT v_analizar_numero_resta        // Si w20 < 'A', salta a evaluar el numero

        CMP w20, #'K'             // Compara w20 con 'K' (75 en ASCII)
        BGT v_fin        // Si w20 > 'K', salta fuera del rango (deberia de dar error)
        STRB w20, [x10], 1 // Guardar la columna de la celda en num
    v_celda_fila:
        LDRB w20, [x0], #1  // Se carga el siguiente caracter del comando
        ADD x4, x4, 1   // Nuevamente se aumenta la cantidad de caracteres leidos

        CMP w20, #' '             // Compara w20 con ' ' (65 en ASCII)
        BEQ v_retonar_celda        // Si w20 = ' ', salta a retornar celda
        CMP w20, 10             // Compara w20 con '\10' (65 en ASCII)
        BEQ v_retonar_celda        // Si w20 = '\10', salta a retornar celda
        CBZ w20, v_retonar_celda // Si w20 = '\0', salta a retornar celda

        CMP w20, #'0'             // Compara w20 con '0' (65 en ASCII)
        BLT v_fin        // Si w20 < '0', salta fuera del rango deberia de dar error

        CMP w20, #'9'             // Compara w20 con '9' (75 en ASCII)
        BGT v_fin        // Si w20 > '9', s, salta fuera del rango deberia de dar error
        STRB w20, [x10], 1 // Guardar la fila de la celda en num
        B v_celda_fila  // Sigue leyendo los numeros de la fila
    v_analizar_numero_resta:
        // En este caso como se evaluo primero la celda y ya hizo avance en el buffer
        // Se debe restar lo que leyo para que pueda leer el numero completo en caso sea numero
        SUB x0, x0, x4
        MOV x4, 0 // Se reinicia las lecturas que se estan haciendo
    v_analizar_numero:
        LDRB w20, [x0], #1
        CMP w20, #' '          // Compara el carácter con ' '
        BEQ v_retornar_numero           // Si es igual, salta a v_retornar_numero
        CMP w20, #0          // Compara el carácter con nulo
        BEQ v_retornar_numero           // Si es igual, salta a retornar_numero
        // VALIDACIONES QUE SEAN SOLO NUMEROS (Pendientes)
        STRB w20, [x10], 1
        B v_analizar_numero
    v_retornar_numero:
        MOV w4, 1
        B v_fin
    v_retonar_celda:
        MOV w4, 2
        B v_fin
    v_fin:

    RET

verificarComando:
    // w4 => tendra el retorno con el tipo de comando
    LDR x0, =comando    // Se carga la direccion de memoria del comando
    LDRB w20, [x0], #1  // Se carga el primer caracter en w20
    CMP w20, #'G'          // Compara el carácter con 'G'
    BEQ guardar           // Si es igual, salta a guardar
    B fin_verificar     // Si no encuentra ningun comando marcar error
    guardar:
        LDRB w20, [x0], #1  // Se sigue avanzando en el buffer (comando)
        CMP w20, #'U'          // Compara el carácter con 'U'
        BNE fin_verificar           // Si no es igual, salta a fin_verificar

        LDRB w20, [x0], #1
        CMP w20, #'A'          // Compara el carácter con 'A'
        BNE fin_verificar           // Si es igual, salta a fin_verificar

        LDRB w20, [x0], #1
        CMP w20, #'R'          // Compara el carácter con 'R'
        BNE fin_verificar           // Si es igual, salta a fin_verificar
        
        LDRB w20, [x0], #1
        CMP w20, #'D'          // Compara el carácter con 'D'
        BNE fin_verificar           // Si es igual, salta a fin_verificar

        LDRB w20, [x0], #1
        CMP w20, #'A'          // Compara el carácter con 'A'
        BNE fin_verificar           // Si es igual, salta a fin_verificar

        LDRB w20, [x0], #1
        CMP w20, #'R'          // Compara el carácter con 'R'
        BNE fin_verificar           // Si es igual, salta a fin_verificar

        LDRB w20, [x0], #1
        CMP w20, #' '          // Compara el carácter con ' '
        BNE fin_verificar           // Si es igual, salta a fin_verificar

        MOV w4, 1   // w4=1 (Comando Guardar encontrado)
    fin_verificar:
    RET

verificarPalabraIntermedia:
    // Retorna en w4, el tipo de palabra intermedia
    LDRB w20, [x0], #1      // Se carga el valor de memoria de x0 en w20
    CMP w20, #'E'          // Compara el carácter con 'E'
    BEQ en           // Si es igual, salta a en
    B fin_verificar_intermedia
    en:
        LDRB w20, [x0], #1
        CMP w20, #'N'          // Compara el carácter con 'E'
        BNE fin_verificar_intermedia           // Si es igual, salta a fin_verificar_intermedia

        LDRB w20, [x0], #1
        CMP w20, #' '          // Compara el carácter con 'E'
        BNE fin_verificar_intermedia           // Si es igual, salta a fin_verificar_intermedia

        MOV w4, 1 // w4=1 palabra intermedia EN encontrada
    fin_verificar_intermedia:
    RET

getComando:
    mPrint ingresoComando, lenIngresoComando
    mRead 0, comando, 50
    RET

itoa:
    // params: x0 => number, x1 => buffer address, x2 => cantidad a mover
    MOV x8, 0 // contador de numeros
    MOV x3, 10 // base
    MOV w17, 1 // Control para ver si el numero es negativo
    i_negativo:
        TST x0, #0x8000000000000000
        BNE i_complemento_2
        B i_convertirAscii
    i_complemento_2:
        MVN x0, x0
        ADD x0, x0, 1
        MOV w17, 0
    i_convertirAscii:
        UDIV x16, x0, x3        // DIVISION
        MSUB x6, x16, x3, x0    // Sacar el residuo de la division
        ADD w6, w6, 48          // Sumarle 48 al residuo para que sea un numero en ascci

        // GUARDAR EN PILA
        SUB sp, sp, #8      // Reservar 16 bytes (por alineación) en la pila
        STR w6, [sp, #0]     // Almacenar el valor de w6 en la pila en la dirección apuntada por sp

        ADD x8, x8, 1   // Sumamos la cantidad de numeros leidos
        MOV x0, x16     // Movemos el resultado de la division (cociente) para x0 para la siguiente iteracion agarre el nuevo valor
        CBNZ x16, i_convertirAscii

        CBZ w17, i_agregar_signo
        B i_agregar_ceros
    i_agregar_signo:
        MOV w6, 45
        // GUARDAR EN PILA
        SUB sp, sp, #8      // Reservar 16 bytes (por alineación) en la pila
        STR w6, [sp, #0]     // Almacenar el valor de w6 en la pila en la dirección apuntada por sp
        ADD x8, x8, 1
    i_agregar_ceros:
        MOV x16, x2
        SUB x16, x16, x8
        ADD x1, x1, x16
    i_almacenar:
        // Cargar el valor de vuelta desde la pila
        LDR w6, [sp, #0]     // Cargar el valor almacenado en la pila a w7
        STRB w6, [x1], 1
        // Limpiar el espacio de la pila
        ADD sp, sp, #8      // Recuperar los 16 bytes de la pila

        SUB x8, x8, 1   // Restamos el contador de la pila
        CBNZ x8, i_almacenar
        // B i_almacenar
    i_endConversion:
        RET

parametroNumero:
    CMP w4, 01  // Si el parametro es una celda
    BEQ parametro_numero
    CMP w4, 02  // Si el parametro es una celda
    BEQ parametro_celda
    B retornar_parametro
    parametro_numero:
        // El numero de celda estara en w4
        ldr x12, =num
        ldr x5, =num
        // ldr x8, =num64
        STP x29, x30, [SP, -16]!     // Guardar x29 y x30 antes de la llamada
        BL atoi
        LDP x29, x30, [SP], 16       // Restaurar x29 y x30 después de la llamada
        B retornar_parametro
    parametro_celda:
        STP x29, x30, [SP, -16]!     // Guardar x29 y x30 antes de la llamada
        BL posicionCelda
        LDP x29, x30, [SP], 16

        ADRP x25, tablero
        ADD  x25, x25, :lo12:tablero       // Sumar el offset para la dirección completa
        LDR  x2, [x25, x5]  // Se carga el valor que tenga nuestra matriz en dicha posicion, en el registro x0
        // LDR x8, =num64
        STR x2, [x8]
    retornar_parametro:
        RET
_start:
    mPrint clear_screen, lenClear

    // imprimir_hoja:
        //mImprimirCeldas
        // mImprimirValores
    ingreso_comando:
        BL imprimirCeldas
        BL getComando
        // Apartir de aqui en w20 estara el recorrido del comando ingresado (GUARDAR 13 EN B12)
        // El valor de x0 no se debe perder ya que tiene la direccion de memoria del comando
        // Si en el proceso de lectura del comando se usa x0, se debera de usar la pila para no perder el valor de x0
        BL verificarComando // Se verifica el comando (GUARDAR, SUMAR,ETC..)
        BL limpiarParametro // Se limpia la variable num que es la encargada de tener los valores del parametro
        // Este es el primer parametro
        BL verificarParametro // Se verifica el tipo de parametro (Numero, Celda o Retorno) y guarda el valor del parametro para luego procesarlo
        LDR x8, =param1
        BL parametroNumero

        BL verificarPalabraIntermedia
        BL limpiarParametro
        // Este es el segundo parametro
        BL verificarParametro
        LDR x8, =param2
        BL parametroNumero
    concluir_guardar:
        BL posicionCelda
        LDR x8, =param1
        LDR x9, [x8]
        LDR x11, =param2
        LDR x10, [x11]

        ADRP x25, tablero
        ADD  x25, x25, :lo12:tablero       // Sumar el offset para la dirección completa
        STR  x9, [x25, x5, lsl 3]
    fin_programa:
        // BL imprimirCeldas
        B ingreso_comando
        mov x0, 0
        mov x8, 93
        svc 0
