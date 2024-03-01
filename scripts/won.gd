extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.enabled_music: $race_to_the_finish.play()
	var texture_path = "res://assets/won" + str(Global.player["character"]) + ".png"
	$character.texture = load(texture_path)
	var level_complete = "level_" + str(Global.current_level) + "_complete"
	Global.player[level_complete] = true
	Global.current_level += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Called once for every event before _unhandled_input(), allowing you to consume some events.
func _input(event):
	if event is InputEventAction and event.pressed:
		if event.action == "Next":
			await get_tree().create_timer(0.2).timeout # Godot to sleep
			get_tree().change_scene_to_file("res://scenes/goal.tscn")
