extends TileMap

var turn = 1
var movements = 50
var maxTurns = floor(rand_range(10,15))

var movePop = null
var moveRes = null


var Building = load("res://building.gd")
var house = preload("res://images/houses.png")
var Grid = []
var housecoords = [[6, 0], [7, 0], [8, 0], [6, 2], [7, 2], [8, 2], \
                   [2,10], [3,10], [4,10], [5,10], [6,10], [7,10], \
                   [1,14], [2,14], [3,14], [4,14], [5,14], [6,14], \
                   [7,14], [0,11], [0,12], [0,13], [8,11], [8,12], \
                   [8,13]]
var nextTurnCoords = [15, 0]

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	print("There will be ", maxTurns, " turns")
	for i in range(16):
		Grid.append([])
		for j in range(16):
			Grid[i].append(null)

	for i in range(housecoords.size()):
		var sprite = Sprite.new()
		var place = housecoords[i]
		sprite.texture = house
		self.set_cellv(Vector2(place[0],place[1]), self.get_tileset().find_tile_by_name("houses1"))
		var pop = floor(rand_range(1, 7))
		var cap = floor(rand_range(pop, 15))
		var res = floor(rand_range(0, cap*20))
		var building = Building.new(cap, pop, res)
		Grid[place[0]][place[1]] = building
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
func _input(event):
	if event is InputEventMouseButton \
	and event.button_index==BUTTON_LEFT and \
	event.is_pressed():
		self.on_click(get_global_mouse_position())
	pass
		
func on_click(pos):
	var coordinates = self.world_to_map(pos)
	print(coordinates)
	buildings(coordinates.x, coordinates.y)
	pass
	
func buildings(x, y):
	var b = Grid[x][y]
	var iBox = get_node("../BottomDialog/InfoBox")
	var jBox = get_node("../ColorRect/RichTextLabel")
	iBox.clear()
	if (b != null):
		var selected = Grid[x][y]
		var pop = selected.get_population()
		movePop = pop
		var cap = selected.get_capacity()
		var res = selected.get_resources()
		moveRes = res
		iBox.add_text("House at (%d, %d) %80s%d\n" % [x,y, "Turn: ", turn])
		iBox.add_text("Population: %d %74s%d\n Maximum Capacity: %d\nResource: %d\n" % [pop, "Movements: ", movements, cap, res])
		iBox.add_text("Movements: %d" % [movements])
	if (x == 15 and y == 0):
		if (turn == maxTurns+1):
			iBox.add_text("Game Over, Calculating Score...")
		else:
			iBox.add_text("Turn %d\n Movements reset to 50" % [turn])
			turn += 1
			movements = 50
	if (x == 14 and y == 0):
		iBox.add_text("This will be used to move resources")
		
	pass