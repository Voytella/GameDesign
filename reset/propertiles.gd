extends TileMap



func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
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
	get_parent().buildings(coordinates.x, coordinates.y)
	get_parent().emit_signal("mouse_click")
	pass
