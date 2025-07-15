func reverse(_ x: Int) -> Int {
    var x = x
    var result = 0

    while x != 0 {
        let digit = x % 10

        // Check for overflow before doing the math
        if result > Int32.max / 10 || result < Int32.min / 10
            || (result == Int32.max / 10 && digit > Int32.max % 10)
            || (result == Int32.min / 10 && digit < Int32.min % 10)
        {
            return 0
        }

        result = result * 10 + digit
        x = x / 10
    }

    return result
}
