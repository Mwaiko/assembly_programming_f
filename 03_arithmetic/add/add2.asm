; add16.asm
;: nasm -f elf32 add2.asm -o add2.o
; ld -m elf_i386 add2.o -o add2
;./add2
section .data
    num1 dw 32000
    num2 dw 500
    result dw 0

section .text
    global _start

_start:
    mov ax, [num1]
    add ax, [num2]       ; AX = num1 + num2
    mov [result], ax

    mov eax, 1
    xor ebx, ebx   ; zero flag set
    int 0x80

