extends Node

var turnCount
var Building = load("res://building.gd")
var house = preload("res://images/houses.png")
var Grid = []
var housecoords = [[6, 0], [7, 0], [8, 0], [6, 2], [7, 2], [8, 2], \
                   [2,10], [3,10], [4,10], [5,10], [6,10], [7,10], \
                   [1,14], [2,14], [3,14], [4,14], [5,14], [6,14], \
                   [7,14], [0,11], [0,12], [0,13], [8,11], [8,12], \
                   [8,13]]
var selected
var selected_coordinates
var resourceAmount
var accept = false
var x = 0

signal mouse_click
signal dialog_visibility_changed

func _ready():
	turnCount = 1
	resourceAmount = 0
	var propertiles = get_node("propertiles")
	
	for i in range(16):
			Grid.append([])
			for j in range(16):
				Grid[i].append(null)
	
	for i in range(housecoords.size()):
		var sprite = Sprite.new()
		var place = housecoords[i]
		sprite.texture = house
		propertiles.set_cellv(Vector2(place[0],place[1]), propertiles.get_tileset().find_tile_by_name("houses1"))
		var pop = floor(rand_range(1, 7))
		var cap = floor(rand_range(pop, 15))
		var res = floor(rand_range(0, cap*20))
		var building = Building.new(cap, pop, res)
		Grid[place[0]][place[1]] = building

	pass

func _process(delta):

	pass

func buildings(x, y):
	if (x < 16 and y < 16):
		var b = Grid[x][y]
		if (b != null):
			selected = Grid[x][y]
			selected_coordinates = [x, y]
			var pop = selected.get_population()
			var cap = selected.get_capacity()
			var res = selected.get_resources()
			var iBox = get_node("BottomDialog/InfoBox")
			iBox.clear()
			iBox.add_text("House at (%d, %d)\n" % [x,y])
			iBox.add_text("Population: %d\nMaximum Capacity: %d\nResource: %d" % [pop, cap, res])
	pass

func next_turn():
	turnCount = turnCount + 1
	var tc = get_node("TurnCounterBox/TurnCounter")
	tc.clear()
	tc.add_text(str(turnCount))
	pass

func change_resource_amount(value):
	resourceAmount = value

func move_resources():
	if (selected != null):
		var origin = selected
		print("before click")
		yield(self, "mouse_click")
		print("after click")
		var destination = selected
		get_node("AcceptDialog").visible = true
		print(accept)
		if (x == 0):
			yield(self, "dialog_visibility_changed")
			x = 1
		yield(self, "dialog_visibility_changed")
		var t = Timer.new()
		t.set_wait_time(0.00001)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		print(accept)
		if (accept):
			if (origin.resources > resourceAmount):
				origin.resources = origin.resources - resourceAmount
				destination.resources = destination.resources + resourceAmount
			else:
				destination.resources = destination.resources + origin.resources
				origin.resources = 0
			accept = false
			buildings(selected_coordinates[0], selected_coordinates[1])

func accept():
	accept = true