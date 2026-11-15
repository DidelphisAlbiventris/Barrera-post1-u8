; Johan Barrera - 1152538 - Arquitectura de computadores - Unidad 8
; Ejecutable DOS COM de 16 bits, compatible con instrucciones 8086.
; Ensamblar desde la raiz: nasm -f bin post1c.asm -o post1c.com
bits 16
cpu 8086
org 100h
%include "include/macros.inc"
jmp inicio
cadena db 'Arquitectura de Computadores'
longCad equ $-cadena        ; longitud real: 28 caracteres, sin NUL
    db 0
estado_d times 14 db 0
estado_z times 14 db 0
posicion dw 0
msg_d db "Busqueda de 'd': $"
msg_z db "Busqueda de 'z': $"
msg_hallado db 'Hallado en posicion: $'
msg_no db 'No encontrado.$'
inicio:
    push cs
    pop ds
    mov ax, ds
    mov es, ax
    cld
    call encabezado
    mov dx, msg_d
    call texto_dos
    mov di, cadena
    mov al, 'd'
    mov cx, longCad
    cld
    jcxz no_d
    repne scasb
cp_busca_d:
    SNAP estado_d
    jne no_d
    mov bx, di
    sub bx, cadena
    dec bx
    mov [posicion], bx
    mov dx, msg_hallado
    call texto_dos
    mov ax, bx
    call imprimirAX          ; imprime 13 completo, no un solo digito
    jmp fin_d
no_d:
    mov dx, msg_no
    call texto_dos
fin_d:
    call nueva_linea
    mov si, estado_d
    call mostrar_estado
    mov dx, msg_z
    call texto_dos
    mov di, cadena
    mov al, 'z'
    mov cx, longCad
    cld
    jcxz no_z
    repne scasb
cp_busca_z:
    SNAP estado_z
    jne no_z
    mov bx, di
    sub bx, cadena
    dec bx
    mov dx, msg_hallado
    call texto_dos
    mov ax, bx
    call imprimirAX
    jmp fin_z
no_z:
    mov dx, msg_no
    call texto_dos
fin_z:
    call nueva_linea
    mov si, estado_z
    call mostrar_estado
    jmp pausa_salir

%include "include/comun.inc"
