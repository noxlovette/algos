import Foundation  // For UUID and arc4random_uniform (or just use Swift's built-in Int.random(in:))

// MARK: - City Class
/// Represents a city (node) in the graph.
/// Conforms to Hashable and Equatable for use in collections like Dictionaries and Sets.
class City {
    let name: String  // The name of the city
    let id: String  // A unique identifier for the city

    /// Initializes a new City instance.
    /// - Parameters:
    ///   - id: A unique string identifier for the city.
    ///   - name: The human-readable name of the city.
    init(id: String, name: String) {
        self.name = name
        self.id = id
    }

    /// Conformance to Equatable. Cities are considered equal if their IDs match.
    static func == (lhs: City, rhs: City) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - City Extension: Hashable
extension City: Hashable {
    /// Conformance to Hashable. Uses the city's ID for hashing.
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Road Struct
/// Represents a road (edge) connecting two cities in the graph.
/// Conforms to Comparable to allow sorting by weight, essential for Kruskal's.
struct Road: Comparable {
    let from: City  // The starting city of the road
    let to: City  // The ending city of the road
    let weight: Int  // The cost or distance of the road

    /// Initializes a new Road instance.
    /// - Parameters:
    ///   - from: The City where the road originates.
    ///   - to: The City where the road ends.
    ///   - weight: The integer weight (cost) of the road.
    init(from: City, to: City, weight: Int) {
        self.from = from
        self.to = to
        self.weight = weight
    }

    /// Conformance to Comparable. Roads are compared based on their weight.
    static func < (lhs: Road, rhs: Road) -> Bool {
        return lhs.weight < rhs.weight
    }

    /// Conformance to Equatable. Roads are considered equal if they connect the same two cities
    /// (regardless of `from`/`to` order) and have the same weight. This handles undirected edges.
    static func == (lhs: Road, rhs: Road) -> Bool {
        return (lhs.from == rhs.from && lhs.to == rhs.to && lhs.weight == rhs.weight)
            || (lhs.from == rhs.to && lhs.to == rhs.from && lhs.weight == rhs.weight)
    }
}

// MARK: - DisjointSet Class
/// Implements the Disjoint Set Union (DSU) data structure with path compression and union by rank.
/// Used to efficiently track connected components and detect cycles in Kruskal's algorithm.
class DisjointSet {
    // Maps a city's ID to its parent city's ID.
    // The root of a set will point to its own ID.
    private var parent: [String: String] = [:]

    // Maps a city's ID to its rank (used for union by rank optimization).
    // Rank helps keep the trees balanced (shallow) for faster operations.
    private var rank: [String: Int] = [:]

    /// Initializes the Disjoint Set with a list of cities.
    /// Each city starts in its own set (its parent is itself, and rank is 0).
    /// - Parameter cities: An array of City objects to initialize the sets with.
    init(cities: [City]) {
        for city in cities {
            parent[city.id] = city.id  // Each city is initially its own parent (its own set)
            rank[city.id] = 0  // Initial rank is 0
        }
    }

    /// The 'find' operation with path compression.
    /// Finds the representative (root) of the set containing the given city ID.
    /// - Parameter elementID: The ID of the city to find the representative for.
    /// - Returns: The ID of the representative (root) of the set.
    func find(_ elementID: String) -> String {
        // Ensure the element exists in our parent map
        guard parent[elementID] != nil else {
            fatalError("Element \(elementID) not found in DisjointSet.")
        }

        // If the element is its own parent, it's the root of the set
        if parent[elementID] == elementID {
            return elementID
        }

        // Path compression: set the element's parent directly to the root
        // This flattens the tree, making future find operations faster for elements in this path.
        let root = find(parent[elementID]!)
        parent[elementID] = root
        return root
    }

    /// The 'union' operation with union by rank optimization.
    /// Merges the sets containing elementA and elementB.
    /// - Parameters:
    ///   - elementA_ID: The ID of the first city.
    ///   - elementB_ID: The ID of the second city.
    /// - Returns: True if a union occurred (i.e., they were in different sets),
    ///            false if they were already in the same set (would form a cycle).
    @discardableResult  // Suppress warning if return value is not used
    func union(_ elementA_ID: String, _ elementB_ID: String) -> Bool {
        let rootA = find(elementA_ID)
        let rootB = find(elementB_ID)

        // If the roots are different, the elements are in different sets, so merge them.
        if rootA != rootB {
            // Union by rank: attach the smaller rank tree under the root of the larger rank tree.
            // This helps keep the overall tree structure shallow and balanced.
            if rank[rootA]! < rank[rootB]! {
                parent[rootA] = rootB
            } else if rank[rootB]! < rank[rootA]! {
                parent[rootB] = rootA
            } else {
                // Ranks are equal, choose one as the new root (e.g., rootA) and increment its rank.
                parent[rootB] = rootA
                rank[rootA]! += 1
            }
            return true  // Union successfully occurred
        }
        return false  // Elements were already in the same set (adding this edge would form a cycle)
    }

    /// Prints the current state of the Disjoint Set (parent relationships).
    /// Useful for visualizing connected components.
    func printState(allCityIDs: [String]) {
        var output = "DSU State:\n"
        for cityID in allCityIDs.sorted() {  // Sort for consistent output
            let rootID = find(cityID)
            output +=
                "  \(cityID.prefix(4)) -> Root: \(rootID.prefix(4)) (Parent: \(parent[cityID]!.prefix(4)))\n"
        }
        print(output)
    }
}

// MARK: - Map Class
/// Represents the graph containing cities and roads.
/// Contains the implementation of Kruskal's algorithm to find the Minimum Spanning Tree.
class Map {
    private(set) var cities: [String: City] = [:]  // Stores cities by their ID
    private(set) var varRoads: [Road] = []  // Stores all possible roads in the map

    /// Adds a city to the map.
    /// - Parameter city: The City object to add.
    func addCity(_ city: City) {
        cities[city.id] = city
    }

    /// Adds a road connecting two existing cities in the map.
    /// - Parameters:
    ///   - fromCity: The starting city of the road.
    ///   - toCity: The ending city of the road.
    ///   - weight: The weight (cost) of the road.
    func addRoad(from fromCity: City, to toCity: City, weight: Int) {
        // Ensure both cities exist in our map before adding the road
        guard cities[fromCity.id] != nil, cities[toCity.id] != nil else {
            print("Error: One or both cities for the road do not exist in the map.")
            return
        }
        let road = Road(from: fromCity, to: toCity, weight: weight)
        varRoads.append(road)
    }

    /// Implements Kruskal's algorithm to find the Minimum Spanning Tree (MST).
    /// - Returns: An array of Roads that form the MST.
    func kruskalMST() -> [Road] {
        print("\n--- Starting Kruskal's Algorithm Visualization ---")

        // Step 1: Get all roads and sort them by weight in ascending order.
        let sortedRoads = self.varRoads.sorted()  // Uses the Comparable conformance of Road

        print("\nAll Roads Sorted by Weight:")
        for road in sortedRoads {
            print(
                "  \(road.from.name) (\(road.from.id.prefix(4))) <-> \(road.to.name) (\(road.to.id.prefix(4))): Weight \(road.weight)"
            )
        }

        // Step 2: Initialize a Disjoint Set Union (DSU) structure with all cities.
        // Each city starts in its own separate set.
        let ds = DisjointSet(cities: Array(self.cities.values))

        var mst: [Road] = []  // This will store the edges of our MST

        // The MST for 'N' vertices will have 'N-1' edges.
        let numVertices = self.cities.count

        print("\nInitial DSU State (each city in its own set):")
        ds.printState(allCityIDs: Array(cities.keys))

        print("\n--- Processing Roads ---")
        var step = 1
        // Step 3: Iterate through the sorted roads.
        for road in sortedRoads {
            print(
                "\nStep \(step): Considering Road: \(road.from.name) (\(road.from.id.prefix(4))) <-> \(road.to.name) (\(road.to.id.prefix(4))): Weight \(road.weight)"
            )

            let rootFrom = ds.find(road.from.id)
            let rootTo = ds.find(road.to.id)

            print("  Root of \(road.from.name): \(rootFrom.prefix(4))")
            print("  Root of \(road.to.name): \(rootTo.prefix(4))")

            // Check if adding this road would connect two previously unconnected components.
            // If ds.union returns true, it means the cities were in different sets and are now merged,
            // which means adding this road does NOT form a cycle.
            if ds.union(road.from.id, road.to.id) {
                print("  -> Roots are different. Adding this road to MST (NO CYCLE DETECTED).")
                mst.append(road)  // Add the road to our MST

                print("  Current MST Edges (\(mst.count) of \(numVertices - 1) needed):")
                for m_road in mst {
                    print(
                        "    \(m_road.from.name.prefix(8)) <-> \(m_road.to.name.prefix(8)): W \(m_road.weight)"
                    )
                }

                // If we have collected N-1 edges, we have found the MST.
                if mst.count == numVertices - 1 {
                    print("\n--- MST Complete! Found \(numVertices - 1) edges. ---")
                    break  // Stop early, no need to check further roads
                }
            } else {
                print("  -> Roots are the same! Adding this road would form a cycle. SKIPPING.")
            }
            ds.printState(allCityIDs: Array(cities.keys))
            step += 1
        }

        if mst.count < numVertices - 1 {
            print(
                "\nWarning: Could not form a complete spanning tree. The graph might be disconnected."
            )
        }

        print("\n--- Kruskal's Algorithm Visualization Complete ---")
        return mst
    }
}

// MARK: - Random Map Generation Function
/// Generates a random map with a specified number of cities and roads.
/// - Parameters:
///   - numCities: The number of cities to generate.
///   - numRoads: The number of roads to generate between cities.
///   - maxWeight: The maximum random weight for a road.
/// - Returns: A Map instance populated with random cities and roads.
func generateRandomMap(numCities: Int, numRoads: Int, maxWeight: Int) -> Map {
    let map = Map()
    var createdCities: [City] = []

    // Create cities
    for i in 0..<numCities {
        let city = City(id: UUID().uuidString, name: "City \(i + 1)")
        map.addCity(city)
        createdCities.append(city)
    }

    // Create random roads
    // Use a Set to avoid duplicate roads between the exact same pair of cities (from, to, weight)
    var addedRoads: Set<String> = []

    for _ in 0..<numRoads {
        // Ensure we don't try to add more roads than possible or loop infinitely
        if createdCities.count < 2 { break }  // Need at least 2 cities to form a road

        var fromCity: City
        var toCity: City
        var roadKey: String  // To track unique roads (unordered pair of city IDs)

        repeat {
            // Pick two random distinct cities
            let randomIndex1 = Int.random(in: 0..<numCities)
            var randomIndex2 = Int.random(in: 0..<numCities)

            while randomIndex2 == randomIndex1 {  // Ensure cities are distinct
                randomIndex2 = Int.random(in: 0..<numCities)
            }

            fromCity = createdCities[randomIndex1]
            toCity = createdCities[randomIndex2]

            // Create a consistent key for the road regardless of (from, to) order
            roadKey = [fromCity.id, toCity.id].sorted().joined(separator: "-")

        } while addedRoads.contains(roadKey)  // Keep trying until we get a unique road

        let weight = Int.random(in: 1...maxWeight)

        map.addRoad(from: fromCity, to: toCity, weight: weight)
        addedRoads.insert(roadKey)  // Mark this road as added
    }

    return map
}

// MARK: - Main Execution Example (for main.swift)
/*
// You would call this function from your main.swift file:
let numCities = 5
let numRoads = 8
let maxWeight = 100

let myMap = generateRandomMap(numCities: numCities, numRoads: numRoads, maxWeight: maxWeight)

print("Original Roads in the Map:")
for road in myMap.varRoads { // Changed to varRoads
    print("  \(road.from.name) (\(road.from.id.prefix(4))) <-> \(road.to.name) (\(road.to.id.prefix(4))): Weight \(road.weight)")
}

let mstRoads = myMap.kruskalMST()

print("\n--- Final Minimum Spanning Tree ---")
var totalMSTWeight = 0
if mstRoads.isEmpty && myMap.cities.count > 0 {
    // This case means a spanning tree could not be formed (e.g., disconnected graph)
    print("No MST found. The graph might be disconnected or have no roads that connect all cities.")
} else if mstRoads.count < myMap.cities.count - 1 && myMap.cities.count > 1 {
     print("A spanning tree could not connect all cities. The graph might be disconnected.")
}
else {
    for road in mstRoads {
        print("  \(road.from.name) (\(road.from.id.prefix(4))) <-> \(road.to.name) (\(road.to.id.prefix(4))): Weight \(road.weight)")
        totalMSTWeight += road.weight
    }
    print("\nTotal MST Weight: \(totalMSTWeight)")
}

// You can add more detailed checks or visual output here if running in an environment with UI.
*/
