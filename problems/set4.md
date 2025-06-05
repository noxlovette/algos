```markdown
# Assignment 4: Hashing and Partitioning

## Problem 1: Debugging a Faulty Partition Algorithm

You are given a faulty implementation of the Lomuto partitioning algorithm. The code aims to maintain the following invariants:

- `a[0] .. a[i]` are `<= pivot`
- `a[i+1]...a[j-1]` are `> pivot`

The current implementation:

```python
def swap(a, i, j):
    assert 0 <= i < len(a), f'accessing index {i} beyond end of array {len(a)}'
    assert 0 <= j < len(a), f'accessing index {j} beyond end of array {len(a)}'
    a[i], a[j] = a[j], a[i]

def tryPartition(a):
    n = len(a)
    pivot = a[n-1]
    i, j = 0, 0
    for j in range(n-1):
        if a[j] <= pivot:
            swap(a, i+1, j)
            i += 1
    swap(a, i+1, n-1)
    return i+1
```

### Your Task

1. Write **three different test arrays**: `a1`, `a2`, and `a3` such that `tryPartition` fails due to:
   - Out-of-bounds array access
   - Incorrect partitioning (violated invariants)

```python
# Example structure to fill in
a1 = [...]  # should break tryPartition
a2 = [...]  # different from a1
a3 = [...]  # different from both a1 and a2

assert len(a1) > 0
assert len(a2) > 0 and a2 != a1
assert len(a3) > 0 and a3 != a1 and a3 != a2
```

2. Implement this function to verify partitioning correctness:

```python
def testIfPartitioned(a, k):
    assert 0 <= k < len(a)
    pivot = a[k]
    return all(a[i] <= pivot for i in range(k)) and all(a[i] > pivot for i in range(k+1, len(a)))
```

---

## Problem 2: Fast Sorting of Bounded Integers

You are given an array `a` of size `n` where each element lies between `1` and `k`. Design a sorting algorithm that runs in **Θ(n × k)** time using partitioning.

### Provided Code Framework

```python
def swap(a, i, j):
    assert 0 <= i < len(a)
    assert 0 <= j < len(a)
    a[i], a[j] = a[j], a[i]

def simplePartition(a, pivot):
    # Partition array into <= pivot and > pivot
    # Maintain order of elements <= pivot
    i = 0
    for j in range(len(a)):
        if a[j] <= pivot:
            swap(a, i, j)
            i += 1

def boundedSort(a, k):
    for j in range(1, k):
        simplePartition(a, j)
```

### Example Test Case

```python
a = [1, 3, 6, 1, 5, 4, 1, 1, 2, 3, 3, 1, 3, 5, 2, 2, 4]
simplePartition(a, 1)
# a[:5] should be all 1s
simplePartition(a, 2)
# a[5:8] should be all 2s
# ...
```

---

## Problem 3: Hashing via Boolean Matrix Multiplication

You are given a hash family using **boolean matrix-vector multiplication**. Each key is represented as an `n`-bit vector, and the hash is computed using an `m × n` matrix `H`.

### Boolean Multiplication

- Multiplication: AND
- Addition: XOR

### Example

Given:
```text
H = [
 [0, 1, 0, 1],
 [1, 0, 0, 0],
 [1, 0, 1, 1]
]
```

And key `14 = (1, 1, 1, 0)` (in binary), the hash is:

```
Hx = [
 0·1 ⊕ 1·1 ⊕ 0·1 ⊕ 1·0 = 1,
 1·1 ⊕ 0·1 ⊕ 0·1 ⊕ 0·0 = 1,
 1·1 ⊕ 0·1 ⊕ 1·1 ⊕ 1·0 = 0
] = [1, 1, 0]
```

---

### Part (A): When Does `Hx == Hy`?

Let `x` and `y` be binary vectors that differ **only** at bit `i`. Then:

> `Hx = Hy` **iff** column `i` of `H` is the **zero vector**

---

### Part (B): Code Implementation

#### Matrix Multiplication in GF(2)

```python
def dot_product(lst_a, lst_b):
    and_list = [a * b for a, b in zip(lst_a, lst_b)]
    return sum(and_list) % 2

def matrix_multiplication(H, lst):
    return [dot_product(row, lst) for row in H]
```

#### Random Hash Function Generator

```python
from random import random

def return_random_hash_function(m, n):
    return [[1 if random() >= 0.5 else 0 for _ in range(n)] for _ in range(m)]
```

---

## End of Assignment
Please test thoroughly and ensure your test cases validate both correctness and failure scenarios as required.
```

