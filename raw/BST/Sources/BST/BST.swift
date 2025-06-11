import Foundation

public class Node {
    var right: Node?
    var left: Node?
    var parent: Node?
    var title: String

    init(_ title: String) {
        self.title = title
    }
}

public class Tree {
    var root: Node?

    public init() {}

    public func insert(title: String) {
        let newNode = Node(title)
        guard root != nil else {
            self.root = newNode
            return
        }
        var x: Node? = root  // node being compared with new node
        var y: Node?  // y will be parent of new node
        while let current = x {  // descend until leaf
            y = current
            if newNode.title < current.title {
                x = current.left
            } else {
                x = current.right
            }
        }
        newNode.parent = y  // found the location
        if let parent = y {
            if newNode.title < parent.title {
                parent.left = newNode
            } else {
                parent.right = newNode
            }
        }
    }

    public func search(title: String) -> Node? {
        return search(self.root, title)
    }

    func search(_ x: Node?, _ k: String) -> Node? {
        guard let key = x?.title else {
            return x
        }
        if k == key {
            return x
        }
        if k < key {
            return search(x?.left, k)
        }
        return search(x?.right, k)
    }

    /// Public-facing method
    public func minimum() -> Node? {
        guard let root = self.root else { return nil }
        return minimum(root)
    }

    /// Public-facing method
    public func maximum() -> Node? {
        guard let root = self.root else { return nil }
        return maximum(root)
    }

    /// Returns the node with the smallest title in the subtree rooted at `x`.
    func minimum(_ x: Node) -> Node {
        var y = x
        while let left = y.left {
            y = left
        }
        return y
    }

    /// Returns the node with the biggest title in the subtree rooted at `x`.
    func maximum(_ x: Node) -> Node {
        var y = x
        while let right = y.right {
            y = right
        }
        return y
    }

    public func successor(_ x: Node) -> Node? {
        if let right = x.right {
            return minimum(right)  // case 1: has right subtree
        }
        // case 2: does not, get up the tree until finding a node with a left child – the root of that node is what we need
        var node = x
        var parent = node.parent
        while let p = parent, node === p.right {
            node = p
            parent = p.parent
        }
        return parent
    }

    public func predecessor(_ x: Node) -> Node? {
        if let left = x.left {
            return maximum(left)
        }
        var node = x
        var parent = node.parent
        while let p = parent, node === p.left {
            node = p
            parent = p.parent
        }
        return parent
    }

    func transplant(_ u: Node, _ v: Node?) {
        if u.parent == nil {
            self.root = v
        } else if u === u.parent?.left {
            u.parent?.left = v
        } else {
            u.parent?.right = v
        }
        if let v = v {
            v.parent = u.parent
        }
    }

    public func delete(z: Node) {
        if z.left == nil {
            transplant(z, z.right)
        } else if z.right == nil {
            transplant(z, z.left)
        } else {
            let y = minimum(z.right!)  // Successor. The ! is ok thanks to the checks
            if y !== z.right {
                transplant(y, y.right)
                y.right = z.right
                y.right?.parent = y
            }
            transplant(z, y)
            y.left = z.left
            y.left?.parent = y
        }
    }

    public func printTree() {
        func inOrder(_ node: Node?) {
            guard let node = node else { return }
            inOrder(node.left)
            print(node.title)
            inOrder(node.right)
        }
        inOrder(self.root)
    }

    // Helper method for testing - returns in-order traversal as array
    public func getInOrderTraversal() -> [String] {
        var result: [String] = []
        func inOrder(_ node: Node?) {
            guard let node = node else { return }
            inOrder(node.left)
            result.append(node.title)
            inOrder(node.right)
        }
        inOrder(self.root)
        return result
    }
}
