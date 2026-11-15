; Johan Barrera - 1152538 - Arquitectura de computadores - Unidad 8
; Ejecutable DOS COM de 16 bits, compatible con instrucciones 8086.
; Ensamblar desde la raiz: nasm -f bin post1b.asm -o post1b.com
bits 16
cpu 8086
org 100h
%include "include/macros.inc"
jmp inicio
origen db 'HOLA, MUNDO!',0
longitud equ $-origen        ; 12 caracteres + NUL = 13 bytes
borde_antes db 0A5h
destino times longitud db 0
borde_despues db 5Ah
estado times 14 db 0
msg db 'Copiado: $'
origen_par db 'HOLA!',0
longitud_par equ $-origen_par ; 6 bytes: caso par adicional
par_antes db 0A5h
destino_par times longitud_par db 0
par_despues db 5Ah
estado_par times 14 db 0
msg_par db 'Caso par (6 bytes): $'
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
    mov ax, cx
    shr cx, 1
    rep movsw
cp_words:
    and ax, 1
    jz fin_copia
    movsb
fin_copia:
cp_copia:
    SNAP estado
    mov dx, msg
    call texto_dos
    mov si, destino
    call texto_cero
    call nueva_linea
    mov si, estado
    call mostrar_estado
    mov si, origen_par
    mov di, destino_par
    mov cx, longitud_par
    cld
    mov ax, cx
    shr cx, 1
    rep movsw
    and ax, 1
    jz fin_par
    movsb
fin_par:
cp_par:
    SNAP estado_par
    mov dx, msg_par
    call texto_dos
    mov si, destino_par
    call texto_cero
    call nueva_linea
    mov si, estado_par
    call mostrar_estado
    jmp pausa_salir

%include "include/comun.inc"
