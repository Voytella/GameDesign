extends Node

var turnCount
var maxTurn = floor(rand_range(1,14))
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
var endGame = false

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
		var inte = floor(rand_range(0, 100))
		var building = Building.new(cap, pop, res, inte)
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
			var inte = selected.get_integrity()
			var iBox = get_node("BottomDialog/InfoBox")
			iBox.clear()
			iBox.add_text("House at (%d, %d)\n" % [x,y])
			iBox.add_text("Population: %d\tMaximum Capacity: %d\nResources: %d\tIntegrity: %d\n" % [pop, cap, res, inte])
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
	getScore(getSurviving()[0], getSurviving()[1])

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
	
#----------BEGIN SCORE----------#

# get all the buildings in a list
func getAllBuildings():
	var buildings = []
	for coord in housecoords:
		buildings.append(Grid[coord[0]][coord[1]])
	return buildings

# determine if a building survived the blast
func isSurvived(building):
	return building.get_integrity() >= floor(rand_range(0,100))
	
# get all the buildings that survived
func getSurvived(buildings):
	var survived = []
	for building in buildings:
		if isSurvived(building):
			survived.append(building)
	return survived

# get total population from a list of buildings
func getTotPop(buildingList):
	var totPop = 0
	for building in buildingList:
		totPop += building.get_population()
	return totPop
	
# get total resources from a list of buildings
func getTotRes(buildingList):
	var totRes = 0
	for building in buildingList:
		totRes += building.get_resources()
	return totRes

# get the total amount of remaining resources and population
func getSurviving():
	var survived = getSurvived(getAllBuildings())
	var surPop = getTotPop(survived)
	var surRes = getTotRes(survived)
	return [surPop, surRes]

# How many people died?	
func numDeaths(surPop, surRes, months):
	
	# number of months that can pass before people start to die
	var monthsUntilCrit = floor(surRes / surPop)
	
	# leftover resources on the fateful month
	var remRes = fmod(surRes,surPop)
	
    # how died that month
	var numCritDied = surPop - remRes
	
	# if 'months' is month after critical month, report low res deaths
	if (months-1 == monthsUntilCrit):
		return numCritDied
		
	# otherwise, everyone died
	return surPop
	
# calculate score based upon months elapsed
func getMonthScore(surPop, surRes, months):
	
	# 1 res consumed per pop per month
	var consRes = surPop * months
	
	# resources remaining after 'months' have passed
	var remRes = surRes - consRes
	
	# if there are res remaining to suppport the pop, the pop is the score
	if remRes > 0:
		return surPop
	
	# otherwise, people died; report the number of surviors
	return surPop - numDeaths(surPop, surRes, months)
	
# get the number of the critical month and the number of surviors after
func getScore(surPop, surRes):
	var month = 0
	
	# see how many months pass without incident
	while (getMonthScore(surPop, surRes, month) == surPop):
		 month += 1
	
	# see how many people survive the critical month
	var critMonth = getMonthScore(surPop, surRes, month)
	
	# display score
	var iBox = get_node("BottomDialog/InfoBox")
	iBox.clear()
	iBox.add_text("Months until resources ran out: %d\nNumber of survivors after this critical month: %d" % [month, getMonthScore(surPop, surRes, critMonth)])

#-----------END SCORE-----------#