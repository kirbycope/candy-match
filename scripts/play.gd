extends Node2D


var candy1_matches = 0
var candy2_matches = 0
var candy3_matches = 0
var candy4_matches = 0
var candy5_matches = 0
var candy6_matches = 0
@onready var board = [$board/slot0, $board/slot1, $board/slot2, $board/slot3,
	$board/slot4,$board/slot5, $board/slot6, $board/slot7, $board/slot8,
	$board/slot9,$board/slot10, $board/slot11, $board/slot12, $board/slot13,
	$board/slot14, $board/slot15, $board/slot16, $board/slot17, $board/slot18,
	$board/slot19, $board/slot20, $board/slot21, $board/slot22, $board/slot23,
	$board/slot24, $board/slot25, $board/slot26, $board/slot27, $board/slot28,
	$board/slot29, $board/slot30, $board/slot31, $board/slot32, $board/slot33,
	$board/slot34, $board/slot35, $board/slot36, $board/slot37, $board/slot38,
	$board/slot39, $board/slot40, $board/slot41, $board/slot42, $board/slot43,
	$board/slot44, $board/slot45, $board/slot46, $board/slot47, $board/slot48]
var horizontal_matches = []
var vertical_matches = []


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.start_timer()
	populate_board()
	check_matches()
	remove_matches()
	if Global.enabled_music:
		$simple_pleasures.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Update timer label
	var minutes = int(Global.timer_time / 60)
	var seconds = int(Global.timer_time) % 60
	var format_string = "%01d:%02d"
	var actual_string = format_string % [minutes, seconds]
	$time/timer.text = actual_string
	# Handle timeout
	if Global.timer_time == 0:
		get_tree().change_scene_to_file("res://scenes/lose.tscn")


# Called each physics frame with the time since the last physics frame as argument (delta, in seconds).
func _physics_process(delta):
	pass


# Returns a path to a random candy texture.
func get_random_candy():
	# Assign a random candy (1-6)
	var randomNumber = randi() % 6 + 1
	# Set the texture for the candy at the current index of the board array.
	return "res://assets/candy" + str(randomNumber) + ".png"


# Populates the board, randomly.
func populate_board():
	for i in range(49): # (slot0-slot48)
		# Assign a random candy
		var texture_path = get_random_candy()
		board[i].texture = load(texture_path)


# Resets the `matches` array and adds any/all new matches.
func check_matches():
	horizontal_matches = []
	vertical_matches = []
	check_matches_horizontal()
	check_matches_vertical()


# Checks each row for matches.
func check_matches_horizontal():
	var index = 0
	for x in range(7):
		for y in range(7):
			var piece1 = "0"; var piece2 = "0"; var piece3 = "0"; var piece4 = "0"; var piece5 = "0"; var piece6 = "0"; var piece7 = "0"
			# Get the Piece ID for the given index of the board array
			piece1 = get_piece_id(index)
			# Get more IDs based on starting position
			if y < 6:
				piece2 = get_piece_id(index+1)
			if y < 5:
				piece3 = get_piece_id(index+2)
			if y < 4:
				piece4 = get_piece_id(index+3)
			if y < 3:
				piece5 = get_piece_id(index+4)
			if y < 2:
				piece6 = get_piece_id(index+5)
			if y < 1:
				piece7 = get_piece_id(index+6)
			# Check match permutations
			if piece1 == piece2 && piece2 == piece3 && piece3 == piece4 && piece4 == piece5 && piece5 == piece6 && piece6 == piece7:
				if index not in horizontal_matches:
					horizontal_matches += [index, index+1, index+2, index+3, index+4, index+5, index+6]
					if piece1 == "1":
						candy1_matches += 7
					if piece1 == "2":
						candy2_matches += 7
					if piece1 == "3":
						candy3_matches += 7
					if piece1 == "4":
						candy4_matches += 7
					if piece1 == "5":
						candy5_matches += 7
					if piece1 == "6":
						candy6_matches += 7
			elif piece1 == piece2 && piece2 == piece3 && piece3 == piece4 && piece4 == piece5 && piece5 == piece6:
				if index not in horizontal_matches:
					horizontal_matches += [index, index+1, index+2, index+3, index+4, index+5]
					if piece1 == "1":
						candy1_matches += 6
					if piece1 == "2":
						candy2_matches += 6
					if piece1 == "3":
						candy3_matches += 6
					if piece1 == "4":
						candy4_matches += 6
					if piece1 == "5":
						candy5_matches += 6
					if piece1 == "6":
						candy6_matches += 6
			elif piece1 == piece2 && piece2 == piece3 && piece3 == piece4 && piece4 == piece5:
				if index not in horizontal_matches:
					horizontal_matches += [index, index+1, index+2, index+3, index+4]
					if piece1 == "1":
						candy1_matches += 5
					if piece1 == "2":
						candy2_matches += 5
					if piece1 == "3":
						candy3_matches += 5
					if piece1 == "4":
						candy4_matches += 5
					if piece1 == "5":
						candy5_matches += 5
					if piece1 == "6":
						candy6_matches += 5
			elif piece1 == piece2 && piece2 == piece3 && piece3 == piece4:
				if index not in horizontal_matches:
					horizontal_matches += [index, index+1, index+2, index+3]
					if piece1 == "1":
						candy1_matches += 4
					if piece1 == "2":
						candy2_matches += 4
					if piece1 == "3":
						candy3_matches += 4
					if piece1 == "4":
						candy4_matches += 4
					if piece1 == "5":
						candy5_matches += 4
					if piece1 == "6":
						candy6_matches += 4
			elif piece1 == piece2 && piece2 == piece3:
				if index not in horizontal_matches:
					horizontal_matches += [index, index+1, index+2]
					if piece1 == "1":
						candy1_matches += 3
					if piece1 == "2":
						candy2_matches += 3
					if piece1 == "3":
						candy3_matches += 3
					if piece1 == "4":
						candy4_matches += 3
					if piece1 == "5":
						candy5_matches += 3
					if piece1 == "6":
						candy6_matches += 3
			index += 1


# Checks each column for matches.
func check_matches_vertical():
	for index in range(49):
		# Get the Piece ID for the given index of the board array
		var piece1 = "0"; var piece2 = "0"; var piece3 = "0"; var piece4 = "0"; var piece5 = "0"; var piece6 = "0"; var piece7 = "0"
		# Get the Piece ID for the given index of the board array
		piece1 = get_piece_id(index)
		# Get more IDs based on starting position
		if index + 7 < 49:
			piece2 = get_piece_id(index+7)
		if index + 14 < 49:
			piece3 = get_piece_id(index+14)
		if index + 21 < 49:
			piece4 = get_piece_id(index+21)
		if index + 28 < 49:
			piece5 = get_piece_id(index+28)
		if index + 35 < 49:
			piece6 = get_piece_id(index+35)
		if index + 42 < 49:
			piece7 = get_piece_id(index+42)
		# Check match permutations
		if piece1 == piece2 && piece2 == piece3 && piece3 == piece4 && piece4 == piece5 && piece5 == piece6 && piece6 == piece7:
			if index not in vertical_matches:
				vertical_matches += [index, index+7, index+14, index+21, index+28, index+35, index+42]
				if piece1 == "1":
					candy1_matches += 7
				if piece1 == "2":
					candy2_matches += 7
				if piece1 == "3":
					candy3_matches += 7
				if piece1 == "4":
					candy4_matches += 7
				if piece1 == "5":
					candy5_matches += 7
				if piece1 == "6":
					candy6_matches += 7
		elif piece1 == piece2 && piece2 == piece3 && piece3 == piece4 && piece4 == piece5 && piece5 == piece6:
			if index not in vertical_matches:
				vertical_matches += [index, index+7, index+14, index+21, index+28, index+35]
				if piece1 == "1":
					candy1_matches += 6
				if piece1 == "2":
					candy2_matches += 6
				if piece1 == "3":
					candy3_matches += 6
				if piece1 == "4":
					candy4_matches += 6
				if piece1 == "5":
					candy5_matches += 6
				if piece1 == "6":
					candy6_matches += 6
		elif piece1 == piece2 && piece2 == piece3 && piece3 == piece4 && piece4 == piece5:
			if index not in vertical_matches:
				vertical_matches += [index, index+7, index+14, index+21, index+28]
				if piece1 == "1":
					candy1_matches += 5
				if piece1 == "2":
					candy2_matches += 5
				if piece1 == "3":
					candy3_matches += 5
				if piece1 == "4":
					candy4_matches += 5
				if piece1 == "5":
					candy5_matches += 5
				if piece1 == "6":
					candy6_matches += 5
		elif piece1 == piece2 && piece2 == piece3 && piece3 == piece4:
			if index not in vertical_matches:
				vertical_matches += [index, index+7, index+14, index+21]
				if piece1 == "1":
					candy1_matches += 4
				if piece1 == "2":
					candy2_matches += 4
				if piece1 == "3":
					candy3_matches += 4
				if piece1 == "4":
					candy4_matches += 4
				if piece1 == "5":
					candy5_matches += 4
				if piece1 == "6":
					candy6_matches += 4
		elif piece1 == piece2 && piece2 == piece3:
			if index not in vertical_matches:
				vertical_matches += [index, index+7, index+14]
				if piece1 == "1":
					candy1_matches += 3
				if piece1 == "2":
					candy2_matches += 3
				if piece1 == "3":
					candy3_matches += 3
				if piece1 == "4":
					candy4_matches += 3
				if piece1 == "5":
					candy5_matches += 3
				if piece1 == "6":
					candy6_matches += 3


# Drop pieces into empty positions.
func drop_pieces():
	# Count down from 48 to 0
	for i in range(48, -1, -1):
		var node_path = "board/slot" + str(i)
		var current_node = get_node(node_path)
		if current_node.texture == null:
			var above_index = i - 7
			while above_index >= 0:
				var above_node_path = "board/slot" + str(above_index)
				var above_node = get_node(above_node_path)
				if above_node.texture != null:
					current_node.texture = above_node.texture
					above_node.texture = null  # Clear the above node
					break
				above_index -= 7  # Move to the node above

# Returns the Piece ID for the piece at the given index of the board array.
func get_piece_id(index):
	if index < len(board):
		var path = board[index].texture.get_path()
		path = path.replace("res://assets/candy", "")
		path = path.replace(".png", "")
		return path
	else:
		return "0"


# Remove matching pieces from the board using a tween.
func remove_matches():
	var matches = horizontal_matches + vertical_matches
	for i in range(len(matches)):
		var node_path = "board/slot" + str(matches[i])
		var node = get_node(node_path)
		if node:
			var tween = get_tree().create_tween()
			tween.tween_property(node, "modulate", Color.RED, 0.75)
			tween.tween_property(node, "scale", Vector2(), 0.75)
			#tween.tween_callback(node.queue_free)
			tween.tween_callback(remove_matches_callback)


# The callback function for the remove_matches() tween.
func remove_matches_callback():
	var matches = horizontal_matches + vertical_matches
	for i in range(len(matches)):
		board[matches[i]].texture = null
		board[matches[i]].modulate = $background1.modulate
		board[matches[i]].scale = Vector2(0.2, 0.2)
	# Clear so this only happens once
	horizontal_matches = []
	vertical_matches = []
	# DEBUGGING
	if matches:
		print("--------------")
		print("Gummy Bears: " + str(candy1_matches))
		print("Jelly Beans: " + str(candy2_matches))
		print("Hard Candy: " + str(candy3_matches))
		print("Peppermint: " + str(candy4_matches))
		print("Gummy Worms: " + str(candy5_matches))
		print("Marshmallows: " + str(candy6_matches))
		drop_pieces()
