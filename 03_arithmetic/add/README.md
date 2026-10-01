
Exercise 1 8-bit ADD


Flags after add al, [num2]:

Flag                    Status                  Why

CF                      0                       No carry out of the
8-bit range; 120 + 10 =
130 < 256.

ZF                      0                       Result is 10000010,
not zero.

SF                      1                       The most significant bit
of the 8-bit result is
1.

OF                      1                       Signed 8-bit range is
-128 to +127; +120 + +10
= +130 is not
representable, so the
sign becomes negative.

AF                      1                       Lower nibbles:
1000 + 1010 = 10010,
producing a carry from
bit 3 to bit 4.

Final:

CF=0  ZF=0  SF=1  OF=1  AF=1  PF=1

Exercise 2 --- 16-bit ADD

Values:

32000 = 0x7D00
500   = 0x01F4

Results = 32500

Flags after add ax, [num2]:

Flag                    Status                  Why

CF                      0                       32500 is below 65536,
so there is no carry
out of bit 15.

ZF                      0                       The result is 32500,
not zero.

SF                      0                       Bit 15 of
0111111011110100 is
0.

OF                      0                       Signed 16-bit range is
-32768 to +32767; 32500
is representable and
positive.

AF                      0                       Low nibbles are
0000 + 0100; there is
no carry from bit 3 to
bit 4.

Final:

CF=0  ZF=0  SF=0  OF=0  AF=0  PF=0

Exercise 3 --- 16-bit ADD followed by ADC

Flags immediately after ADD:

Flag                    Status                  Why

CF                      1                       0xFFFF + 1 = 0x10000;
the extra 17th bit is a
carry out of bit 15.

ZF                      1                       The 16-bit result stored
in AX is zero.

SF                      0                       The MSB of
0000000000000000 is 0.

OF                      0                       As signed values,
0xFFFF = -1;
-1 + 1 = 0, which is
representable.

AF                      1                       Lower nibble:
1111 + 0001 = 1 0000; a
carry occurs from bit 3
to bit 4.

Final after ADD:

CF=1  ZF=1  SF=0  OF=0  AF=1  PF=1

3B --- ADC

ADC means Add with Carry:

ADC AX, 0

means:

AX = AX + 0 + CF

At this point:

AX = 0
CF = 1

Therefore:

0 + 0 + 1 = 1

New AX:

AX = 0x0001

Flags immediately after ADC:

Flag                    Status                  Why

CF                      0                       0 + 0 + 1 = 1; there is no
carry out of bit 15.

ZF                      0                       Result is 1, not zero.

SF                      0                       MSB of the 16-bit result is 0.

OF                      0                       +1 is safely inside the signed
16-bit range.

AF                      0                       0000 + 0000 + 0001 = 0001;
no carry from bit 3 to bit 4.

Final after ADC:

CF=0  ZF=0  SF=0  OF=0  AF=0  PF=0

Combined Answer

Exercise   Operation              Result       CF   ZF   SF   OF   AF   PF

1          8-bit 120 + 10       0x82        0    0    1    1    1    1
2          16-bit 32000 + 500   0x7EF4      0    0    0    0    0    0
3A         16-bit 0xFFFF + 1    0x0000      1    1    0    0    1    1
3B         16-bit 0 + 0 + CF    0x0001      0    0    0    0    0    0
