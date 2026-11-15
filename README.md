# Unidad 8 — Cadenas y aritmética avanzada

**Estudiante:** Johan Barrera  
**Código:** 1152538  
**Asignatura:** Arquitectura de computadores  
**Universidad:** UFPS — Cúcuta  
**Repositorio:** `barrera-post1-u8`

## Parte 1

### Decisión técnica 1 — REP MOVSB frente a LODSB/STOSB

El estudiante selecciona REP MOVSB cuando la tarea consiste en copiar un bloque completo sin modificar sus bytes. El prefijo expresa la repetición mediante CX y evita 
que el programa tenga que emitir explícitamente una carga, una escritura y un salto por cada elemento. Esto simplifica el código y elimina parte del trabajo de control 
de un bucle manual.

La implementación interna y el rendimiento dependen del procesador: no se afirma que siempre sea microcódigo idéntico ni que cualquier REP MOVSB sea más rápido para 
todos los tamaños, alineamientos y CPUs. Para este laboratorio constituye la opción natural de copia directa; en una aplicación orientada al rendimiento se mediría el 
entorno objetivo. En cambio, post1e necesita inspeccionar AL, reconocer minúsculas y transformar el byte antes de almacenarlo.

REP MOVSB por sí solo no permite insertar esa lógica entre lectura y escritura, por lo que se emplean LODSB y STOSB con un bucle explícito. Una alternativa sería 
copiar y transformar en otra pasada, pero no cumpliría el propósito de transformar durante la copia. Para una cadena larga sin transformación se conserva la 
preferencia por una rutina de copia de bloques, en lugar de añadir innecesariamente comprobaciones por carácter.

En ambos enfoques se preparan DS:SI como origen, ES:DI como destino y CX como cantidad válida; CLD establece el recorrido hacia direcciones crecientes. En la 
transformación se modifica únicamente el intervalo ASCII de a hasta z, restando 20h antes de STOSB; los demás bytes se conservan.

### Decisión técnica 2 — CX fijo frente al terminador

El estudiante utiliza un CX fijo cuando conoce la extensión válida de los buffers. En post1d se comparan ocho bytes de tres literales de ocho caracteres, por lo que no 
se invade memoria ajena y se compara todo el contenido relevante. Las instrucciones no reconocen el nulo como terminador especial: SCASB solo compara AL y CMPSB solo 
compara bytes, mientras los prefijos combinan ZF y CX.

Debe precisarse una afirmación del enunciado: si dos cadenas bien terminadas tienen cinco y ocho caracteres y sus primeros cinco coinciden, REPE CMPSB se detiene al 
comparar el nulo de la corta con el sexto carácter de la larga, porque son distintos; ese caso no lee automáticamente más allá del nulo. El riesgo sí aparece, por 
ejemplo, al comparar dos cadenas cortas iguales cuyos nulos también coinciden, si CX permite continuar, o al buscar con SCASB un carácter distinto de cero más allá del 
rango válido. Para longitudes desconocidas se cargaría un byte de cada cadena, se comprobaría la desigualdad y, si son iguales, el nulo común; cualquier nulo frente a 
un byte no nulo ya determina diferencia.

Además se impondrían capacidades máximas, porque buscar un terminador inexistente también puede salir del buffer. Un CX inicial cero requiere tratamiento explícito: no 
se ejecuta una comparación y ZF conserva un estado previo.

## Parte 2

### Decisión técnica 3 — Ajuste según el formato BCD

**Aspectos del enunciado que se responden:** BCD empaquetado y desempaquetado; caso 47h; suma 07h+08h y error de representación.

El estudiante elige DAA/DAS cuando AL representa dos dígitos empaquetados y AAA/AAS cuando el resultado debe conservar un dígito por byte. La diferencia es de representación, no de la forma en que se escribe un literal hexadecimal. Aplicar AAA a un valor empaquetado como 47h, con un estado previo de flags que no exija otro ajuste, elimina el nibble alto y deja 07h; por tanto destruye la representación de las decenas que se pretendía conservar.

Después de leer dos dígitos ASCII y restar 30h, una suma que deba producir decena en AH y unidad en AL requiere AAA, con AH inicializado. Para 7+8, AAA produce AH=01h y AL=05h. Debe corregirse otra simplificación del enunciado: DAA sobre el resultado 0Fh produce AL=15h, que sí representa correctamente quince en BCD empaquetado.

El error consiste en tratar después 15h como si fuera un único dígito desempaquetado o esperar que AH contenga la decena. Por ejemplo, sumar 30h a ese AL produciría 45h, la letra E, y no los caracteres 1 y 5. La selección del ajuste debe mantenerse coherente con almacenamiento, propagación decimal y rutina de impresión.

Los ajustes se aplican inmediatamente después de la operación aritmética correspondiente, porque emplean las banderas producidas por ella. Como ejemplo empaquetado, 47h+38h produce inicialmente 7Fh y DAA lo ajusta a 85h. Para restas se mantiene la misma distinción de representación mediante DAS o AAS.

### Decisión técnica 4 — ADC fijo frente a precisión arbitraria

**Aspectos del enunciado que se responden:** Generalización a N palabras; inicialización y propagación del acarreo; mantenimiento y costo del bucle.

El estudiante conserva ADD/ADC para dos palabras porque el tamaño de 32 bits es conocido y la secuencia resulta directa, pequeña y sin control de bucle. Para N 
palabras se recorren los operandos desde la palabra menos significativa hasta la más significativa, almacenando cada resultado y propagando CF a la siguiente suma. La 
primera palabra puede usar ADD para no depender del acarreo anterior; las restantes deben incluirlo mediante ADC.

Sin embargo, no es obligatorio que la primera instrucción sea ADD: inicializar CF con CLC y usar ADC desde la primera palabra también es correcto. El bucle debe 
conservar ese acarreo entre iteraciones; avanzar punteros con ADD los modificaría y podría destruirlo. Se pueden utilizar LEA o INC, que no alteran CF, y LOOP para el 
contador.

También se controla N=0 antes de comenzar. Un bucle genérico facilita cambiar la precisión y reutilizar el código para datos de muchas palabras, a costa del control de 
iteración y actualización de punteros. Para tamaños pequeños como 48 o 64 bits, una secuencia desenrollada sigue siendo perfectamente razonable.

La elección depende del tamaño y la variabilidad de los datos, y el rendimiento se confirma en el procesador objetivo, sin atribuir tiempos físicos universales a 
DOSBox.
