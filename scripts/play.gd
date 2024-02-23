extends Node2D


@onready var board = [$board/slot1, $board/slot2, $board/slot3, $board/slot4,
	$board/slot5, $board/slot6, $board/slot7, $board/slot8, $board/slot9,
	$board/slot10, $board/slot11, $board/slot12, $board/slot13, $board/slot14,
	$board/slot15, $board/slot16, $board/slot17, $board/slot18, $board/slot19,
	$board/slot20, $board/slot21, $board/slot22, $board/slot23, $board/slot24,
	$board/slot25, $board/slot26, $board/slot27, $board/slot28, $board/slot29,
	$board/slot30, $board/slot31, $board/slot32, $board/slot33, $board/slot34,
	$board/slot35, $board/slot36, $board/slot37, $board/slot38, $board/slot39,
	$board/slot40, $board/slot41, $board/slot42, $board/slot43, $board/slot44,
	$board/slot45, $board/slot46, $board/slot47, $board/slot48, $board/slot49]


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	populate_board()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass # Replace with function body.


func _input(event):
	if event is InputEventAction and event.pressed:
		if event.action == "Main":
			get_tree().change_scene_to_file("res://scenes/main.tscn")


# Populates the board, randomly.
func populate_board():
	for i in range(49):
		var randomNumber = randi() % 6 + 1
		board[i].texture = load("res://assets/candy" + str(randomNumber) + ".png")
	clear_matches()


func clear_matches():
	var index = 0
	# Scan horizontally (Rows 1-7)
	for x in range(1,8):
		# Scan horizontally (Positions 1-7)
		for y in range(1,8):
			var piece1 = "0"
			var piece2 = "0"
			var piece3 = "0"
			var piece4 = "0"
			var piece5 = "0"
			var piece6 = "0"
			var piece7 = "0"
			# Get the piece(s)
			piece1 = get_piece_id(index)
			if y < 7:
				piece2 = get_piece_id(index+1)
			if y < 6 :
				piece3 = get_piece_id(index+2)
			if y < 5:
				piece4 = get_piece_id(index+3)
			if y < 4:
				piece5 = get_piece_id(index+4)
			if y < 3:
				piece6 = get_piece_id(index+5)
			if y < 2:
				piece7 = get_piece_id(index+6)
			# Check match permutations
			if piece1 == piece2 && piece2 == piece3 && piece3 == piece4 && piece4 == piece5 && piece5 == piece6 && piece6 == piece7:
				print("Match 7!")
			elif piece1 == piece2 && piece2 == piece3 && piece3 == piece4 && piece4 == piece5 && piece5 == piece6:
				print("Match 6!")
			elif piece1 == piece2 && piece2 == piece3 && piece3 == piece4 && piece4 == piece5:
				print("Match 5!")
			elif piece1 == piece2 && piece2 == piece3 && piece3 == piece4:
				print("Match 4!")
			elif piece1 == piece2 && piece2 == piece3:
				print("Match 3!")
				highlight_match(index+1)
				highlight_match(index+2)
				highlight_match(index+3)
			index += 1


func get_piece_id(index):
	if index < len(board):
		var path = board[index].texture.get_path()
		path = path.replace("res://assets/candy", "")
		path = path.replace(".png", "")
		return path
	else:
		return 0


func print_candy_name(id):
	if (id == "1"): print("Gummy Bears")
	elif (id == "2"): print("Jelly Beans")
	elif (id == "3"): print("Hard Candy")
	elif (id == "4"): print("Peppermint")
	elif (id == "5"): print("Gummy Worms")
	elif (id == "6"): print("Marshmallows")


func highlight_match(index):
	var modulate_color = Color(1, 0.5, 0.5, 1)
	var node_path = "board/slot" + str(index)
	var node = get_node(node_path)
	node.modulate = modulate_color
