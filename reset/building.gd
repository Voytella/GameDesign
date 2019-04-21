#class Building:
var type
var capacity
var population
var resources
var integrity
var invested_resources

func _init(typ, cap, pop, res, inte):
	self.type = typ
	self.capacity = cap
	self.population = pop
	self.resources = res
	self.integrity = inte
	self.invested_resources = 20000/(-inte + 195) - 102.564

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