extends Button

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var popup
var checklist

# Called when the node enters the scene tree for the first time.
func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	connect("pressed",self,"handle_censorship")
	connect("mouse_entered", self, "popup_hint")
	popup = get_child(0)
	checklist = get_child(1)
	checkbox_clicked(checklist.get_child(0), false)
	#connect("mouse_exited", self, "hide_popup")
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
func checkbox_clicked(checkbox, value):
	if checkbox.pressed:
		for i in range(3):
			if i != int(checkbox.name):
				get_child(1).get_child(i).pressed = false
	else:
		checkbox.pressed = true
	get_parent().censor_level = int(checkbox.name)

func handle_censorship():
	var x = get_child(1)
	x.visible = !x.visible

func popup_hint():
	if !popup.visible:
		popup.visible = true
		#popup.get_child(0).visible = true
	
func hide_popup():
	var popup = get_child(0)
	if popup.visible:
		popup.visible = false
		#popup.get_child(0).visible = false