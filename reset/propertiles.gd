extends TileMap



func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	var a = get_global_mouse_position()
	if a.x < 525 or a.x > 677 or a.y < 79 or a.y > 147:
		get_node("../ResButton").hide_popup()
	if a.x < 525 or a.x > 677 or a.y < 157 or a.y > 225:
		get_node("../peopleButton").hide_popup()
	if a.x < 525 or a.x > 677 or a.y < 235 or a.y > 287:
		get_node("../FortifyBuilding").hide_popup()
	if a.x < 525 or a.x > 677 or a.y < 296 or a.y > 348:
		get_node("../StripResources").hide_popup()
	if a.x < 525 or a.x > 677 or a.y < 358 or a.y > 410:
		get_node("../NewsButton").hide_popup()

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
