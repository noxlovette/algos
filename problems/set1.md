### 🧩 **Problem 1: Finding the Crossover Point**

> You’re given two lists of increasing numbers: `x = [x₀, x₁, ..., xₙ]` and `y = [y₀, y₁, ..., yₙ]`, where `x[i] < x[i+1]` and `y[i] < y[i+1]` for all `i`.
>
> You also know:
>
> - At the beginning: `y₀ < x₀`
> - At the end: `yₙ > xₙ`
>
> Somewhere in the middle, the `y` values “catch up and overtake” the `x` values.
>
> Your task: **Write a recursive function that finds an index `i` such that `y[i] <= x[i]` but `y[i+1] > x[i+1]`.**

---

### 🧠 **Problem 2: Integer Cube Root**

> Given a positive integer `n`, find the **largest integer `i`** such that `i³ ≤ n` and `(i+1)³ > n`.
>
> This is the “floor” of the cube root.
>
> Implement a **recursive binary search** helper function to find this value within a given range `[left, right]`, assuming:
>
> - `left³ < n`
> - `right³ > n`

---

### 🔀 **Problem 3: Merging Multiple Sorted Lists**

> Suppose you’re given several sorted lists (all increasing). Your goal is to **merge them all into one sorted list**.
>
> Do this by:
>
> - Repeatedly merging pairs of lists using a helper function (like the classic merge step in merge sort).
> - If there’s an odd list left over, carry it to the next round as-is.
> - Keep merging in rounds until there’s only one sorted list left.
