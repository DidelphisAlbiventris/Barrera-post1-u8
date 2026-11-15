; Johan Barrera - 1152538 - Arquitectura de computadores - Unidad 8
; Ejecutable DOS COM de 16 bits, compatible con instrucciones 8086.
; Ensamblar desde la raiz: nasm -f bin post2.asm -o post2.com
bits 16
cpu 8086
org 100h
%include "include/macros.inc"
jmp inicio
aLo dw 0FFFFh
aHi dw 1
bLo dw 1
bHi dw 1
resLo dw 0
resHi dw 0
restaLo dw 0
restaHi dw 0
suma_baja times 14 db 0
suma_alta times 14 db 0
resta_baja times 14 db 0
resta_alta times 14 db 0
msg_suma db 'Suma OK: $'
msg_resta db 'Resta OK: $'
msg_error db 'ERROR: el resultado no coincide.',13,10,'$'
inicio:
    push cs
    pop ds
    mov ax, ds
    mov es, ax
    cld
    call encabezado
    mov ax, [aLo]
    mov dx, [aHi]
    mov bx, [bLo]
    mov cx, [bHi]
    add ax, bx
cp_add_bajo:
    SNAP suma_baja           ; conserva CF=1 entre ADD y ADC
    adc dx, cx
cp_adc:
    SNAP suma_alta
    mov [resLo], ax
    mov [resHi], dx
    cmp ax, 0
    jne error_aritmetica
    cmp dx, 3
    jne error_aritmetica
    mov dx, msg_suma
    call texto_dos
    mov ax, [resHi]
    call hex_word
    mov dl, ':'
    call caracter_dos
    mov ax, [resLo]
    call hex_word
    call nueva_linea
    mov si, suma_baja
    call mostrar_estado
    mov si, suma_alta
    call mostrar_estado
    ; Resta: 00030000h - 00010001h = 0001FFFFh.
    mov ax, 0
    mov dx, 3
    mov bx, 1
    mov cx, 1
    sub ax, bx
cp_sub_bajo:
    SNAP resta_baja          ; conserva el prestamo
    sbb dx, cx
cp_sbb:
    SNAP resta_alta
    mov [restaLo], ax
    mov [restaHi], dx
    cmp ax, 0FFFFh
    jne error_aritmetica
    cmp dx, 1
    jne error_aritmetica
    mov dx, msg_resta
    call texto_dos
    mov ax, [restaHi]
    call hex_word
    mov dl, ':'
    call caracter_dos
    mov ax, [restaLo]
    call hex_word
    call nueva_linea
    mov si, resta_baja
    call mostrar_estado
    mov si, resta_alta
    call mostrar_estado
    jmp pausa_salir
error_aritmetica:
    mov dx, msg_error
    call texto_dos
    jmp pausa_salir

%include "include/comun.inc"
