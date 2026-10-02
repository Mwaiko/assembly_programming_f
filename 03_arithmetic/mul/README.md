# MUL — CPU Flags

The `MUL` instruction affects **CF** and **OF**. The other arithmetic flags are **undefined**.

### `MUL` Byte — 25 × 10 = 250

The result is `250`, which fits completely inside the lower 8 bits (`AL`).

- **CF = 0 (cleared)** — the upper half of the result, `AH`, is `0`, meaning the result fits in 8 bits.
- **OF = 0 (cleared)** — the result does not require more than 8 bits.
- **ZF = Undefined** — `MUL` does not define the Zero Flag.
- **SF = Undefined** — `MUL` does not define the Sign Flag.
- **AF = Undefined** — `MUL` does not define the Auxiliary Carry Flag.
- **PF = Undefined** — `MUL` does not define the Parity Flag.

### `MUL` Word — 3000 × 200 = 600,000

The result requires more than 16 bits, so it is stored across `DX:AX`.

- **CF = 1 (set)** — `DX` is non-zero, meaning the result does not fit completely inside `AX`.
- **OF = 1 (set)** — the upper half of the result is non-zero, so the result requires more than 16 bits.
- **ZF = Undefined** — `MUL` does not define the Zero Flag.
- **SF = Undefined** — `MUL` does not define the Sign Flag.
- **AF = Undefined** — `MUL` does not define the Auxiliary Carry Flag.
- **PF = Undefined** — `MUL` does not define the Parity Flag.

### `MUL` Double Word — 100,000 × 300,000 = 30,000,000,000

The result requires more than 32 bits, so it is stored across `EDX:EAX`.

- **CF = 1 (set)** — `EDX` is non-zero, meaning the result does not fit completely inside `EAX`.
- **OF = 1 (set)** — the upper 32 bits of the result are non-zero, so the result requires more than 32 bits.
- **ZF = Undefined** — `MUL` does not define the Zero Flag.
- **SF = Undefined** — `MUL` does not define the Sign Flag.
- **AF = Undefined** — `MUL` does not define the Auxiliary Carry Flag.
- **PF = Undefined** — `MUL` does not define the Parity Flag.

### Summary

| Program | Result fits in lower register? | CF | OF |
|---|---|---|---|
| Byte: `25 × 10` | Yes | 0 | 0 |
| Word: `3000 × 200` | No | 1 | 1 |
| Double word: `100000 × 300000` | No | 1 | 1 |

For `MUL`, **CF and OF have the same status**:

- `0` → upper half of result is zero.
- `1` → upper half of result is non-zero.

The remaining flags are **undefined**, so their values shown by GDB should not be interpreted as being produced by `MUL`.