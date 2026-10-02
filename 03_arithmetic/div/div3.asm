 ; Unsigned division: EDX:EAX / r/m32 → EAX = quotient, EDX = remainder
;: nasm -f elf32 div3.asm -o div3.o
; ld -m elf_i386 div3.o -o div3
;./div3
section .data
    dividend dd 300000000   ; Low part
    highpart dd 0           ; High part
    divisor  dd 1000

section .text
    global _start

_start:
    mov eax, [dividend]
    mov edx, [highpart]
    mov ebx, [divisor]
    div ebx                 ; EAX = 300000, EDX = 0

    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80
