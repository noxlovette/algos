class Solution {
    func findMedianSortedArrays(_ nums1: [Int], _ nums2: [Int]) -> Double {
        let A = nums1.count <= nums2.count ? nums1 : nums2
        let B = nums1.count <= nums2.count ? nums2 : nums1
        let m = A.count
        let n = B.count

        var low = 0
        var high = m

        while low <= high {
            let i = (low + high) / 2
            let j = (m + n + 1) / 2 - i

            let maxLeftA = (i == 0) ? Int.min : A[i - 1]
            let minRightA = (i == m) ? Int.max : A[i]

            let maxLeftB = (j == 0) ? Int.min : B[j - 1]
            let minRightB = (j == n) ? Int.max : B[j]

            if maxLeftA <= minRightB && maxLeftB <= minRightA {
                let maxOfLeft = max(maxLeftA, maxLeftB)
                let minOfRight = min(minRightA, minRightB)

                if (m + n) % 2 == 0 {
                    return Double(maxOfLeft + minOfRight) / 2.0
                } else {
                    return Double(maxOfLeft)
                }
            } else if maxLeftA > minRightB {
                high = i - 1
            } else {
                low = i + 1
            }
        }

        return 0.0  // Should never reach this if input is valid
    }
}
