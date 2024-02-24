extends Node2D


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
var matches = []


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
	if(board[0].texture == null
	or board[7].texture == null
	or board[14].texture == null
	or board[21].texture == null
	or board[28].texture == null
	or board[35].texture == null
	or board[42].texture == null):
		print("Column 0")
	if(board[1].texture == null
	or board[8].texture == null
	or board[15].texture == null
	or board[22].texture == null
	or board[29].texture == null
	or board[36].texture == null
	or board[43].texture == null):
		print("Column 1")
	if(board[2].texture == null
	or board[9].texture == null
	or board[16].texture == null
	or board[23].texture == null
	or board[30].texture == null
	or board[37].texture == null
	or board[44].texture == null):
		print("Column 2")
	if(board[3].texture == null
	or board[10].texture == null
	or board[17].texture == null
	or board[24].texture == null
	or board[31].texture == null
	or board[38].texture == null
	or board[45].texture == null):
		print("Column 3")
	if(board[4].texture == null
	or board[11].texture == null
	or board[18].texture == null
	or board[25].texture == null
	or board[32].texture == null
	or board[39].texture == null
	or board[46].texture == null):
		print("Column 4")
	if(board[5].texture == null
	or board[12].texture == null
	or board[19].texture == null
	or board[26].texture == null
	or board[33].texture == null
	or board[40].texture == null
	or board[47].texture == null):
		print("Column 5")
	if(board[6].texture == null
	or board[13].texture == null
	or board[20].texture == null
	or board[27].texture == null
	or board[34].texture == null
	or board[41].texture == null
	or board[48].texture == null):
		print("Column 6")


# The callback function for the remove_matches() animation.
func clear_callback():
	for i in range(len(matches)):
		board[matches[i]].texture = null
		board[matches[i]].modulate = $background1.modulate
		board[matches[i]].scale = Vector2(0.2, 0.2)
	matches = []


# Populates the board, randomly.
func populate_board():
	for i in range(49): # (slot0-slot48)
		# Assign a random candy (1-6)
		var randomNumber = randi() % 6 + 1
		# Set the texture for the candy at the current index of the board array.
		board[i].texture = load("res://assets/candy" + str(randomNumber) + ".png")


# Resets the `matches` array and adds any/all new matches.
func check_matches():
	matches = []
	# Index for slot0-slot48
	var index = 0
	# Scan horizontally (Rows 1-7)
	for x in range(7):
		# Scan horizontally (Positions 1-7)
		for y in range(7):
			# Reset pieces (Reece's pieces...yum)
			var piece1 = "0"; var piece2 = "0"; var piece3 = "0"; var piece4 = "0"; var piece5 = "0"; var piece6 = "0"; var piece7 = "0"
			# Get the Piece ID for the given index of the board array
			piece1 = get_piece_id(index)
			# Get more IDs based on starting position
			if y < 6:
				piece2 = get_piece_id(index+1)
			if y < 5 :
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
				matches += [index, index+1, index+2, index+3, index+4, index+5, index+6]
			elif piece1 == piece2 && piece2 == piece3 && piece3 == piece4 && piece4 == piece5 && piece5 == piece6:
				if index not in matches:
					matches += [index, index+1, index+2, index+3, index+4, index+5]
			elif piece1 == piece2 && piece2 == piece3 && piece3 == piece4 && piece4 == piece5:
				if index not in matches:
					matches += [index, index+1, index+2, index+3, index+4]
			elif piece1 == piece2 && piece2 == piece3 && piece3 == piece4:
				if index not in matches:
					matches += [index, index+1, index+2, index+3]
			elif piece1 == piece2 && piece2 == piece3:
				if index not in matches:
					matches += [index, index+1, index+2]
			index += 1


# Returns the Piece ID for the piece at the given index of the board array.
func get_piece_id(index):
	if index < len(board):
		var path = board[index].texture.get_path()
		path = path.replace("res://assets/candy", "")
		path = path.replace(".png", "")
		return path
	else:
		return "0"


func print_candy_name(id):
	if (id == "1"): print("Gummy Bears")
	elif (id == "2"): print("Jelly Beans")
	elif (id == "3"): print("Hard Candy")
	elif (id == "4"): print("Peppermint")
	elif (id == "5"): print("Gummy Worms")
	elif (id == "6"): print("Marshmallows")


func remove_matches():
	for i in range(len(matches)):
		var node_path = "board/slot" + str(matches[i])
		var node = get_node(node_path)
		if node:
			var tween = get_tree().create_tween()
			tween.tween_property(node, "modulate", Color.RED, 1)
			tween.tween_property(node, "scale", Vector2(), 1)
			#tween.tween_callback(node.queue_free)
			tween.tween_callback(clear_callback)
