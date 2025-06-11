/// Directed, Unweighed, Directed
/// Sparse, Dynamic

/// It's a node
class User: Hashable {
    var id: String
    var name: String
    var contacts: [User] = []

    init(id: String, name: String) {
        self.id = id
        self.name = name
    }

    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }
}

class Graph {
    private(set) var users: [String: User] = [:]

    func addUser(_ user: User) {
        if users[user.id] == nil {
            users[user.id] = user
        }
    }
    func connect(from: User, to: User) {
        guard users[from.id] != nil, users[to.id] != nil else {
            print("One or both not found in graph")
            return
        }
        if !from.contacts.contains(where: { $0.id == to.id }) {
            from.contacts.append(to)
        }

    }
    func getNeighbours(of user: User) -> [User] {
        return user.contacts
    }

    func getUser(by id: String) -> User? {
        guard let user = self.users[id] else {
            print("user not found")
            return nil
        }
        return user
    }

    /// The iterative version of the algo
    func bfs(start: User, target: User) -> Bool {
        var visited = Set<User>()
        var queue: [User] = []
        queue.append(start)
        while !queue.isEmpty {
            let current = queue.removeFirst()

            if current == target {
                return true
            }

            if visited.contains(current) {
                continue
            }

            visited.insert(current)
            for neighbour in current.contacts {
                queue.append(neighbour)
            }

        }
        return false
    }
}

func testBFS() {
    let graph = Graph()

    let alice = User(id: "1", name: "Alice")
    let bob = User(id: "2", name: "Bob")
    let carol = User(id: "3", name: "Carol")
    let dave = User(id: "4", name: "Dave")
    let eve = User(id: "5", name: "Eve")

    // Add users to graph
    graph.addUser(alice)
    graph.addUser(bob)
    graph.addUser(carol)
    graph.addUser(dave)
    graph.addUser(eve)

    // Connect users (directed edges)
    graph.connect(from: alice, to: bob)
    graph.connect(from: bob, to: carol)
    graph.connect(from: carol, to: dave)
    // Note: no connection to Eve, isolated

    // Test BFS
    let pathExists = graph.bfs(start: alice, target: dave)
    print("Path from Alice to Dave: \(pathExists ? "YES" : "NO")")

    let pathToEve = graph.bfs(start: alice, target: eve)
    print("Path from Alice to Eve: \(pathToEve ? "YES" : "NO")")
}

testBFS()
