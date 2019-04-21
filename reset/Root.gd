extends Node

var turnCount
var maxTurn
var Building = preload("res://building.gd")
var house = preload("res://images/houses.png")
var Grid = []
var housecoords = [[6, 0], [7, 0], [8, 0], [6, 2], [7, 2], [8, 2], \
                   [2,10], [3,10], [4,10], [5,10], [6,10], [7,10], \
                   [1,14], [2,14], [3,14], [4,14], [5,14], [6,14], \
                   [7,14], [0,11], [0,12], [0,13], [8,11], [8,12], \
                   [8,13]]

var appartment_coords = [[2, 3], [3, 3], [7, 3], [8, 3], [1, 4], \
                         [1, 6], [3, 8], [6, 8], [7, 8]]
var selected
var selected_coordinates
var resource_amount
var people_amount
var censor_level
var total_population
var endGame

signal mouse_click

func _ready():
	endGame = false
	maxTurn = floor(rand_range(7,14))
	turnCount = 1
	resource_amount = 0
	people_amount = 0
	total_population = 0
	var propertiles = get_node("propertiles")
	
	for i in range(16):
			Grid.append([])
			for j in range(16):
				Grid[i].append(null)
	for i in range(housecoords.size()):
		#var sprite = Sprite.new()
		var place = housecoords[i]
		#sprite.texture = house
		#propertiles.set_cellv(Vector2(place[0],place[1]), propertiles.get_tileset().find_tile_by_name("houses1"))
		var pop = floor(rand_range(1, 7))
		total_population = total_population + pop
		var cap = floor(rand_range(pop, 15))
		var res = floor(rand_range(cap*5, cap*20))
		var inte = floor(rand_range(0,50))
		var building = Building.new("House", cap, pop, res, inte)
		Grid[place[0]][place[1]] = building

	for i in range(appartment_coords.size()):
		var place = appartment_coords[i]
		var pop = floor(rand_range(80, 200))
		total_population = total_population + pop
		var cap = floor(rand_range(pop, 300))
		var res = floor(rand_range(cap*5, cap*15))
		var inte = floor(rand_range(0,60))
		var building = Building.new("Appartment Building", cap, pop, res, inte)
		Grid[place[0]][place[1]] = building

	print("Population:", total_population)
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
			var inte = selected.get_integrity()
			print(selected.invested_resources)
			var iBox = get_node("BottomDialog/InfoBox")
			iBox.clear()
			iBox.add_text("%s at (%d, %d)\n" % [selected.type,x,y])
			iBox.add_text("Population: %d\tMaximum Capacity: %d\nResource: %d\tIntegrity: %d" % [pop, cap, res, inte])
	pass

func next_turn():
	if endGame:
		return
	if (turnCount < maxTurn):
		turnCount += 1
		var tc = get_node("TurnCounterBox/TurnCounter")
		tc.clear()
		tc.add_text(str(turnCount))
		return
	endGame = true
	get_child(0).getSurviving()
	pass

func change_resource_amount(value, res):
	if res:
		resource_amount = value
	else:
		people_amount = value

func move_resources():
	if (selected != null):
		var origin = selected
		yield(self, "mouse_click")
		var destination = selected
		if (origin.resources > resource_amount):
			origin.resources = origin.resources - resource_amount
			destination.resources = destination.resources + resource_amount
		else:
			destination.resources = destination.resources + origin.resources
			origin.resources = 0
		buildings(selected_coordinates[0], selected_coordinates[1])

func move_people():
	if (selected != null):
		var origin = selected
		yield(self, "mouse_click")
		var destination = selected
		if (origin.population > people_amount):
			origin.population = origin.population - people_amount
			destination.population = destination.population + people_amount
		else:
			destination.population = destination.population + origin.population
			origin.population = 0
		buildings(selected_coordinates[0], selected_coordinates[1])
