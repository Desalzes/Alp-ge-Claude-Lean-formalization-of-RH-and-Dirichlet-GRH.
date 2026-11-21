#!/usr/bin/env python3
"""Exact-arithmetic falsification tests for T02; no external dependencies."""
from itertools import product

# Over an integral domain, upper * special = y * lower,
# with y != 0 and lower != 0, forces both upper and special != 0.
tested = 0
for upper, special, y, lower in product(range(-5, 6), repeat=4):
    if y and lower and upper * special == y * lower:
        tested += 1
        assert upper != 0 and special != 0

# Each hypothesis matters; these are counterexamples to *weaker* statements.
drop_normalization = dict(upper=0, special=0, y=0, lower=1)
drop_bottom = dict(upper=1, special=0, y=1, lower=0)
zero_divisors = dict(upper=1, special=0, y=2, lower=3)

for example, modulus in ((drop_normalization, None), (drop_bottom, None), (zero_divisors, 6)):
    x = example["upper"] * example["special"]
    z = example["y"] * example["lower"]
    if modulus:
        x, z = x % modulus, z % modulus
    assert x == z == 0

assert drop_normalization["lower"] != 0 and drop_normalization["y"] == 0
assert drop_bottom["y"] != 0 and drop_bottom["lower"] == 0
assert zero_divisors["lower"] % 6 != 0 and zero_divisors["y"] % 6 != 0
assert zero_divisors["special"] == 0

print(f"PASS: {tested} satisfying integer tuples checked with no violations")
print("PASS: missing normalization, missing bottom, and Z/6 counterexamples")
