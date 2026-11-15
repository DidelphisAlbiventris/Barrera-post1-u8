; Johan Barrera - 1152538 - Arquitectura de computadores - Unidad 8
; Ejecutable DOS COM de 16 bits, compatible con instrucciones 8086.
; Ensamblar desde la raiz: nasm -f bin post2b.asm -o post2b.com
bits 16
cpu 8086
org 100h
%include "include/macros.inc"
jmp inicio
sum_raw times 14 db 0
sum_bcd times 14 db 0
carry_bcd times 14 db 0
sub_raw times 14 db 0
sub_bcd times 14 db 0
sub19_bcd times 14 db 0
msg_suma db 'BCD suma: $'
msg_carry db '99 + 01 = $'
msg_cf db ' ; CF=$'
msg_das db 'DAS OK: $'
msg_19 db '20 - 01 = $'
msg_error db 'ERROR en ajuste BCD.',13,10,'$'
inicio:
    push cs
    pop ds
    mov ax, ds
    mov es, ax
    cld
    call encabezado
    mov al, 47h
    add al, 38h
cp_pre_daa:
    SNAP sum_raw
    daa
cp_daa:
    SNAP sum_bcd
    cmp al, 85h
    jne error_bcd
    mov dx, msg_suma
    call texto_dos
    call bcd_dos
    call nueva_linea
    mov si, sum_raw
    call mostrar_estado
    mov si, sum_bcd
    call mostrar_estado
    mov al, 99h
    add al, 01h
    daa
cp_daa_carry:
    SNAP carry_bcd
    jnc error_bcd
    cmp al, 0
    jne error_bcd
    mov dx, msg_carry
    call texto_dos
    call bcd_dos
    mov dx, msg_cf
    call texto_dos
    mov ax, [carry_bcd+12]
    and ax, 1
    call imprimirAX
    call nueva_linea
    mov si, carry_bcd
    call mostrar_estado
    mov al, 73h
    sub al, 28h
cp_pre_das:
    SNAP sub_raw
    das
cp_das:
    SNAP sub_bcd
    cmp al, 45h
    jne error_bcd
    mov dx, msg_das
    call texto_dos
    call bcd_dos
    call nueva_linea
    mov si, sub_raw
    call mostrar_estado
    mov si, sub_bcd
    call mostrar_estado
    mov al, 20h
    sub al, 01h
    das
cp_das19:
    SNAP sub19_bcd
    jc error_bcd
    cmp al, 19h
    jne error_bcd
    mov dx, msg_19
    call texto_dos
    call bcd_dos
    call nueva_linea
    mov si, sub19_bcd
    call mostrar_estado
    jmp pausa_salir
error_bcd:
    mov dx, msg_error
    call texto_dos
    jmp pausa_salir

%include "include/comun.inc"
