; Johan Barrera - 1152538 - Arquitectura de computadores - Unidad 8
; Ejecutable DOS COM de 16 bits, compatible con instrucciones 8086.
; Ensamblar desde la raiz: nasm -f bin post2c.asm -o post2c.com
bits 16
cpu 8086
org 100h
%include "include/macros.inc"
jmp inicio
operando_a db 0
operando_b db 0
operador db 0
producto dw 0
cociente db 0
resto db 0
pA db 'Primer operando (0-9): $'
pB db 13,10,'Segundo operando (0-9): $'
prompt_operacion db 13,10,'Operacion (* o /): $'
msgR db 13,10,'Resultado: $'
msgResto db ' ; Resto: $'
msgCero db 13,10,'Division por cero.',13,10,'$'
msgDig db 13,10,'Entrada invalida. Digite 0-9: $'
msgOp db 13,10,'Operacion invalida. Use * o /: $'
inicio:
    push cs
    pop ds
    mov ax, ds
    mov es, ax
    cld
    call encabezado
    mov dx, pA
    call texto_dos
    call leer_digito
    mov [operando_a], al
    mov dx, pB
    call texto_dos
    call leer_digito
    mov [operando_b], al
    mov dx, prompt_operacion
    call texto_dos
leer_operador:
    call leer_no_blanco
    cmp al, '*'
    je operar
    cmp al, '/'
    je operar
    mov dx, msgOp
    call texto_dos
    jmp leer_operador
operar:
    mov [operador], al
    cmp al, '*'
    je multiplicar
    cmp byte [operando_b], 0
    je division_cero
    xor ah, ah
    mov al, [operando_a]
    div byte [operando_b]
cp_div:
    mov [cociente], al
    mov [resto], ah
    mov dx, msgR
    call texto_dos
    xor ax, ax
    mov al, [cociente]
    call imprimirAX
    mov dx, msgResto
    call texto_dos
    xor ax, ax
    mov al, [resto]
    call imprimirAX
    call nueva_linea
    jmp salir
multiplicar:
    mov al, [operando_a]
    mul byte [operando_b]
cp_mul:
    mov [producto], ax
    mov dx, msgR
    call texto_dos
    call imprimirAX
    call nueva_linea
    jmp salir
division_cero:
    mov dx, msgCero
    call texto_dos
    jmp salir
leer_digito:
    call leer_no_blanco
    cmp al, '0'
    jb invalido
    cmp al, '9'
    ja invalido
    sub al, '0'
    ret
invalido:
    mov dx, msgDig
    call texto_dos
    jmp leer_digito
leer_no_blanco:
    mov ah, 01h
    int 21h
    cmp al, 13
    je leer_no_blanco
    cmp al, 10
    je leer_no_blanco
    cmp al, ' '
    je leer_no_blanco
    ret

%include "include/comun.inc"
