#class Building:
var capacity
var population
var resources
var integrity

func _init(cap, pop, res, inte):
	self.capacity = cap
	self.population = pop
	self.resources = res
	self.integrity = inte

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