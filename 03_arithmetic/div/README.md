# DIV — CPU Flags

The `DIV` instruction does **not define the status of the arithmetic flags**.

Therefore, after each division:

- **CF (Carry Flag): Undefined** — `DIV` does not use the carry flag to indicate anything about the quotient or remainder.
- **ZF (Zero Flag): Undefined** — even if the remainder or quotient is zero, `DIV` does not set `ZF`.
- **SF (Sign Flag): Undefined** — `DIV` performs unsigned division, so it does not use `SF` to represent the sign of the result.
- **OF (Overflow Flag): Undefined** — `DIV` does not use `OF` to indicate whether the quotient overflowed. If the quotient cannot fit in the destination register, a division error occurs instead.
- **AF (Auxiliary Carry Flag): Undefined** — `DIV` does not define this flag.
- **PF (Parity Flag): Undefined** — `DIV` does not define this flag based on the quotient or remainder.

### Conclusion

For all three programs:

```text
CF = Undefined
ZF = Undefined
SF = Undefined
OF = Undefined
AF = Undefined
PF = Undefined
```

The values displayed by GDB for these flags should **not be interpreted as being caused by the `DIV` operation**. Their values are undefined after `DIV`.

The important results of `DIV` are the **quotient and remainder**, not the CPU flags.