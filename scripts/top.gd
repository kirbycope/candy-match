extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Called each physics frame with the time since the last physics frame as argument (delta, in seconds).
func _physics_process(delta):
	$coins/Label.text = str(Global.player["coins"])


# Called once for every event before _unhandled_input(), allowing you to consume some events.
func _input(event):
	var scene = get_tree().current_scene
	if event is InputEventAction and event.pressed:
		if event.action == "Close":
			if not shoppette_hide():
				var path = str(get_tree().current_scene.get_path())
				if path != "/root/main":
					await get_tree().create_timer(0.2).timeout # Godot to sleep
					get_tree().change_scene_to_file("res://scenes/main.tscn")
		elif event.action == "Shoppette":
			if str(scene.get_path()) == "/root/main":
				scene.shop_open()
			else:
				shoppette_display()


func shoppette_display():
	var node_path = "../shoppette"
	var node = get_tree().current_scene.get_node(node_path)
	if node == null:
		var scene_instance = load("res://scenes/shoppette.tscn")
		scene_instance = scene_instance.instantiate()
		var root_node = get_tree().get_root()
		root_node.add_child(scene_instance)
	else:
		shoppette_hide()


# Returns true if the shoppette scene is removed as a result of running this function.
func shoppette_hide():
	var node_path = "../shoppette"
	var node = get_tree().current_scene.get_node(node_path)
	if node:
		var root_node = get_tree().get_root()
		root_node.remove_child(node)
		return true
	return false
