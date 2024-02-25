extends Node2D


var candy1_matches = 0
var candy2_matches = 0
var candy3_matches = 0
var candy4_matches = 0
var candy5_matches = 0
var candy6_matches = 0
var customer1_desires_candy = 6 # marshmallows
var customer1_desires_quantity = 6
var customer1_fulfilled = false
var customer2_desires_candy = 4 # peppermints
var customer2_desires_quantity = 4
var customer2_fulfilled = false
var customer3_desires_candy = 5 # gummy worms
var customer3_desires_quantity = 3
var customer3_fulfilled = false
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
var level_complete = false
var matches_left_to_remove = 0
var moves = 20
var touch_start_position
var vertical_matches = []


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)
	populate_board()
	Global.start_timer()
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
	if level_complete and matches_left_to_remove == 0:
		get_tree().change_scene_to_file("res://scenes/won.tscn")
	if moves <= 0:
		get_tree().change_scene_to_file("res://scenes/lose.tscn")
	swap_pieces()
	drop_pieces()
	if check_for_empty_positions() == false:
		check_matches()
		remove_matches()
	customer_order_updates()


# Called once for every event before _unhandled_input(), allowing you to consume some events.
func _input(event):
	# Set the last touched piece
	if event is InputEventAction and event.pressed == false:
		var action = str(event.action)
		Global.piece_selected = int(action)
		# Handle `moves` count
		moves -= 1
		$top_moves/moves.text = str(moves)


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


# Returns true if there are empty board positions.
func check_for_empty_positions():
	for i in len(board):
		var node_path = "board/slot" + str(i)
		var node = get_node(node_path)
		if node.texture == null:
			return true
	return false


# Adds any/all new matches to the `matches` array.
func check_matches():
	check_matches_horizontal()
	check_matches_vertical()


# Checks each row for matches.
func check_matches_horizontal():
	var index = 0
	for x in range(7):
		for y in range(7):
			var piece1 = 0; var piece2 = 0; var piece3 = 0; var piece4 = 0; var piece5 = 0; var piece6 = 0; var piece7 = 0
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
					if piece1 == 1:
						candy1_matches += 7
					if piece1 == 2:
						candy2_matches += 7
					if piece1 == 3:
						candy3_matches += 7
					if piece1 == 4:
						candy4_matches += 7
					if piece1 == 5:
						candy5_matches += 7
					if piece1 == 6:
						candy6_matches += 7
			elif piece1 == piece2 && piece2 == piece3 && piece3 == piece4 && piece4 == piece5 && piece5 == piece6:
				if index not in horizontal_matches:
					horizontal_matches += [index, index+1, index+2, index+3, index+4, index+5]
					if piece1 == 1:
						candy1_matches += 6
					if piece1 == 2:
						candy2_matches += 6
					if piece1 == 3:
						candy3_matches += 6
					if piece1 == 4:
						candy4_matches += 6
					if piece1 == 5:
						candy5_matches += 6
					if piece1 == 6:
						candy6_matches += 6
			elif piece1 == piece2 && piece2 == piece3 && piece3 == piece4 && piece4 == piece5:
				if index not in horizontal_matches:
					horizontal_matches += [index, index+1, index+2, index+3, index+4]
					if piece1 == 1:
						candy1_matches += 5
					if piece1 == 2:
						candy2_matches += 5
					if piece1 == 3:
						candy3_matches += 5
					if piece1 == 4:
						candy4_matches += 5
					if piece1 == 5:
						candy5_matches += 5
					if piece1 == 6:
						candy6_matches += 5
			elif piece1 == piece2 && piece2 == piece3 && piece3 == piece4:
				if index not in horizontal_matches:
					horizontal_matches += [index, index+1, index+2, index+3]
					if piece1 == 1:
						candy1_matches += 4
					if piece1 == 2:
						candy2_matches += 4
					if piece1 == 3:
						candy3_matches += 4
					if piece1 == 4:
						candy4_matches += 4
					if piece1 == 5:
						candy5_matches += 4
					if piece1 == 6:
						candy6_matches += 4
			elif piece1 == piece2 && piece2 == piece3:
				if index not in horizontal_matches:
					horizontal_matches += [index, index+1, index+2]
					if piece1 == 1:
						candy1_matches += 3
					if piece1 == 2:
						candy2_matches += 3
					if piece1 == 3:
						candy3_matches += 3
					if piece1 == 4:
						candy4_matches += 3
					if piece1 == 5:
						candy5_matches += 3
					if piece1 == 6:
						candy6_matches += 3
			index += 1


# Checks each column for matches.
func check_matches_vertical():
	for index in range(49):
		# Get the Piece ID for the given index of the board array
		var piece1 = 0; var piece2 = 0; var piece3 = 0; var piece4 = 0; var piece5 = 0; var piece6 = 0; var piece7 = 0
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
				if piece1 == 1:
					candy1_matches += 7
				if piece1 == 2:
					candy2_matches += 7
				if piece1 == 3:
					candy3_matches += 7
				if piece1 == 4:
					candy4_matches += 7
				if piece1 == 5:
					candy5_matches += 7
				if piece1 == 6:
					candy6_matches += 7
		elif piece1 == piece2 && piece2 == piece3 && piece3 == piece4 && piece4 == piece5 && piece5 == piece6:
			if index not in vertical_matches:
				vertical_matches += [index, index+7, index+14, index+21, index+28, index+35]
				if piece1 == 1:
					candy1_matches += 6
				if piece1 == 2:
					candy2_matches += 6
				if piece1 == 3:
					candy3_matches += 6
				if piece1 == 4:
					candy4_matches += 6
				if piece1 == 5:
					candy5_matches += 6
				if piece1 == 6:
					candy6_matches += 6
		elif piece1 == piece2 && piece2 == piece3 && piece3 == piece4 && piece4 == piece5:
			if index not in vertical_matches:
				vertical_matches += [index, index+7, index+14, index+21, index+28]
				if piece1 == 1:
					candy1_matches += 5
				if piece1 == 2:
					candy2_matches += 5
				if piece1 == 3:
					candy3_matches += 5
				if piece1 == 4:
					candy4_matches += 5
				if piece1 == 5:
					candy5_matches += 5
				if piece1 == 6:
					candy6_matches += 5
		elif piece1 == piece2 && piece2 == piece3 && piece3 == piece4:
			if index not in vertical_matches:
				vertical_matches += [index, index+7, index+14, index+21]
				if piece1 == 1:
					candy1_matches += 4
				if piece1 == 2:
					candy2_matches += 4
				if piece1 == 3:
					candy3_matches += 4
				if piece1 == 4:
					candy4_matches += 4
				if piece1 == 5:
					candy5_matches += 4
				if piece1 == 6:
					candy6_matches += 4
		elif piece1 == piece2 && piece2 == piece3:
			if index not in vertical_matches:
				vertical_matches += [index, index+7, index+14]
				if piece1 == 1:
					candy1_matches += 3
				if piece1 == 2:
					candy2_matches += 3
				if piece1 == 3:
					candy3_matches += 3
				if piece1 == 4:
					candy4_matches += 3
				if piece1 == 5:
					candy5_matches += 3
				if piece1 == 6:
					candy6_matches += 3


func customer_order_requests():
	var desired1_texture = "res://assets/candy" + str(customer1_desires_candy) + ".png"
	$customer1/desired.texture = load("desired1_texture")


func customer_order_updates():
	# Customer 1
	var customer1_remaining = customer1_desires_quantity
	if customer1_desires_candy == 1:
		customer1_remaining -= candy1_matches
	if customer1_desires_candy == 2:
		customer1_remaining -= candy2_matches
	if customer1_desires_candy == 3:
		customer1_remaining -= candy3_matches
	if customer1_desires_candy == 4:
		customer1_remaining -= candy4_matches
	if customer1_desires_candy == 5:
		customer1_remaining -= candy5_matches
	if customer1_desires_candy == 6:
		customer1_remaining -= candy6_matches
	if customer1_remaining > 0:
		$customer1/count.text = str(customer1_remaining)
	else:
		$customer1/count.text = "0"
	# Customer 2
	var customer2_remaining = customer2_desires_quantity
	if customer2_desires_candy == 1:
		customer2_remaining -= candy1_matches
	if customer2_desires_candy == 2:
		customer2_remaining -= candy2_matches
	if customer2_desires_candy == 3:
		customer2_remaining -= candy3_matches
	if customer2_desires_candy == 4:
		customer2_remaining -= candy4_matches
	if customer2_desires_candy == 5:
		customer2_remaining -= candy5_matches
	if customer2_desires_candy == 6:
		customer2_remaining -= candy6_matches
	if customer2_remaining > 0:
		$customer2/count.text = str(customer2_remaining)
	else:
		$customer2/count.text = "0"
	# Cusommer 3
	var customer3_remaining = customer3_desires_quantity
	if customer3_desires_candy == 1:
		customer3_remaining -= candy1_matches
	if customer3_desires_candy == 2:
		customer3_remaining -= candy2_matches
	if customer3_desires_candy == 3:
		customer3_remaining -= candy3_matches
	if customer3_desires_candy == 4:
		customer3_remaining -= candy4_matches
	if customer3_desires_candy == 5:
		customer3_remaining -= candy5_matches
	if customer3_desires_candy == 6:
		customer3_remaining -= candy6_matches
	if customer3_remaining > 0:
		$customer3/count.text = str(customer3_remaining)
	else:
		$customer3/count.text = "0"
	if customer1_fulfilled == false and customer1_remaining <= 0:
		customer1_fulfilled = true
		$marimba_bloop_3.play()
	if customer2_fulfilled == false and customer2_remaining <= 0:
		customer2_fulfilled = true
		$marimba_bloop_3.play()
	if customer3_fulfilled == false and customer3_remaining <= 0:
		customer3_fulfilled = true
		$marimba_bloop_3.play()
	if (customer1_fulfilled
	and customer2_fulfilled
	and customer3_fulfilled):
		level_complete = true


# Drop pieces into empty positions.
func drop_pieces():
	if matches_left_to_remove == 0:
		horizontal_matches = []
		vertical_matches = []
		for i in range(48, -1, -1):
			var node_path = "board/slot" + str(i)
			var current_node = get_node(node_path)
			if current_node.texture == null:
				if i < 7:
					var texture_path = get_random_candy()
					current_node.texture = load(texture_path)
				else:
					var above_index = i - 7
					var above_node_path = "board/slot" + str(above_index)
					var above_node = get_node(above_node_path)
					if above_node.texture != null:
						current_node.texture = above_node.texture
						above_node.texture = null


# Returns the Piece ID for the piece at the given index of the board array.
func get_piece_id(index):
	var id = 0
	if index < len(board):
		var piece_texture = board[index].texture
		if piece_texture:
			var path = piece_texture.get_path()
			path = path.replace("res://assets/candy", "")
			path = path.replace(".png", "")
			id = int(path)
	return id


# Remove matching pieces from the board using a tween.
func remove_matches():
	var matches = horizontal_matches + vertical_matches
	for i in range(len(matches)):
		if matches[i] < len(board):
			var node_path = "board/slot" + str(matches[i])
			var node = get_node(node_path)
			if node:
				var tree = get_tree()
				if tree:
					var tween = tree.create_tween()
					tween.tween_property(node, "modulate", Color.RED, 0.75)
					tween.tween_property(node, "scale", Vector2(), 0.75)
					tween.tween_callback(remove_matches_callback)
					matches_left_to_remove += 1
	# Play sound only on first match
	if (matches_left_to_remove == 9
	or matches_left_to_remove == 12
	or matches_left_to_remove == 15):
		if not $multi_pop_6.is_playing():
			$multi_pop_6.play()


# The callback function for the remove_matches() tween.
func remove_matches_callback():
	var matches = horizontal_matches + vertical_matches
	for i in range(len(matches)):
		if matches[i] < len(board):
			board[matches[i]].texture = null
			board[matches[i]].modulate = $background1.modulate
			board[matches[i]].scale = Vector2(0.2, 0.2)
	matches_left_to_remove -= 1


# Swap the selected piece with the adjacent one basedon swipe direction.
func swap_pieces():
	# Ensure a piece has been swiped on
	if Global.piece_selected != null and Global.swipe_direction != null:
		var next_node_path = null
		var next_node = null
		var swap_node = null
		# Get the swiped on piece
		var selected_node_path = "board/slot" + str(Global.piece_selected)
		var selected_node = get_node(selected_node_path)
		# Check swipe direction
		if (Global.swipe_direction == Vector2.DOWN
		and Global.piece_selected + 7 < len(board)):
			next_node_path = "board/slot" + str(Global.piece_selected+7)
		if (Global.swipe_direction == Vector2.LEFT
		and Global.piece_selected - 1 >= 0):
			next_node_path = "board/slot" + str(Global.piece_selected-1)
		elif (Global.swipe_direction == Vector2.RIGHT
		and Global.piece_selected + 1 <len(board)):
			next_node_path = "board/slot" + str(Global.piece_selected+1)
		elif (Global.swipe_direction == Vector2.UP
		and Global.piece_selected - 7 >= 0):
			next_node_path = "board/slot" + str(Global.piece_selected-7)
		# Get adjacent piece
		if next_node_path:
			next_node = get_node(next_node_path)
			# Continue if a piece was found
			if next_node:
				# Store the original texture
				var swap_node_texture = selected_node.texture
				# Set the selected piece's texture as the adjacent one's
				selected_node.texture = next_node.texture
				# Set the adjecent piece's texture as the original one
				next_node.texture = swap_node_texture
		# Clear so this only runs once
		Global.piece_selected = null
		Global.swipe_direction = null
