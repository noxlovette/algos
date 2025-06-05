# Heap Data Structures Problem Set

This problem set covers implementation of various heap-based data structures. Each problem builds upon previous concepts and introduces new challenges in heap manipulation and maintenance.

## Table of Contents
1. [Problem 1: Complete MinHeap Implementation](#problem-1-complete-minheap-implementation)
2. [Problem 2: TopKHeap Data Structure](#problem-2-topkheap-data-structure)
3. [Problem 3: Complete MaxHeap Implementation](#problem-3-complete-maxheap-implementation)
4. [Problem 4: MedianMaintainingHeap](#problem-4-medianmaintainingheap)

---

## Problem 1: Complete MinHeap Implementation

Complete the missing parts of the MinHeap data structure below.

```python
class MinHeap:
    def __init__(self):
        self.H = [None]
 
    def size(self):
        return len(self.H)-1
    
    def __repr__(self):
        return str(self.H[1:])
        
    def satisfies_assertions(self):
        for i in range(2, len(self.H)):
            assert self.H[i] >= self.H[i//2],  f'Min heap property fails at position {i//2}, parent elt: {self.H[i//2]}, child elt: {self.H[i]}'
    
    def min_element(self):
        return self.H[1]
    
    ## bubble_up function at index
    ## WARNING: this function has been cut and paste for the next problem as well 
    def bubble_up(self, index):
        assert index >= 1
        if index == 1: 
            return 
        parent_index = index // 2
        if self.H[parent_index] < self.H[index]:
            return 
        else:
            self.H[parent_index], self.H[index] = self.H[index], self.H[parent_index]
            self.bubble_up(parent_index)
    
    ## bubble_down function at index
    ## WARNING: this function has been cut and paste for the next problem as well 
    def bubble_down(self, index):
        assert index >= 1 and index < len(self.H)
        lchild_index = 2 * index
        rchild_index = 2 * index + 1
        # set up the value of left child to the element at that index if valid, or else make it +Infinity
        lchild_value = self.H[lchild_index] if lchild_index < len(self.H) else float('inf')
        # set up the value of right child to the element at that index if valid, or else make it +Infinity
        rchild_value = self.H[rchild_index] if rchild_index < len(self.H) else float('inf')
        # If the value at the index is lessthan or equal to the minimum of two children, then nothing else to do
        if self.H[index] <= min(lchild_value, rchild_value):
            return 
        # Otherwise, find the index and value of the smaller of the two children.
        # A useful python trick is to compare 
        min_child_value, min_child_index = min ((lchild_value, lchild_index), (rchild_value, rchild_index))
        # Swap the current index with the least of its two children
        self.H[index], self.H[min_child_index] = self.H[min_child_index], self.H[index]
        # Bubble down on the minimum child index
        self.bubble_down(min_child_index)
        
    # Function: heap_insert
    # Insert elt into heap
    # Use bubble_up/bubble_down function
    def insert(self, elt):
        # your code here
        
    # Function: heap_delete_min
    # delete the smallest element in the heap. Use bubble_up/bubble_down
    def delete_min(self):
        # your code here
```

**Requirements:**
- Complete the `insert(self, elt)` method
- Complete the `delete_min(self)` method
- Use the provided `bubble_up` and `bubble_down` helper functions
- Maintain the min-heap property at all times

---

## Problem 2: TopKHeap Data Structure

Implement a data structure that efficiently maintains the k smallest elements. Complete the missing methods in the TopKHeap class.

```python
class TopKHeap:
    
    # The constructor of the class to initialize an empty data structure
    def __init__(self, k):
        self.k = k
        self.A = []
        self.H = MinHeap()
        
    def size(self): 
        return len(self.A) + (self.H.size())
    
    def get_jth_element(self, j):
        assert 0 <= j < self.k-1
        assert j < self.size()
        return self.A[j]
    
    def satisfies_assertions(self):
        # is self.A sorted
        for i in range(len(self.A) -1 ):
            assert self.A[i] <= self.A[i+1], f'Array A fails to be sorted at position {i}, {self.A[i], self.A[i+1]}'
        # is self.H a heap (check min-heap property)
        self.H.satisfies_assertions()
        # is every element of self.A less than or equal to each element of self.H
        for i in range(len(self.A)):
            assert self.A[i] <= self.H.min_element(), f'Array element A[{i}] = {self.A[i]} is larger than min heap element {self.H.min_element()}'
        
    # Function : insert_into_A
    # This is a helper function that inserts an element `elt` into `self.A`.
    # whenever size is < k,
    #       append elt to the end of the array A
    # Move the element that you just added at the very end of 
    # array A out into its proper place so that the array A is sorted.
    # return the "displaced last element" jHat (None if no element was displaced)
    def insert_into_A(self, elt):
        print("k = ", self.k)
        assert(self.size() < self.k)
        self.A.append(elt)
        j = len(self.A)-1
        while (j >= 1 and self.A[j] < self.A[j-1]):
            # Swap A[j] and A[j-1]
            (self.A[j], self.A[j-1]) = (self.A[j-1], self.A[j])
            j = j -1 
        return
    
    # Function: insert -- insert an element into the data structure.
    # Code to handle when self.size < self.k is already provided
    def insert(self, elt):
        size = self.size()
        # If we have fewer than k elements, handle that in a special manner
        if size <= self.k:
            self.insert_into_A(elt)
            return 
        # Code up your algorithm here.
        # your code here
        
    # Function: Delete top k -- delete an element from the array A
    # In particular delete the j^{th} element where j = 0 means the least element.
    # j must be in range 0 to self.k-1
    def delete_top_k(self, j):
        k = self.k
        assert self.size() > k # we need not handle the case when size is less than or equal to k
        assert j >= 0
        assert j < self.k
        # your code here
```

**Requirements:**
- Complete the `insert(self, elt)` method for when `size >= k`
- Complete the `delete_top_k(self, j)` method
- Maintain invariants: `self.A` is sorted and contains k smallest elements
- All elements in `self.A` must be ≤ all elements in `self.H`

---

## Problem 3: Complete MaxHeap Implementation

Complete the implementation for the MaxHeap data structure. You can adapt the logic from the MinHeap implementation, but remember to reverse the comparison operations.

```python
class MaxHeap:
    def __init__(self):
        self.H = [None]
        
    def size(self):
        return len(self.H)-1
    
    def __repr__(self):
        return str(self.H[1:])
        
    def satisfies_assertions(self):
        for i in range(2, len(self.H)):
            assert self.H[i] <= self.H[i//2],  f'Maxheap property fails at position {i//2}, parent elt: {self.H[i//2]}, child elt: {self.H[i]}'
    
    def max_element(self):
        return self.H[1]
    
    def bubble_up(self, index):
        # your code here
        
    def bubble_down(self, index):
        # your code here
        
    # Function: insert
    # Insert elt into maxheap
    # Use bubble_up/bubble_down function
    def insert(self, elt):
        # your code here
        
    # Function: delete_max
    # delete the largest element in the heap. Use bubble_up/bubble_down
    def delete_max(self):
        # your code here
```

**Requirements:**
- Complete all missing methods: `bubble_up`, `bubble_down`, `insert`, `delete_max`
- Maintain the max-heap property (parent ≥ children)
- Use similar logic to MinHeap but with reversed comparisons

**Note:** A better design would have been to write a single implementation that could serve as min/max heap based on a flag, but for this exercise, implement them separately.

---

## Problem 4: MedianMaintainingHeap

Implement a data structure that efficiently maintains the median of a dynamic set of numbers using two heaps.

```python
class MedianMaintainingHeap:
    def __init__(self):
        self.hmin = MinHeap()
        self.hmax = MaxHeap()
        
    def satisfies_assertions(self):
        if self.hmin.size() == 0:
            assert self.hmax.size() == 0
            return 
        if self.hmax.size() == 0:
            assert self.hmin.size() == 1
            return 
        # 1. min heap min element >= max heap max element
        assert self.hmax.max_element() <= self.hmin.min_element(), f'Failed: Max element of max heap = {self.hmax.max_element()} > min element of min heap {self.hmin.min_element()}'
        # 2. size of max heap must be equal or one lessthan min heap.
        s_min = self.hmin.size()
        s_max = self.hmax.size()
        assert (s_min == s_max or s_max  == s_min -1 ), f'Heap sizes are unbalanced. Min heap size = {s_min} and Maxheap size = {s_max}'
    
    def __repr__(self):
        return 'Maxheap:' + str(self.hmax) + ' Minheap:'+str(self.hmin)
    
    def get_median(self):
        if self.hmin.size() == 0:
            assert self.hmax.size() == 0, 'Sizes are not balanced'
            assert False, 'Cannot ask for median from empty heaps'
        if self.hmax.size() == 0:
            assert self.hmin.size() == 1, 'Sizes are not balanced'
            return self.hmin.min_element()
        # your code here
        
    # function: balance_heap_sizes
    # ensure that the size of hmax == size of hmin or size of hmax +1 == size of hmin
    # If the condition above does not hold, move the max element from max heap into the min heap or
    # vice versa as needed to balance the sizes.
    # This function could be called from insert/delete_median methods
    def balance_heap_sizes(self):
        # your code here
        
    def insert(self, elt):
        # Handle the case when either heap is empty
        if self.hmin.size() == 0:
            # min heap is empty -- directly insert into min heap
            self.hmin.insert(elt)
            return 
        if self.hmax.size() == 0:
            # max heap is empty -- this better happen only if min heap has size 1.
            assert self.hmin.size() == 1
            if elt > self.hmin.min_element():
                # Element needs to go into the min heap
                current_min = self.hmin.min_element()
                self.hmin.delete_min()
                self.hmin.insert(elt)
                self.hmax.insert(current_min)
                # done!
            else:
                # Element goes into the max heap -- just insert it there.
                self.hmax.insert(elt)
            return 
        # Now assume both heaps are non-empty
        # your code here
        
    def delete_median(self):
        self.hmax.delete_max()
        self.balance_heap_sizes()
```

**Requirements:**
- Complete the `get_median(self)` method
- Complete the `balance_heap_sizes(self)` method  
- Complete the `insert(self, elt)` method for when both heaps are non-empty
- Fix the `delete_median(self)` method (current implementation may be incorrect)
- Maintain invariants:
  - All elements in `hmax` ≤ all elements in `hmin`
  - Size difference between heaps is at most 1
  - `hmax` contains smaller half, `hmin` contains larger half

**Data Structure Design:**
- `hmax` (MaxHeap): Contains the smaller half of all elements
- `hmin` (MinHeap): Contains the larger half of all elements
- Median is either the root of one heap (odd total elements) or average of both roots (even total elements)

---

## Testing Guidelines

For each implementation:
1. Test with small datasets first
2. Verify that all assertions pass after each operation
3. Test edge cases (empty heaps, single elements, etc.)
4. Measure performance for larger datasets
5. Verify correctness by comparing with naive implementations

## Complexity Requirements

- **MinHeap/MaxHeap**: Insert and delete operations should be O(log n)
- **TopKHeap**: Operations should be O(k + log n) where n is total elements
- **MedianMaintainingHeap**: Insert and delete should be O(log n), get_median should be O(1)
