extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# Character texture
	var texture_path = "res://assets/character" + str(Global.player["character"]) + "_1.png"
	$character.texture = load(texture_path)
	# Get level data
	var current_level = Global.current_level
	var level_data = Global.levels[current_level]
	# Level
	$level/number.text = str(level_data["id"])
	# Goal - [1] Gummy Bears
	if level_data["customer1"]["item_id"] == 1:
		$gummy_bears/Label.text = str(level_data["customer1"]["quantity"])
	elif level_data["customer2"]["item_id"] == 1:
		$gummy_bears/Label.text = str(level_data["customer2"]["quantity"])
	elif level_data["customer3"]["item_id"] == 1:
		$gummy_bears/Label.text = str(level_data["customer3"]["quantity"])
	# Goal - [2] Jelly Beans
	if level_data["customer1"]["item_id"] == 2:
		$jellies/Label.text = str(level_data["customer1"]["quantity"])
	elif level_data["customer2"]["item_id"] == 2:
		$jellies/Label.text = str(level_data["customer2"]["quantity"])
	elif level_data["customer3"]["item_id"] == 2:
		$jellies/Label.text = str(level_data["customer3"]["quantity"])
	# Goal - [3] Hard Candies
	if level_data["customer1"]["item_id"] == 3:
		$hard/Label.text = str(level_data["customer1"]["quantity"])
	elif level_data["customer2"]["item_id"] == 3:
		$hard/Label.text = str(level_data["customer2"]["quantity"])
	elif level_data["customer3"]["item_id"] == 3:
		$hard/Label.text = str(level_data["customer3"]["quantity"])
	# Goal - [4] Peppermint
	if level_data["customer1"]["item_id"] == 4:
		$peppermint/Label.text = str(level_data["customer1"]["quantity"])
	elif level_data["customer2"]["item_id"] == 4:
		$peppermint/Label.text = str(level_data["customer2"]["quantity"])
	elif level_data["customer3"]["item_id"] == 4:
		$peppermint/Label.text = str(level_data["customer3"]["quantity"])
	# Goal - [5] Gummy Worms
	if level_data["customer1"]["item_id"] == 5:
		$gummy_worms/Label.text = str(level_data["customer1"]["quantity"])
	elif level_data["customer2"]["item_id"] == 5:
		$gummy_worms/Label.text = str(level_data["customer2"]["quantity"])
	elif level_data["customer3"]["item_id"] == 5:
		$gummy_worms/Label.text = str(level_data["customer3"]["quantity"])
	# Goal - [6] Marshmallows
	if level_data["customer1"]["item_id"] == 6:
		$mashmallows/Label.text = str(level_data["customer1"]["quantity"])
	elif level_data["customer2"]["item_id"] == 6:
		$mashmallows/Label.text = str(level_data["customer2"]["quantity"])
	elif level_data["customer3"]["item_id"] == 6:
		$mashmallows/Label.text = str(level_data["customer3"]["quantity"])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Called once for every event before _unhandled_input(), allowing you to consume some events.
func _input(event):
	if event is InputEventAction and event.pressed:
		if event.action == "Play":
			await get_tree().create_timer(0.2).timeout # Godot to sleep
			get_tree().change_scene_to_file("res://scenes/play.tscn")
