Initialization (_start)

mov rax, 10: Loads 10 into RAX. Here, RAX acts as the input parameter for calculate.

Function Call (call calculate)
Under the hood, the call instruction performs two actions:

Pushes the memory address of the next instruction (after_call) onto the stack (subtracting 8 bytes from RSP).

Jumps to the calculate label by updating the Instruction Pointer (RIP).

Function Logic & Return (calculate)

add rax, 5: Adds 5 to RAX. RAX now holds 15 (serving as the function's return value).

ret: Performs the reverse of call:

Pops the saved return address (after_call) off the stack into RIP (adding 8 bytes back to RSP).

Control jumps back to execution right after the call.

Post-Call & Program Exit (after_call)

nop: No Operation. Execution arrives here with RAX equal to 15.

mov rax, 60: Overwrites RAX with 60 sys_exit system call number.

xor rdi, rdi: Sets RDI to 0 ,exit code 0.

syscall: Invokes the kernel to exit the program cleanly.