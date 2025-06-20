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
