import Foundation

class Solution {
    func lengthOfLongestSubstring(_ s: String) -> Int {
        var length = 0

        let chars = Array(s)
        var seen = Set<Character>()

        var left = 0
        for right in 0..<chars.count {
            while seen.contains(chars[right]) {
                seen.remove(chars[left])
                left += 1
            }

            seen.insert(chars[right])
            length = max(length, right - left + 1)
        }
        return length
    }
}

// Test cases
let solution = Solution()

// Test Example 1
let test1 = "abcabcbb"
let result1 = solution.lengthOfLongestSubstring(test1)
print("Input: \"\(test1)\"")
print("Output: \(result1)")
print("Expected: 3")
print()

// Test Example 2
let test2 = "bbbbb"
let result2 = solution.lengthOfLongestSubstring(test2)
print("Input: \"\(test2)\"")
print("Output: \(result2)")
print("Expected: 1")
print()

// Test Example 3
let test3 = "pwwkew"
let result3 = solution.lengthOfLongestSubstring(test3)
print("Input: \"\(test3)\"")
print("Output: \(result3)")
print("Expected: 3")
print()

// Additional edge cases
let test4 = ""
let result4 = solution.lengthOfLongestSubstring(test4)
print("Input: \"\(test4)\"")
print("Output: \(result4)")
print("Expected: 0")
print()

let test5 = "a"
let result5 = solution.lengthOfLongestSubstring(test5)
print("Input: \"\(test5)\"")
print("Output: \(result5)")
print("Expected: 1")
