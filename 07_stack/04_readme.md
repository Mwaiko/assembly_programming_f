_start Execution & Call

call work: Pushes the 4-byte return address onto the stack ESP decreases by 4 and jumps to work.

Function Prologue & Stack Allocation (work)

push ebp: Saves the caller's 32-bit base pointer on the stack ,ESP decreases by 4.

mov ebp, esp: Copies ESP into EBP, establishing the base pointer for this stack frame.

sub esp, 8: Subtracts 8 bytes from ESP, creating space for two 32-bit local variables.

Accessing Local Variables

mov dword [ebp - 4], 100: Writes 100 into memory at [EBP - 4].

mov dword [ebp - 8], 200: Writes 200 into memory at [EBP - 8].

mov eax, [ebp - 4]: Loads 100 into EAX.

mov ebx, [ebp - 8]: Loads 200 into EBX.

Function Epilogue & Return

mov esp, ebp: Restores ESP to EBP, deallocating the 8 bytes of stack space.

pop ebp: Restores the caller's base pointer.

ret: Pops the 4-byte return address into EIP to resume execution after call work.

32-Bit Linux Exit Sequence

mov eax, 1: Sets EAX to system call number 1 sys_exit.

xor ebx, ebx: Sets exit status code EBX to 0 success.

int 0x80: Triggers software interrupt 0x80 to transfer control to the kernel.
