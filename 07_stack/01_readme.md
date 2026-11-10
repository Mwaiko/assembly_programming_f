Loading Values

mov rax, 100: Stores 100 in register RAX.

mov rbx, 200: Stores 200 in register RBX.

Pushing to stack

push rax: Pushes 100 onto the top of the stack.

push rbx: Pushes 200 onto the stack .

nop: "No Operation" — padding byte that consumes one CPU cycle without changing registers or memory.

Popping Stack

pop rcx: Removes the top item (200) from the stack and stores it in RCX.

pop rdx: Removes the next item (100) from the stack and stores it in RDX.

nop: Another no-operation byte.

sys_exit

mov rax, 60: Loads 60 into RAX, which is the Linux system call number for sys_exit.

xor rdi, rdi: Sets RDI to 0 using XOR logic ,sets the exit status code to 0 

syscall: Hands control to the Linux kernel to terminate the process.