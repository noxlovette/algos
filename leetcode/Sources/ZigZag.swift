func convert(_ s: String, _ numRows: Int) -> String {
    if numRows == 1 {
        return s
    }
    let chars = Array(s)
    var upward = false

    var rows = Array(repeating: "", count: numRows)
    var currentRow = 0

    for i in chars {
        rows[currentRow].append(i)
        // Check boundaries and flip direction if needed
        if currentRow == numRows - 1 && !upward {
            upward = true
        } else if currentRow == 0 && upward {
            upward = false
        }

        // Now move based on direction
        if upward {
            currentRow -= 1
        } else {
            currentRow += 1
        }

    }

    return rows.joined()

}
