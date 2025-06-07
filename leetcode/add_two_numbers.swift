// Definition for singly-linked list
public class ListNode {
    public var val: Int
    public var next: ListNode?

    public init() {
        self.val = 0
        self.next = nil
    }

    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }

    public init(_ val: Int, _ next: ListNode?) {
        self.val = val
        self.next = next
    }
}

class Solution {
    func addTwoNumbers(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        var node1 = l1
        var node2 = l2
        let dummy = ListNode.init()
        var current = dummy
        var carry: Int = 0

        while node1 != nil || node2 != nil || carry > 0 {
            let val1 = node1?.val ?? 0
            let val2 = node2?.val ?? 0

            let sum = val1 + val2 + carry
            carry = sum / 10
            let digit = sum % 10
            current.next = ListNode(digit)
            current = current.next!

            node1 = node1?.next
            node2 = node2?.next
        }
        return dummy.next
    }
}

// Helper function to create linked list from array
func createLinkedList(_ values: [Int]) -> ListNode? {
    guard !values.isEmpty else { return nil }

    let head = ListNode(values[0])
    var current = head

    for i in 1..<values.count {
        current.next = ListNode(values[i])
        current = current.next!
    }

    return head
}

// Helper function to print linked list
func printLinkedList(_ head: ListNode?) {
    var current = head
    var result: [String] = []

    while current != nil {
        result.append(String(current!.val))
        current = current!.next
    }

    print(result.joined(separator: " -> "))
}

// Test environment
let solution = Solution()

// Create test cases: 2->4->3 and 5->6->4
let l1 = createLinkedList([2, 4, 3])
let l2 = createLinkedList([5, 6, 4])

// Additional test case: 0 and 9->9->9
let l3 = createLinkedList([0])
let l4 = createLinkedList([9, 9, 9])

// Edge case: empty lists
let l5: ListNode? = nil
let l6 = createLinkedList([1])

print("Test Case 1:")
print("L1: ", terminator: "")
printLinkedList(l1)
print("L2: ", terminator: "")
printLinkedList(l2)

print("\nTest Case 2:")
print("L3: ", terminator: "")
printLinkedList(l3)
print("L4: ", terminator: "")
printLinkedList(l4)

print("\nTest Case 3:")
print("L5: ", terminator: "")
printLinkedList(l5)
print("L6: ", terminator: "")
printLinkedList(l6)

// Run your solution
let result1 = solution.addTwoNumbers(l1, l2)
let result2 = solution.addTwoNumbers(l3, l4)
let result3 = solution.addTwoNumbers(l5, l6)

print("\nResults:")
print("Result 1: ", terminator: "")
printLinkedList(result1)
print("Result 2: ", terminator: "")
printLinkedList(result2)
print("Result 3: ", terminator: "")
printLinkedList(result3)
