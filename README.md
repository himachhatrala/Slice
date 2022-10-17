# Slice

PizzaBot is a navigation coordinates finder for a bot to deliver pizza in the given grid size and given drop locations. 

## Assumptions

- Grid is a 2D plane with x, y coordinates represented as 5x5 with origin at (0, 0)
- User will be asked to enter drop locations which are within the grid, else it will raise an error message
- If there are consequent similar drop locations, it means there are multiple pizzas to be delivered at the same location
- Drop Locations are considered in the same sequence they are entered. 


## Running the code

There is a function named pizzabot which expects an input string in the following format : 
- 5x5 (1, 3) (4, 4)
- 100x100 (10, 3) (24, 34) (13, 9) (99, 99)

Points to be noted: 
- Mark the spaces in between, they are expected as shown
- There should be atlease one drop location else it will raise an error

Eg. : `pizzabot("5x5 (1, 3) (4, 4)")` This will return the navigation coordinate string : `ENNNDEEEND`


## Test

Unit tests are in place to validate Input String, Grid Size, Drop Locations and pizzabot function.
