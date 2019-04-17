extends Camera2D

#var body_texture = preload("res://images/Background64.png")
#var eyes_texture = preload("res://images/Cursor64.png")

#func _ready():
#    var eyes = Sprite.new()
#    var body = Sprite.new()
#    #body_texture.set_size_override(Vector2(64,64))
#    body.set_texture(body_texture)  
#    eyes.set_texture(eyes_texture)
#    self.add_child(body)
#    self.add_child(eyes)
#
#func get_screenshot():
#   # get_viewport returns the closest viewport (subViewport)
#	var img = get_viewport().get_texture()#.get_data()
#	yield(get_tree(),"idle_frame")
#	yield(get_tree(),"idle_frame")
#	return img
	#img.save_png("image.png")