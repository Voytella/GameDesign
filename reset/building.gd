#class Building:
var type
var capacity
var population
var resources
var integrity
var base_upgrade_cost

func _init(typ, cap, pop, res, inte):
	self.type = typ
	self.capacity = cap
	self.population = pop
	self.resources = res
	self.integrity = inte * 5
	self.base_upgrade_cost = (10 * inte) + 100

func set_val(cap, pop, res, inte):
	self.capacity = cap
	self.population = pop
	self.resources = res
	self.integrity = inte

func get_population():
	return self.population

func get_capacity():
	return self.capacity

func get_resources():
	return self.resources

func get_integrity():
	return self.integrity
	
func get_type_multiplier():
	if (self.type == "House"):
		return 1
	if (self.type == "Appartment Building"):
		return 5

func fortify():
	if (self.integrity == 100):
		print("cannot upgrade further")
		return
	var mult = get_type_multiplier()
	var cost = self.base_upgrade_cost * mult
	if (self.resources > cost):
		self.resources -= cost
		self.base_upgrade_cost += 10 * mult
		self.integrity += 5

func strip():
	if (self.integrity == 0):
		print("cannot strip further")
		return
	var mult = get_type_multiplier()
	var gain = floor(self.base_upgrade_cost * mult * 0.75)
	self.resources += gain
	self.base_upgrade_cost -= 10 * mult
	self.integrity -= 5
	
func get_upgrade_cost():
	if (self.integrity == 100):
		return "max"
	var mult = get_type_multiplier()
	return str(self.base_upgrade_cost * mult)

func get_strip_gain():
	if (self.integrity == 0):
		return "min"
	var mult = get_type_multiplier()
	return str(floor(self.base_upgrade_cost * mult * 0.75))