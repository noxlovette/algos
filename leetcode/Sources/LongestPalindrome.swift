class Solution {
    func longestPalindrome(_ s: String) -> String {
        let chars = Array(s)  // Convert to character array - O(n) once

        /// This guy actually finds the palindrome. It loops until chars match no more
        func findAround(_ left: Int, _ right: Int) -> (start: Int, end: Int, length: Int) {
            var l = left
            var r = right
            // check if out of bounds and if palindrome conditions are satisfied
            while l >= 0 && r < chars.count && chars[l] == chars[r] {  // O(1) access now!
                l -= 1
                r += 1
            }
            // l and r are one step beyond the answer when the loop exits
            return (l + 1, r - 1, r - l - 1)
        }

        let n = chars.count
        var bestStart = 0
        var bestEnd = 0
        var bestLength = 0

        for i in 0..<n {
            let oddResult = findAround(i, i)  // odd-length centered at i
            let evenResult = findAround(i, i + 1)  // even-length centered between i and i+1
            let currentResult = oddResult.length > evenResult.length ? oddResult : evenResult

            if currentResult.length > bestLength {
                bestStart = currentResult.start
                bestEnd = currentResult.end
                bestLength = currentResult.length
            }
        }

        // Convert back to string using array slicing
        return String(chars[bestStart...bestEnd])
    }
}
