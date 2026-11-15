; Johan Barrera - 1152538 - Arquitectura de computadores - Unidad 8
; Ejecutable DOS COM de 16 bits, compatible con instrucciones 8086.
; Ensamblar desde la raiz: nasm -f bin post2d.asm -o post2d.com
bits 16
cpu 8086
org 100h
%include "include/macros.inc"
jmp inicio
aaa_raw times 14 db 0
aaa_final times 14 db 0
aas_raw times 14 db 0
aas_final times 14 db 0
msg_suma db 'AAA: 7 + 8 = $'
msg_resta db 'AAS: 13 - 8 = $'
msg_error db 'ERROR en BCD desempaquetado.',13,10,'$'
inicio:
    push cs
    pop ds
    mov ax, ds
    mov es, ax
    cld
    call encabezado
    mov ax, 0007h           ; AH=0 es imprescindible
    add al, 08h
cp_pre_aaa:
    SNAP aaa_raw
    aaa
cp_aaa:
    SNAP aaa_final
    cmp ax, 0105h
    jne error_unpacked
    mov dx, msg_suma
    call texto_dos
    mov dl, ah
    add dl, '0'
    call caracter_dos
    mov dl, al
    add dl, '0'
    call caracter_dos
    call nueva_linea
    mov si, aaa_raw
    call mostrar_estado
    mov si, aaa_final
    call mostrar_estado
    mov ax, 0103h           ; AH=1 decena y AL=3 unidades: 13 desempaquetado
    sub al, 08h
cp_pre_aas:
    SNAP aas_raw
    aas
cp_aas:
    SNAP aas_final
    cmp ax, 0005h
    jne error_unpacked
    mov dx, msg_resta
    call texto_dos
    call imprimirAX
    call nueva_linea
    mov si, aas_raw
    call mostrar_estado
    mov si, aas_final
    call mostrar_estado
    jmp pausa_salir
error_unpacked:
    mov dx, msg_error
    call texto_dos
    jmp pausa_salir

%include "include/comun.inc"
