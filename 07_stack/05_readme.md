Register Initialization

mov rax, 0x1122334455667788: Loads a full 64-bit hexadecimal value into RAX.

mov rbx, 0x1234: Loads 0x1234 into RBX. This value is automatically zero-extended to 64 bits (0x0000000000001234)

Saving Registers to the Stack

push rax: Decrements the stack pointer (RSP) by 8 bytes and stores 0x1122334455667788 at the new [RSP] location.

push rbx: Decrements RSP by another 8 bytes and stores 0x0000000000001234 on top of the stack.

nop: No Operation. This instruction consumes one CPU clock cycle without altering execution state or memory.

Restoring Registers from the Stack

pop rbx: Removes the top 8 bytes from the stack (0x0000000000001234), places the value back into RBX, and increments RSP by 8.

pop rax: Removes the next 8 bytes (0x1122334455667788), places the value back into RAX, and increments RSP by 8.

Program Exit

mov rax, 60: Loads 60 into RAX to prepare for the sys_exit system call, safely overwriting the restored 0x1122334455667788.

xor rdi, rdi: Sets RDI to 0 using XOR logic, establishing an exit code of 0 (success).

syscall: Calls the Linux kernel to terminate the program cleanly.