#class Building:
var capacity
var population
var resources

func _init(cap, pop, res):
	self.capacity = cap
	self.population = pop
	self.resources = res

func set_val(cap, pop, res):
	self.capacity = cap
	self.population = pop
	self.resources = res

func get_population():
	return self.population

func get_capacity():
	return self.capacity

func get_resources():
	return self.resources