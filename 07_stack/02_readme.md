Function Prologue & Allocation (work)

push rbp: Saves the old caller RBP onto the stack.

mov rbp, rsp: Copies current RSP into RBP. RBP now acts as the fixed reference point for this function's stack frame.

sub rsp, 16: Moves RSP down by 16 bytes, allocating room for two 64-bit (8-byte) variables.

Writing & Reading Local Memory

mov qword [rbp - 8], 100: Writes 100 into the memory reserved at [RBP - 8].

mov qword [rbp - 16], 200: Writes 200 into the memory reserved at [RBP - 16].

mov rax, [rbp - 8]: Loads 100 from stack memory into RAX.

mov rbx, [rbp - 16]: Loads 200 from stack memory into RBX.

Function Epilogue & Return

mov rsp, rbp: Resets RSP back to RBP, discarding the 16 bytes of local stack storage.

pop rbp: Restores the caller's original RBP.

ret: Pops the saved return address off the stack into RIP, returning control back to _start.

Exit

mov rax, 60: Sets system call number to 60 (sys_exit).

xor rdi, rdi: Sets status code to 0.

syscall: Terminates the program cleanly