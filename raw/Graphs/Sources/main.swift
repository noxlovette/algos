let numCities = 5
let numRoads = 8
let maxWeight = 100

let myMap = generateRandomMap(numCities: numCities, numRoads: numRoads, maxWeight: maxWeight)

print("Original Roads in the Map:")
for road in myMap.varRoads {  // Changed to varRoads
    print(
        "  \(road.from.name) (\(road.from.id.prefix(4))) <-> \(road.to.name) (\(road.to.id.prefix(4))): Weight \(road.weight)"
    )
}

let mstRoads = myMap.kruskalMST()

print("\n--- Final Minimum Spanning Tree ---")
var totalMSTWeight = 0
if mstRoads.isEmpty && myMap.cities.count > 0 {
    // This case means a spanning tree could not be formed (e.g., disconnected graph)
    print("No MST found. The graph might be disconnected or have no roads that connect all cities.")
} else if mstRoads.count < myMap.cities.count - 1 && myMap.cities.count > 1 {
    print("A spanning tree could not connect all cities. The graph might be disconnected.")
} else {
    for road in mstRoads {
        print(
            "  \(road.from.name) (\(road.from.id.prefix(4))) <-> \(road.to.name) (\(road.to.id.prefix(4))): Weight \(road.weight)"
        )
        totalMSTWeight += road.weight
    }
    print("\nTotal MST Weight: \(totalMSTWeight)")
}
