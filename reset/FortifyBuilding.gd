extends Button

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	connect("pressed",get_parent(),"move_resources")
	connect("mouse_entered", self, "popup_hint")
	#connect("mouse_exited", self, "hide_popup")
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
	
func _on_pressed():
	get_parent().move_resources()
	
func popup_hint():
	var popup = get_child(0)
	if !popup.visible:
		var x = self.get_rect()
		x.position = x.position - Vector2(166, 4)
		x.size = Vector2(153,54)
		popup.popup(x)
		#popup.get_child(0).visible = true
	
func hide_popup():
	var popup = get_child(0)
	if popup.visible:
		popup.hide()
		#popup.get_child(0).visible = false