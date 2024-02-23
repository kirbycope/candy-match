extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.enabled_music:
		$a_passing_interest.play()
		var texture_path = "res://assets/lose" + str(Global.character) + ".png"
		$character.texture = load(texture_path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event):
	if event is InputEventAction and event.pressed:
		if event.action == "Try":
			print("Try Again!")
