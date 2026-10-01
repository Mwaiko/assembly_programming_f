; =============================================================
; debug_practice.asm
;
; A NASM x86 (32-bit) Linux program built for practicing GDB.
; It has no external dependencies (no libc) -- just raw
; int 0x80 syscalls -- so what you see in registers/memory is
; exactly what the program does, nothing hidden by a runtime.
;
; What it does when run normally:
;   1. Draws an ASCII "window" (box) to the terminal, built
;      byte-by-byte in a buffer using a loop.
;   2. Bubble-sorts a 10-element array in .data.
;   3. Prints the sorted array.
;   4. Computes fibonacci(10) recursively and prints it.
;
; Good things to practice in GDB:
;   - breakpoints on function labels (draw_window, bubble_sort,
;     fibonacci, print_num)
;   - stepi / nexti through the byte-building loop and watching
;     border_buf fill up in memory
;   - watchpoints on array elements during bubble_sort
;   - backtrace (bt) during fibonacci's recursion, and watching
;     the stack grow/shrink with each call
;   - examining registers (info registers) mid swap in bubble_sort
;   - x/10dw &array to view the array as a memory dump
;
; Build:
;   nasm -f elf32 -g -F dwarf debug_practice.asm -o debug_practice.o
;   ld -m elf_i386 debug_practice.o -o debug_practice
;
; Run:
;   ./debug_practice
;
; Debug:
;   gdb ./debug_practice
; =============================================================

section .data
    welcome_msg db 10, "=========================================", 10
                db "   ASCII WINDOW  --  GDB Practice Program", 10
                db "=========================================", 10, 10
    welcome_len equ $ - welcome_msg

    ; Array to sort. Ten dwords, deliberately unsorted.
    array     dd 5, 3, 8, 1, 9, 2, 7, 4, 6, 0
    array_len equ 10

    sorted_msg db 10, "Sorted array: "
    sorted_len equ $ - sorted_msg

    fib_msg db 10, "Fibonacci(10) = "
    fib_len equ $ - fib_msg

    plus_char  db '+'
    pipe_char  db '|'
    newline    db 10
    space_buf  times 40 db ' '   ; also used as a single-space source

section .bss
    border_buf resb 41   ; 40 dashes + newline, built at runtime
    num_buffer resb 12   ; scratch space for integer -> ASCII conversion

section .text
    global _start

; -------------------------------------------------------------
; _start: program entry point / orchestrator
; -------------------------------------------------------------
_start:
    call draw_window

    mov eax, 4              ; sys_write
    mov ebx, 1               ; fd = stdout
    mov ecx, welcome_msg
    mov edx, welcome_len
    int 0x80

    call bubble_sort

    mov eax, 4
    mov ebx, 1
    mov ecx, sorted_msg
    mov edx, sorted_len
    int 0x80

    call print_array

    push dword 10            ; argument n = 10
    call fibonacci
    add esp, 4                ; pop the argument
    mov edi, eax               ; stash fib(10) result (edi is free here)

    mov eax, 4
    mov ebx, 1
    mov ecx, fib_msg
    mov edx, fib_len
    int 0x80

    mov eax, edi
    call print_num

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; exit(0)
    mov eax, 1
    xor ebx, ebx
    int 0x80


; -------------------------------------------------------------
; draw_window: builds a horizontal border in border_buf one
; byte at a time (a loop worth single-stepping through), then
; prints a simple box to the terminal.
; -------------------------------------------------------------
draw_window:
    push ebp
    mov ebp, esp

    ; --- build 40 dashes into border_buf using a counting loop ---
    mov ecx, 0
.build_loop:
    cmp ecx, 40
    jge .build_done
    mov byte [border_buf + ecx], '-'
    inc ecx
    jmp .build_loop
.build_done:
    mov byte [border_buf + 40], 10   ; newline after the dashes

    ; top border: '+' then the 40 dashes + newline
    mov eax, 4
    mov ebx, 1
    mov ecx, plus_char
    mov edx, 1
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, border_buf
    mov edx, 41
    int 0x80

    ; three blank rows: '|' + spaces + '|' + newline
    mov ecx, 3
.row_loop:
    push ecx
    call print_blank_row
    pop ecx
    dec ecx
    jnz .row_loop

    ; bottom border: '+' + dashes (no newline yet) + '+' + newline
    mov eax, 4
    mov ebx, 1
    mov ecx, plus_char
    mov edx, 1
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, border_buf
    mov edx, 40               ; dashes only this time, skip the newline byte
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, plus_char
    mov edx, 1
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    mov esp, ebp
    pop ebp
    ret


; -------------------------------------------------------------
; print_blank_row: prints "|" + 40 spaces + "|" + newline
; -------------------------------------------------------------
print_blank_row:
    push ebp
    mov ebp, esp

    mov eax, 4
    mov ebx, 1
    mov ecx, pipe_char
    mov edx, 1
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, space_buf
    mov edx, 40
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, pipe_char
    mov edx, 1
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    mov esp, ebp
    pop ebp
    ret


; -------------------------------------------------------------
; bubble_sort: classic O(n^2) bubble sort over `array`
; (array_len dwords). Good spot for a watchpoint:
;   watch array
;   watch *(int*)&array
; and for inspecting eax/ebx during each compare/swap.
; -------------------------------------------------------------
bubble_sort:
    push ebp
    mov ebp, esp
    push edi
    push ebx

    mov ecx, array_len - 1     ; outer pass counter (n-1 passes)
.outer_loop:
    xor edi, edi                ; j = 0
.inner_loop:
    mov eax, [array + edi*4]         ; eax = array[j]
    mov ebx, [array + edi*4 + 4]      ; ebx = array[j+1]
    cmp eax, ebx
    jle .no_swap
    mov [array + edi*4], ebx          ; swap
    mov [array + edi*4 + 4], eax
.no_swap:
    inc edi
    cmp edi, array_len - 1
    jl .inner_loop

    loop .outer_loop            ; dec ecx; jump if ecx != 0

    pop ebx
    pop edi
    mov esp, ebp
    pop ebp
    ret


; -------------------------------------------------------------
; print_array: prints each dword in `array`, space-separated
; -------------------------------------------------------------
print_array:
    push ebp
    mov ebp, esp
    push esi

    xor esi, esi
.print_loop:
    cmp esi, array_len
    jge .print_done

    mov eax, [array + esi*4]
    call print_num

    push esi
    mov eax, 4
    mov ebx, 1
    mov ecx, space_buf         ; one byte from a 40-space buffer = one space
    mov edx, 1
    int 0x80
    pop esi

    inc esi
    jmp .print_loop
.print_done:
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    pop esi
    mov esp, ebp
    pop ebp
    ret


; -------------------------------------------------------------
; print_num: prints the unsigned integer in eax as decimal ASCII
; Converts by repeated division by 10, building the string from
; the end of num_buffer backwards.
; -------------------------------------------------------------
print_num:
    push ebp
    mov ebp, esp
    push ebx
    push ecx
    push edx
    push edi

    mov edi, num_buffer
    add edi, 12              ; one past the end of the 12-byte buffer
    mov ecx, 0                ; digit counter

    cmp eax, 0
    jne .convert_loop
    dec edi
    mov byte [edi], '0'
    inc ecx
    jmp .print_digits

.convert_loop:
    cmp eax, 0
    je .print_digits
    xor edx, edx
    mov ebx, 10
    div ebx                   ; eax = eax/10, edx = eax mod 10
    add edx, '0'
    dec edi
    mov [edi], dl
    inc ecx
    jmp .convert_loop

.print_digits:
    mov edx, ecx              ; digit count -> edx (syscall length)
    mov ecx, edi               ; buffer pointer -> ecx (syscall buffer)
    mov eax, 4
    mov ebx, 1
    int 0x80

    pop edi
    pop edx
    pop ecx
    pop ebx
    mov esp, ebp
    pop ebp
    ret


; -------------------------------------------------------------
; fibonacci: recursive fibonacci(n), argument passed on the
; stack at [ebp+8], result returned in eax.
;
; Great for: `break fibonacci`, then `bt` (backtrace) a few
; calls deep to watch the call stack build up, and `finish` to
; watch it unwind and see partial sums accumulate.
; -------------------------------------------------------------
fibonacci:
    push ebp
    mov ebp, esp

    mov eax, [ebp+8]          ; eax = n
    cmp eax, 1
    jle .base_case

    mov eax, [ebp+8]
    dec eax
    push eax
    call fibonacci             ; fib(n-1)
    add esp, 4
    push eax                    ; stash fib(n-1) result

    mov eax, [ebp+8]
    sub eax, 2
    push eax
    call fibonacci             ; fib(n-2)
    add esp, 4

    pop ebx                    ; ebx = fib(n-1)
    add eax, ebx                ; eax = fib(n-1) + fib(n-2)
    jmp .done

.base_case:
    mov eax, [ebp+8]           ; n <= 1: return n

.done:
    mov esp, ebp
    pop ebp
    ret