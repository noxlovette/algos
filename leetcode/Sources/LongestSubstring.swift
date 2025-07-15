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
