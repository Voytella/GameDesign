extends Node

var turnCount
var maxTurn
var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
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
var censor_level_previous
var total_population
var total_resources
var endGame

var people_movement
var resource_movement
var happiness
var fortified_in_turn
var stripped_in_turn
var delay
var info_boost
var date_1
var date_2
var date_3

signal mouse_click

func _ready():
	randomize()
	date_1 = months[randi()%12]
	date_2 = randi()%15+1
	date_3 = str(2015+randi()%20+1) + " 8:00AM"
	get_node("TurnCounterBox/Text").add_text("%s %s %s" % [date_1, str(date_2), date_3])
	info_boost = true
	fortified_in_turn = 0
	censor_level_previous = 0
	stripped_in_turn = 0
	delay = 0
	resource_movement = 10
	people_movement = 100
	happiness = 100
	endGame = false
	maxTurn = floor(rand_range(7,14))
	turnCount = 1
	resource_amount = 0
	people_amount = 0
	total_population = 0
	total_resources = 0
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
		total_population += pop
		var cap = floor(rand_range(pop, 15))
		var res = floor(rand_range(cap*2, cap*10))
		total_resources += res
		var inte = floor(rand_range(1,10))
		var building = Building.new("House", cap, pop, res, inte)
		Grid[place[0]][place[1]] = building

	for i in range(appartment_coords.size()):
		var place = appartment_coords[i]
		var pop = floor(rand_range(80, 200))
		total_population += pop
		var cap = floor(rand_range(pop, 300))
		var res = floor(rand_range(cap*2, cap*10))
		total_resources += res
		var inte = floor(rand_range(1,12))
		var building = Building.new("Appartment Building", cap, pop, res, inte)
		Grid[place[0]][place[1]] = building

	var pop = 0
	var cap = 2500
	var res = 1000
	total_resources += res
	var inte = 8
	var building = Building.new("Stadium", cap, pop, res, inte)
	Grid[0][0] = building; Grid[0][1] = building; Grid[0][2] = building
	Grid[1][0] = building; Grid[1][1] = building; Grid[1][2] = building
	Grid[2][0] = building; Grid[2][1] = building; Grid[2][2] = building
	
	pop = 50
	total_population += pop
	cap = 250
	res = 10000
	total_resources += res
	inte = 15
	building = Building.new("Factory", cap, pop, res, inte)
	Grid[13][7] = building; Grid[14][7] = building
	Grid[13][8] = building; Grid[14][8] = building
	
	pop = 50
	total_population += pop
	cap = 250
	res = 10000
	total_resources += res
	inte = 15
	building = Building.new("Factory", cap, pop, res, inte)
	Grid[10][9] = building; Grid[11][9] = building
	Grid[10][10] = building; Grid[11][10] = building

	pop = 50
	total_population = total_population + pop
	cap = 250
	res = 10000
	total_resources = total_resources + res
	inte = 15
	building = Building.new("Factory", cap, pop, res, inte)
	Grid[13][11] = building; Grid[14][11] = building
	Grid[13][12] = building; Grid[14][12] = building
	
	pop = 50
	total_population += pop
	cap = 250
	res = 10000
	total_resources += res
	inte = 15
	building = Building.new("Factory", cap, pop, res, inte)
	Grid[10][12] = building; Grid[11][12] = building
	Grid[10][13] = building; Grid[11][13] = building

	pop = 5
	total_population += pop
	cap = 20
	res = 2500
	total_resources += res
	inte = 4
	building = Building.new("Farm", cap, pop, res, inte)
	# Grid[13][0] = building; Grid[14][0] = building; Grid[15][0] = building
	Grid[13][1] = building #; Grid[14][1] = building; Grid[15][1] = building
	# Grid[13][2] = building; Grid[14][2] = building; Grid[15][2] = building

	print("Population:", total_population)
	print("Resources:", total_resources)
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
			#print(selected.invested_resources)
			var iBox = get_node("BottomDialog/InfoBox")
			var iBox2 = get_node("BottomDialog/InfoBox2")
			iBox.clear()
			iBox.add_text("%s at (%d, %d)\n" % [selected.type,x,y])
			iBox.add_text("Population: %d\nMaximum Capacity: %d\nResource: %d" % [pop, cap, res])
			iBox2.clear()
			iBox2.add_text("\nIntegrity: %d%%\nFortification Cost: %s\nStrip Gain: %s" % [inte, selected.get_upgrade_cost(), selected.get_strip_gain()])

func next_turn():
	if endGame:
		return
	if (turnCount < maxTurn):
		turnCount += 1
		var tc = get_node("TurnCounterBox/Text")
		tc.clear()
		tc.add_text("%s %s %s" % [date_1, str(date_2+turnCount-1), date_3])
		if (fortified_in_turn > 4 and censor_level_previous == 0) or (fortified_in_turn > 6 and censor_level_previous == 1):
			happiness -= (fortified_in_turn - 4 - (2*censor_level_previous))
		if (stripped_in_turn > 3 and censor_level_previous == 0) or (stripped_in_turn > 5 and censor_level_previous == 1):
			happiness -= (fortified_in_turn - 3 - censor_level_previous)
		if (resource_movement < 1  and censor_level_previous == 0) or (resource_movement > 8 - delay and censor_level_previous == 2):
			happiness -= (5 + 2.5*censor_level_previous)
		else:
			happiness += 2
		if (people_movement < 95 and censor_level_previous < 2):
			happiness -= 10
		if(happiness < 75 and censor_level_previous == 0) or (happiness < 50 and censor_level_previous == 1):
			if censor_level == 2 and info_boost:
				happiness += 15
				info_boost = false
		if (happiness < 0): happiness = 0
		if (happiness > 100): happiness = 100
		delay = 10 - floor(happiness/10)
		resource_movement = 10 - delay
		censor_level_previous = censor_level
		people_movement = happiness
		var a = get_node("TurnActions/popValue")
		a.clear()
		a.add_text(str(people_movement))
		a = get_node("TurnActions/resValue")
		a.clear()
		a.add_text(str(resource_movement))
		print(turnCount, happiness)
		if happiness <= 33:
			get_node("HappinessMeter/Face").texture = load("res://images/sad.png")
		elif (happiness <= 66):
			get_node("HappinessMeter/Face").texture = load("res://images/apathy.png")
		else:
			get_node("HappinessMeter/Face").texture = load("res://images/happiness.png")
		get_node("HappinessMeter/ProgressBar").value = happiness
		fortified_in_turn = 0
		stripped_in_turn = 0
		for i in Grid:
			for j in i:
				if j != null:
					j.fortified = false
					j.stripped = false
		return
	endGame = true
	get_child(0).getSurviving()
	pass

func change_resource_amount(value, res):
	if res:
		resource_amount = value
	else:
		people_amount = value

func fortify():
	if (selected != null):
		selected.fortify()
		fortified_in_turn += 1
		buildings(selected_coordinates[0], selected_coordinates[1])
		
func strip():
	if (selected != null):
		selected.strip()
		stripped_in_turn += 1
		buildings(selected_coordinates[0], selected_coordinates[1])

func move_resources():
	if (resource_movement <= 0):
		return
	if (selected != null):
		var origin = selected
		yield(self, "mouse_click")
		var destination = selected
		if (origin.resources > resource_amount):
			origin.resources -= resource_amount
			destination.resources += resource_amount
			resource_movement -= 1
		else:
			destination.resources += origin.resources
			resource_movement -= 1
			origin.resources = 0
		buildings(selected_coordinates[0], selected_coordinates[1])
		var a = get_node("TurnActions/resValue")
		a.clear()
		a.add_text(str(resource_movement))

func move_people():
	if (people_movement < people_amount):
		return
	if (selected != null):
		var origin = selected
		yield(self, "mouse_click")
		var destination = selected
		if (origin.population > people_amount):
			origin.population -= people_amount
			destination.population += people_amount
			people_movement -= people_amount
		else:
			destination.population += origin.population
			people_movement -= origin.population
			origin.population = 0
		buildings(selected_coordinates[0], selected_coordinates[1])
		var a = get_node("TurnActions/popValue")
		a.clear()
		a.add_text(str(people_movement))
