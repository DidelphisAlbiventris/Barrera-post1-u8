; Johan Barrera - 1152538 - Arquitectura de computadores - Unidad 8
; Ejecutable DOS COM de 16 bits, compatible con instrucciones 8086.
; Ensamblar desde la raiz: nasm -f bin post1d.asm -o post1d.com
bits 16
cpu 8086
org 100h
%include "include/macros.inc"
jmp inicio
cad1 db 'NASM x86'
longitud equ $-cad1
    db 0
cad2 db 'NASM x86',0
cad3 db 'NASM ARM',0
estado_igual times 14 db 0
estado_distinto times 14 db 0
msg_1 db 'cad1 vs cad2: $'
msg_2 db 'cad1 vs cad3: $'
msg_igual db 'Iguales.$'
msg_distinto db 'Diferentes.$'
inicio:
    push cs
    pop ds
    mov ax, ds
    mov es, ax
    cld
    call encabezado
    mov dx, msg_1
    call texto_dos
    mov si, cad1
    mov di, cad2
    mov cx, longitud
    cld
    repe cmpsb
cp_igual:
    SNAP estado_igual
    jne distinto_1
    mov dx, msg_igual
    jmp imprimir_1
distinto_1:
    mov dx, msg_distinto
imprimir_1:
    call texto_dos
    call nueva_linea
    mov si, estado_igual
    call mostrar_estado
    mov dx, msg_2
    call texto_dos
    mov si, cad1
    mov di, cad3
    mov cx, longitud
    cld
    repe cmpsb
cp_distinto:
    SNAP estado_distinto
    jne distinto_2
    mov dx, msg_igual
    jmp imprimir_2
distinto_2:
    mov dx, msg_distinto
imprimir_2:
    call texto_dos
    call nueva_linea
    mov si, estado_distinto
    call mostrar_estado
    jmp pausa_salir

%include "include/comun.inc"
