extends Node

var Grid
var housecoords

# import variables from the main program
func _ready():
	pass

# get all the buildings in a list
func getAllBuildings():
	Grid = get_parent().Grid
	housecoords = get_parent().housecoords
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
func getSurviving(totPop):
	var survived = getSurvived(getAllBuildings())
	var surPop = getTotPop(survived)
	var surRes = getTotRes(survived)
	getScore(surPop, surRes, totPop)
	return

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
func getScore(surPop, surRes, totPop):
	var month = 0
	
	# see how many months pass without incident
	while (getMonthScore(surPop, surRes, month) == surPop):
		 month += 1
	
	# see how many people survive the critical month
	var critMonth = getMonthScore(surPop, surRes, month)
	
	# display score
	var iBox = get_node("../BottomDialog/InfoBox")
	get_node("../BottomDialog/InfoBox2").clear()
	iBox.clear()
	iBox.add_text("Initial Survivors: %d/%d\nMonths survived: %d\nRemaining Survivors: %d" % [surPop, totPop, month, getMonthScore(surPop, surRes, critMonth)])
	