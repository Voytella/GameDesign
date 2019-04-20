extends AcceptDialog

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	connect("visibility_changed", self, "_on_popup")
	connect("confirmed", self, "_on_confirm")
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_popup():
	get_parent().emit_signal("dialog_visibility_changed")

func _on_confirm():
	get_parent().accept()
	print("w")