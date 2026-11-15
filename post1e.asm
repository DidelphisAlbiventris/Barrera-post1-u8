; Johan Barrera - 1152538 - Arquitectura de computadores - Unidad 8
; Ejecutable DOS COM de 16 bits, compatible con instrucciones 8086.
; Ensamblar desde la raiz: nasm -f bin post1e.asm -o post1e.com
bits 16
cpu 8086
org 100h
%include "include/macros.inc"
jmp inicio
origen db 'hola, mundo!',0
longitud equ $-origen
borde_antes db 0A5h
destino times longitud db 0
borde_despues db 5Ah
estado times 14 db 0
msg db 'Transformado: $'
inicio:
    push cs
    pop ds
    mov ax, ds
    mov es, ax
    cld
    call encabezado
    mov si, origen
    mov di, destino
    mov cx, longitud
    cld
    jcxz cp_transformado
bucle_transformar:
    lodsb
    cmp al, 'a'
    jb escribir
    cmp al, 'z'
    ja escribir
    sub al, 20h
escribir:
    stosb
    loop bucle_transformar
cp_transformado:
    SNAP estado
    mov dx, msg
    call texto_dos
    mov si, destino
    call texto_cero
    call nueva_linea
    mov si, estado
    call mostrar_estado
    jmp pausa_salir

%include "include/comun.inc"
