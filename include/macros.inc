; Instantanea de 14 bytes: AX,BX,CX,DX,SI,DI,FLAGS.
; PUSHF/POP memoria y MOV preservan los flags: seguro entre ADD y ADC.
%macro SNAP 1
    pushf
    pop word [%1+12]
    mov [%1], ax
    mov [%1+2], bx
    mov [%1+4], cx
    mov [%1+6], dx
    mov [%1+8], si
    mov [%1+10], di
%endmacro
