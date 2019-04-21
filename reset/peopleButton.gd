extends Button

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	connect("pressed",self,"_on_pressed")
	connect("mouse_entered",self,"popup_hint")
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_pressed():
	get_parent().move_people()

func popup_hint():
	var popup = get_child(0)
	if !popup.visible:
		var x = self.get_rect()
		x.position = x.position - Vector2(198, 4)
		x.size = Vector2(185,79)
		popup.popup(x)
		#popup.get_child(0).visible = true
	
func hide_popup():
	var popup = get_child(0)
	if popup.visible:
		popup.hide()
		#popup.get_child(0).visible = false
