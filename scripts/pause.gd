extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# Allow _this_ scene to continue when game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Called once for every event before _unhandled_input(), allowing you to consume some events.
func _input(event):
	if event is InputEventAction and event.pressed:
		if event.action == "Main":
			get_tree().paused = false
			get_tree().change_scene_to_file("res://scenes/main.tscn")
		if event.action == "Pause":
			get_tree().paused = true
			visible = true
		if event.action == "Play":
			get_tree().paused = false
			visible = false
		if event.action == "Try":
			get_tree().paused = false
			get_tree().change_scene_to_file("res://scenes/play.tscn")
