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

//Tests for Non Acceptable String
assert(test_input_string_matches_regex("7x7") == false) //expecting at least one drop locations
assert(test_input_string_matches_regex("10xB (10, 3)") == false) //grid size should be in int
assert(test_input_string_matches_regex("AxB (10, 3) (24, 34)") == false) //grid size should be in int
assert(test_input_string_matches_regex("Ax100 (10, 3) (24, 34)") == false) //grid size shoud be in int
assert(test_input_string_matches_regex("100x100 (A, 3) (24, 34)") == false) //drop locations should have int, not char
assert(test_input_string_matches_regex("100x100 (1, 3)(24, 34)") == false) //space should be present between multiple drop locations
assert(test_input_string_matches_regex("100x100 (1,3) (24,34) (1, 100)") == false) //space should be present between drop location coordinates
assert(test_input_string_matches_regex("100x100 (1,3) 24,34) 1, 100)") == false) //drop location should contain brackets
assert(test_input_string_matches_regex("100x100 (1,3) 24,34 (1, 100") == false) //drop location should contain brackets


//extract grid size
func get_grid_size(_ input: String) -> [String : Int] {
    let grid = input.split(separator: " ")[0]
    
    let grid_split = grid.split(separator: "x")
    
    let grid_size = ["x" : Int(grid_split[0])!, "y" : Int(grid_split[1])!]
    
    return grid_size
}

//Test for get grid size
assert(get_grid_size("5x5 (1, 3) (4, 4)") == ["x": 5, "y": 5], "grid size is incorrect")
assert(get_grid_size("100x100 (10, 3) (24, 34) (13, 9) (99, 99)") == ["x": 100, "y": 100], "grid size is incorrect")


//extract drop locations from input string
func get_drop_locations(_ input: String) -> [[String : Int]] {
    let locations = input.split(separator: " ", maxSplits: 1)
    
    guard let points = locations.last?.components(separatedBy: CharacterSet.decimalDigits.inverted).compactMap ({ Int($0) })
    else {
        fatalError("Invalid points, please specify correct input points. Valid format: (x: 0, y: 0), (x: 1, y: 3)")
    }
    
    var drop_locations: [[String : Int]] = []
    
    for index in stride(from: 0, to: points.count - 1, by: 2) {
        drop_locations.append(["x": points[index], "y": points[index+1]])
    }
    
    return drop_locations
}

//Test for get drop locations
assert(get_drop_locations("5x5 (1, 3) (4, 4)") == [["x": 1, "y": 3], ["x": 4, "y": 4]], "drop locations are incorrect")
assert(get_drop_locations("100x100 (10, 3) (24, 34) (13, 9) (99, 99)") == [["x": 10, "y": 3], ["x": 24, "y": 34], ["x": 13, "y": 9], ["x": 99, "y": 99]], "grid size is incorrect")


//validate drop locations doesn't exceed grid size
func validate_drop_locations(gridSize: [String : Int], dropLocations: [[String : Int]]) {
    assert(dropLocations.allSatisfy { $0["x"]! <= gridSize["x"]! } , "exceeding x value")
    assert(dropLocations.allSatisfy { $0["y"]! <= gridSize["y"]! } , "exceeding y value")
}

//function to deliver pizza
func pizzabot(_ input: String) -> String {
    
    let grid_size = get_grid_size(input)
    
    let drop_locations = get_drop_locations(input)
    
    validate_drop_locations(gridSize: grid_size, dropLocations: drop_locations)
    
    return ""
}


//test
assert(pizzabot("5x5 (1, 3) (4, 4)") == "ENNNDEEEND", "not equal")
