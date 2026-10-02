# SUB and SBB — CPU Flags

## 8-bit SUB — `50 - 80`

```text
50 - 80 = -30
```

Since this is unsigned subtraction, the result wraps around:

```text
AL = 0xE2
```

- **CF = 1 (set)** — `50` is smaller than `80`, so a borrow was required.
- **ZF = 0 (cleared)** — the result is not zero.
- **SF = 1 (set)** — the most significant bit of `0xE2` is `1`, indicating a negative result when interpreted as signed.
- **OF = 0 (cleared)** — both operands are positive, so signed overflow does not occur.
- **AF = 1 (set)** — a borrow occurs from the lower 4 bits.
- **PF = 1 (set)** — `0xE2` (`11100010`) contains four `1` bits, which is even parity.

---

## 16-bit SUB — `1000 - 2000`

```text
1000 - 2000 = -1000
```

The 16-bit result wraps around:

```text
AX = 0xFC18
```

- **CF = 1 (set)** — `1000` is smaller than `2000`, so a borrow was required.
- **ZF = 0 (cleared)** — the result is not zero.
- **SF = 1 (set)** — the most significant bit of `0xFC18` is `1`, indicating a negative signed result.
- **OF = 0 (cleared)** — both operands are positive, so there is no signed overflow.
- **AF = 0 (cleared)** — no borrow occurs between bit 3 and bit 4.
- **PF = 1 (set)** — the low byte `0x18` (`00011000`) contains two `1` bits, giving even parity.

---

## SBB — `0 - 1 - CF`

First:

```text
0 - 1 = 0xFFFF
```

This requires a borrow, therefore:

```text
CF = 1
```

Then:

```text
SBB AX, 0
```

performs:

```text
0xFFFF - 0 - 1 = 0xFFFE
```

- **CF = 0 (cleared)** — `0xFFFF - 1` does not require another borrow.
- **ZF = 0 (cleared)** — the final result `0xFFFE` is not zero.
- **SF = 1 (set)** — the most significant bit of `0xFFFE` is `1`.
- **OF = 0 (cleared)** — the subtraction does not produce signed overflow.
- **AF = 0 (cleared)** — no borrow occurs from bit 4 during the final subtraction.
- **PF = 0 (cleared)** — the low byte `0xFE` (`11111110`) contains seven `1` bits, giving odd parity.

