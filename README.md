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
