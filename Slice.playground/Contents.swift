import Foundation

//Regex Pattern to match and validate input string
let regex_pattern = "^\\d+x\\d+\\s{1}(\\(\\d+,\\s{1}\\d+\\))(\\s{1}\\(\\d+,\\s{1}\\d+\\))*$"

let regex_validation_error = """
The given input string does not match the required pattern.
Input string should match given criteria :
    - Input string should start with grid size with format {Int}x{Int}, for Ex : 5x5, 100x100. Please note x is small case
    - Input string should be followed by drop locations with format ({Int}, {Int}) with spaces between them. Mark the space between points after comma

Acceptable Input String Examples:
    - 5x5 (1, 3)
    - 5x5 (1, 3) (4, 4)
    - 25x35 (10, 3) (24, 34) (13, 9)
    - 100x100 (10, 3) (24, 34) (13, 9) (99, 99)
"""

let drop_locations_error = """
The given drop locations should be within the grid size provided

Acceptable Input String Examples:
    - 5x5 (1, 3)
    - 5x5 (1, 3) (4, 4)
    - 25x35 (10, 3) (24, 34) (13, 9)
    - 100x100 (10, 3) (24, 34) (13, 9) (99, 99)
"""

let navigation_coords_error = "Navigation Coordinates are incorrect"


//Function to validate input string with regex
func validate_input_string_matches_regex(_ input: String) -> Bool {
    
    do {
        let regex = try NSRegularExpression(pattern: regex_pattern)
        let results = regex.matches(in: input, range: NSRange(input.startIndex..., in: input))
        let output = results.map {
            String(input[Range($0.range, in: input)!])
        }
        if output.count == 1 {
            if output[0] == input { //the whole string should match the given regex output match
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
assert(validate_input_string_matches_regex("5x5 (1, 3)") == true)
assert(validate_input_string_matches_regex("5x5 (1, 3) (4, 4)") == true)
assert(validate_input_string_matches_regex("25x35 (10, 3) (24, 34) (13, 9)") == true)
assert(validate_input_string_matches_regex("100x100 (10, 3) (24, 34) (13, 9) (99, 99)") == true)
assert(validate_input_string_matches_regex("1000x1000 (10, 3) (24, 34) (13, 9) (99, 99) (100, 100) (999, 999)") == true)

//Tests for Non Acceptable String
assert(validate_input_string_matches_regex("7x7") == false) //expecting at least one drop locations
assert(validate_input_string_matches_regex("10xB (10, 3)") == false) //grid size should be in int
assert(validate_input_string_matches_regex("AxB (10, 3) (24, 34)") == false) //grid size should be in int
assert(validate_input_string_matches_regex("Ax100 (10, 3) (24, 34)") == false) //grid size shoud be in int
assert(validate_input_string_matches_regex("100x100 (A, 3) (24, 34)") == false) //drop locations should have int, not char
assert(validate_input_string_matches_regex("100x100 (1, 3)(24, 34)") == false) //space should be present between multiple drop locations
assert(validate_input_string_matches_regex("100x100 (1,3) (24,34) (1, 100)") == false) //space should be present between drop location coordinates
assert(validate_input_string_matches_regex("100x100 (1,3) 24,34) 1, 100)") == false) //drop location should contain brackets
assert(validate_input_string_matches_regex("100x100 (1,3) 24,34 (1, 100") == false) //drop location should contain brackets


//extract grid size
func get_grid_size(_ input: String) -> [String : Int] {
    let grid = input.split(separator: " ")[0]
    
    let grid_split = grid.split(separator: "x")
    
    let grid_size = ["x" : Int(grid_split[0])!, "y" : Int(grid_split[1])!]
    
    return grid_size
}


//Test for get grid size
assert(get_grid_size("5x5 (1, 3) (4, 4)") == ["x": 5, "y": 5])
assert(get_grid_size("100x100 (10, 3) (24, 34) (13, 9) (99, 99)") == ["x": 100, "y": 100])


//extract drop locations from input string
func get_drop_locations(_ input: String) -> [[String : Int]] {
    let locations = input.split(separator: " ", maxSplits: 1)
    
    //extracting all digits and creating an array
    guard let points = locations.last?.components(separatedBy: CharacterSet.decimalDigits.inverted).compactMap ({ Int($0) })
    else {
        fatalError(regex_validation_error)
    }
    
    var drop_locations: [[String : Int]] = []
    
    //creating a dictionary from the array with x and y coords
    for index in stride(from: 0, to: points.count - 1, by: 2) {
        drop_locations.append(["x": points[index], "y": points[index+1]])
    }
    
    return drop_locations
}


//Test for get drop locations
assert(get_drop_locations("5x5 (1, 3) (4, 4)") == [["x": 1, "y": 3], ["x": 4, "y": 4]])
assert(get_drop_locations("100x100 (10, 3) (24, 34) (13, 9) (99, 99)") == [["x": 10, "y": 3], ["x": 24, "y": 34], ["x": 13, "y": 9], ["x": 99, "y": 99]])


//validate drop locations doesn't exceed grid size
func validate_drop_locations(gridSize: [String : Int], dropLocations: [[String : Int]]) -> Bool {
    
    return dropLocations.allSatisfy { $0["x"]! <= gridSize["x"]! } && dropLocations.allSatisfy { $0["y"]! <= gridSize["y"]! }
    
}

assert(validate_drop_locations(gridSize: ["x": 5, "y": 5],
                               dropLocations: [["x": 1, "y": 3], ["x": 4, "y": 4]]) == true)
assert(validate_drop_locations(gridSize: ["x": 100, "y": 100],
                               dropLocations: [["x": 10, "y": 3], ["x": 24, "y": 34], ["x": 13, "y": 9], ["x": 99, "y": 99]]) == true)
assert(validate_drop_locations(gridSize: ["x": 5, "y": 5],
                               dropLocations: [["x": 20, "y": 3], ["x": 4, "y": 4]]) == false) //value of x in drop locations is 20 which is more then x of grid size
assert(validate_drop_locations(gridSize: ["x": 100, "y": 100],
                               dropLocations: [["x": 10, "y": 3], ["x": 24, "y": 200], ["x": 13, "y": 9], ["x": 99, "y": 99]]) == false) // value of y in drop location is 200 which is more than y of grid size

func generate_navigation_coords(_ dropLocations : [[String : Int]]) -> String {
    
    //appending initial location as 0, 0 which will be the previous location after starting
    let drop_locations = [["x": 0, "y": 0]] + dropLocations
    
    var navigation_coords = ""
    var index = 0
    
    for drop_location in drop_locations[1...] {
        let previous_point = drop_locations[index]
        var x_move = drop_location["x"]! - previous_point["x"]!
        
        while x_move > 0 {
            navigation_coords += "E"
            x_move -= 1
        }
        
        while x_move < 0 {
            navigation_coords += "W"
            x_move += 1
        }
        
        var y_move = drop_location["y"]! - previous_point["y"]!
        
        while y_move > 0 {
            navigation_coords += "N"
            y_move -= 1
        }
        
        while y_move < 0 {
            navigation_coords += "S"
            y_move += 1
        }
        
        if x_move == 0 && y_move == 0 {
            navigation_coords += "D"
        }
        index += 1
    }
    print(navigation_coords)
    return navigation_coords
    
}

//function to deliver pizza
func pizzabot(_ input: String) -> String {
    
    let is_input_valud = validate_input_string_matches_regex(input)
    
    assert(is_input_valud, regex_validation_error)
    
    let grid_size = get_grid_size(input)
    
    let drop_locations = get_drop_locations(input)
    
    let are_drop_locations_valid = validate_drop_locations(gridSize: grid_size, dropLocations: drop_locations)
    
    assert(are_drop_locations_valid, drop_locations_error)
    
    return generate_navigation_coords(drop_locations)
}


//test pizzabot
assert(pizzabot("5x5 (1, 3) (4, 4)") == "ENNNDEEEND", navigation_coords_error)
assert(pizzabot("5x5 (0, 0) (1, 3) (4, 4) (4, 2) (4, 2) (0, 1) (3, 2) (2, 3) (4, 1)") == "DENNNDEEENDSSDDWWWWSDEEENDWNDEESSD", navigation_coords_error)
