extends Button

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	
	connect("pressed",self,"reset_completely")


func reset_completely():
	get_parent().get_node("TurnCounterBox/Text").clear()
	get_parent().get_node("BottomDialog/InfoBox").clear()
	get_parent().get_node("BottomDialog/InfoBox2").clear()
	get_parent().get_node("HappinessMeter/ProgressBar").value=100
	get_parent().get_node("HappinessMeter/Face").texture = load("res://images/happiness.png")
	var a = get_parent().get_node("NewsButton/CheckList/0")
	get_parent().get_node("NewsButton/CheckList/1").pressed = false
	get_parent().get_node("NewsButton/CheckList/2").pressed = false
	get_parent().get_node("NewsButton").checkbox_clicked(a, false)
	var b = get_parent().get_node("TurnActions/popValue")
	b.clear()
	b.add_text("100")
	b = get_parent().get_node("TurnActions/resValue")
	b.clear()
	b.add_text("10")
	get_parent()._ready()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
