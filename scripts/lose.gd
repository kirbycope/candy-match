extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.enabled_music:
		$a_passing_interest.play()
	var texture_path = "res://assets/lose" + str(Global.player["character"]) + ".png"
	$character.texture = load(texture_path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Called once for every event before _unhandled_input(), allowing you to consume some events.
func _input(event):
	if event is InputEventAction and event.pressed:
		if event.action == "Try":
			await get_tree().create_timer(0.2).timeout # Godot to sleep
			get_tree().change_scene_to_file("res://scenes/play.tscn")
