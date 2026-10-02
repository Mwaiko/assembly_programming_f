; al = quotient, ah = remainder
;: nasm -f elf32 div1.asm -o div1.o
; ld -m elf_i386 div1.o -o div1
;./div1
section .data
    dividend dw 100   ; ax = 100
    divisor  db 7     ; bl = 7

section .text
    global _start

_start:
    mov ax, [dividend]  ; ax = 100
    mov bl, [divisor]   ; al = 7
    div bl              ; al = 14, ah = 2

    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80
