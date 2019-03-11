extends GridContainer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var background = preload("res://images/Background64.png")
var cursor = preload("res://images/nt_cursor.png")
var pressed = preload("res://images/pressed.png")
var grid
var array
#onready var camera = get_node("../Viewport/Camera2D")

###############################################################
func _ready():
	#Get Empty grid that is already in the scene
	grid = get_node("../Area")
	#camera.get_screenshot()

	#Create buttons and add them to a grid
	array = [] # also saves things to an array
	for x in range(8):
		array.append([])
		for y in range(8):
			var btn = TextureButton.new()
			btn.texture_normal = background
			btn.texture_hover = cursor
			btn.texture_pressed = pressed
			btn.name = "%d, %d" % [x,y]
			add_child(btn)
			array[x].append(btn)


	#for button in get_tree().get_nodes_in_group(grid):
	#	button.connect("pressed", self, "_some_button_pressed", [button])
	#pass

###############################################################
#function if you wanna do stuff like every billionth of a second
func _process(delta):
	
	pass

###############################################################

#func _some_button_pressed(button):
#	print(button.name)
