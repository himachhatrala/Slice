import Foundation

//Regex Pattern to match and validate input string
let regex_pattern = "^\\d+x\\d+\\s{1}(\\(\\d+,\\s{1}\\d+\\))(\\s{1}\\(\\d+,\\s{1}\\d+\\))*$"

//Function to validate input string with regex
func test_input_string_matches_regex(_ input: String) -> Bool {
    do {
        let regex = try NSRegularExpression(pattern: regex_pattern)
        let results = regex.matches(in: input, range: NSRange(input.startIndex..., in: input))
        let output = results.map {
            String(input[Range($0.range, in: input)!])
        }
        if output.count == 1 {
            if output[0] == input {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    } catch let error {
        print("invalid regex: \(error.localizedDescription)")
        return false
    }
}


//Tests to validate acceptable input strings
//The initial part should be {Int}x{Int} pattern
//Followed by ({Int}, {Int}) pattern with space after comma
//Acceptable String pattern "{Int}x{Int} ({Int}, {Int}) ({Int}, {Int}) ... n times"
assert(test_input_string_matches_regex("5x5 (1, 3)") == true)
assert(test_input_string_matches_regex("5x5 (1, 3) (4, 4)") == true)
assert(test_input_string_matches_regex("25x35 (10, 3) (24, 34) (13, 9)") == true)
assert(test_input_string_matches_regex("100x100 (10, 3) (24, 34) (13, 9) (99, 99)") == true)
assert(test_input_string_matches_regex("1000x1000 (10, 3) (24, 34) (13, 9) (99, 99) (100, 100) (999, 999)") == true)

//Non Acceptable String tests
assert(test_input_string_matches_regex("7x7") == false) //expecting at least one drop locations
assert(test_input_string_matches_regex("10xB (10, 3)") == false) //grid size should be in int
assert(test_input_string_matches_regex("AxB (10, 3) (24, 34)") == false) //grid size should be in int
assert(test_input_string_matches_regex("Ax100 (10, 3) (24, 34)") == false) //grid size shoud be in int
assert(test_input_string_matches_regex("100x100 (A, 3) (24, 34)") == false) //drop locations should have int, not char
assert(test_input_string_matches_regex("100x100 (1, 3)(24, 34)") == false) //space should be present between multiple drop locations
assert(test_input_string_matches_regex("100x100 (1,3) (24,34) (1, 100)") == false) //space should be present between drop location coordinates
assert(test_input_string_matches_regex("100x100 (1,3) 24,34) 1, 100)") == false) //drop location should contain brackets
assert(test_input_string_matches_regex("100x100 (1,3) 24,34 (1, 100") == false) //drop location should contain brackets



//function to deliver pizza
func pizzabot(_ input: String) -> String {
    return ""
}


//test
assert(pizzabot("5x5 (1, 3) (4, 4)") == "ENNNDEEEND", "not equal")
