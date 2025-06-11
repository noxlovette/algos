import Foundation

// Simple demo of the BST functionality
let tree = Tree()

// Insert test values
let values = ["M", "B", "Q", "A", "C", "O", "Z"]
print("Inserting values: \(values.joined(separator: ", "))")

for val in values {
    tree.insert(title: val)
}

print("\nIn-order traversal after inserts:")
tree.printTree()

print("\n" + String(repeating: "-", count: 30))

// Search demonstrations
print("Searching for 'C':")
if let found = tree.search(title: "C") {
    print("✓ Found node: '\(found.title)'")
} else {
    print("✗ Node 'C' not found")
}

print("Searching for 'X':")
if let found = tree.search(title: "X") {
    print("✓ Found node: '\(found.title)'")
} else {
    print("✗ Node 'X' not found")
}

print("\n" + String(repeating: "-", count: 30))

// Delete demonstration
print("Deleting node 'B'...")
if let nodeToDelete = tree.search(title: "B") {
    tree.delete(z: nodeToDelete)
    print("✓ Deleted node 'B'")
} else {
    print("✗ Node 'B' not found for deletion")
}

print("\nIn-order traversal after deleting 'B':")
tree.printTree()

// Additional demonstrations
print("\n" + String(repeating: "-", count: 30))
print("Tree operations:")

if let min = tree.minimum() {
    print("Minimum value: '\(min.title)'")
}

if let max = tree.maximum() {
    print("Maximum value: '\(max.title)'")
}

if let nodeM = tree.search(title: "M") {
    if let successor = tree.successor(nodeM) {
        print("Successor of 'M': '\(successor.title)'")
    }
    if let predecessor = tree.predecessor(nodeM) {
        print("Predecessor of 'M': '\(predecessor.title)'")
    }
}
