extends Node2D


var bomb_positions = []
var candies_to_serve = 0
var candy1_matches = 0
var candy2_matches = 0
var candy3_matches = 0
var candy4_matches = 0
var candy5_matches = 0
var candy6_matches = 0
var cheat_item_bomb_active = false
var cheat_item_milk_active = false
var cheat_item_sugar_active = false
var cheat_item_switch_active = false
var customer1_id = 0
var customer1_desires_candy = 0
var customer1_desires_quantity = 0
var customer1_fulfilled = false
var customer2_id = 0
var customer2_desires_candy = 0
var customer2_desires_quantity = 0
var customer2_fulfilled = false
var customer3_id = 0
var customer3_desires_candy = 0
var customer3_desires_quantity = 0
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
var matches_being_tweened = []
var matches_left_to_remove = 0
var moves = 20
var pieces_to_remove = 0
var touch_start_position
var tutorial = 0
var vertical_matches = []


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)
	# Get level data
	var level_data = Global.levels[Global.current_level]
	# Customer 1
	customer1_id = level_data["customer1"]["character_id"]
	var character_1 = "res://assets/character" + str(customer1_id) + "_1.png"
	$customer1/character.texture = load(character_1)
	customer1_desires_candy = level_data["customer1"]["item_id"]
	var desired_1 = "res://assets/candy"+ str(customer1_desires_candy) + ".png"
	$customer1/desired.texture = load(desired_1)
	customer1_desires_quantity = level_data["customer1"]["quantity"]
	# Customer 2
	customer2_id = level_data["customer2"]["character_id"]
	var character_2 = "res://assets/character" + str(customer2_id) + "_1.png"
	$customer2/character.texture = load(character_2)
	customer2_desires_candy = level_data["customer2"]["item_id"]
	var desired_2 = "res://assets/candy"+ str(customer2_desires_candy) + ".png"
	$customer2/desired.texture = load(desired_2)
	customer2_desires_quantity = level_data["customer2"]["quantity"]
	# Customer 3
	customer3_id = level_data["customer3"]["character_id"]
	var character_3 = "res://assets/character" + str(customer3_id) + "_1.png"
	$customer3/character.texture = load(character_3)
	customer3_desires_candy = level_data["customer3"]["item_id"]
	var desired_3 = "res://assets/candy"+ str(customer3_desires_candy) + ".png"
	$customer3/desired.texture = load(desired_3)
	customer3_desires_quantity = level_data["customer3"]["quantity"]
	# Bomb
	$bomb.visible = level_data["bombs_allowed"]
	# Sugar
	$sugar.visible = level_data["sugars_allowed"]
	# Switch
	$switch.visible = level_data["switches_allowed"]
	# Milk
	$milk.visible = level_data["milks_allowed"]
	# Fill the board with random pieces
	populate_board()
	# Start the game timer
	Global.start_timer()
	# Show the tutorial if player is on level 0
	if Global.current_level == 0:
		tutorial = 1
		show_tutorial()
	elif Global.current_level == 1:
		tutorial = 2
		show_tutorial()
	# Queue the music
	if Global.enabled_music: $simple_pleasures.play()


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
	$coins/counter.text = str(Global.player["coins"])
	$bomb/count/Label.text = str(Global.player["bombs"])
	$bomb/count.visible = Global.player["bombs"] > 0
	$sugar/count/Label.text = str(Global.player["sugars"])
	$sugar/count.visible = Global.player["sugars"] > 0
	$switch/count/Label.text = str(Global.player["switches"])
	$switch/count.visible = Global.player["switches"] > 0
	$milk/count/Label.text = str(Global.player["milks"])
	$milk/count.visible = Global.player["milks"] > 0
	if (level_complete
	and candies_to_serve == 0
	and matches_left_to_remove == 0
	and pieces_to_remove == 0):
		Global.player["level_" + str(Global.current_level) + "_complete"] = true
		get_tree().change_scene_to_file("res://scenes/won.tscn")
	if (moves <= 0
	and candies_to_serve == 0
	and matches_left_to_remove == 0
	and pieces_to_remove == 0):
		get_tree().change_scene_to_file("res://scenes/lose.tscn")
	if tutorial == 0:
		swap_pieces()
		drop_pieces()
		if check_for_empty_positions() == false:
			check_matches_horizontal()
			check_matches_vertical()
			remove_matches()
	customer_order_updates()


# Called once for every event before _unhandled_input(), allowing you to consume some events.
func _input(event):
	if event is InputEventAction and event.pressed:
		# Advance tutorial
		show_tutorial()
		# Cheat items
		if event.action == "Bomb":
			cheat_item_bomb()
		elif event.action == "Milk":
			cheat_item_milk()
		elif event.action == "Sugar":
			cheat_item_sugar()
		elif event.action == "Switch":
			cheat_item_switch()
	# Set the last touched piece
	if event is InputEventAction and event.pressed == false:
		var action = str(event.action)
		Global.piece_selected = int(action)
		# Activate the bomb
		if (action != "Bomb" and action !="Milk"
		and action != "Sugar" and action !="Switch"
		and cheat_item_bomb_active
		and Global.player["bombs"] > 0):
			cheat_item_bomb_activate(Global.piece_selected)
		# Activate the milk
		if (action != "Bomb" and action !="Milk"
		and action != "Sugar" and action !="Switch"
		and cheat_item_milk_active
		and Global.player["milks"] > 0):
			cheat_item_milk_activate(Global.piece_selected)
		# Activate the sugar
		if (action != "Bomb" and action !="Milk"
		and action != "Sugar" and action !="Switch"
		and cheat_item_sugar_active
		and Global.player["sugars"] > 0):
			cheat_item_sugar_activate(Global.piece_selected)
		# Activate the switch
		if (action != "Bomb" and action !="Milk"
		and action != "Sugar" and action !="Switch"
		and cheat_item_switch_active
		and Global.player["switches"] > 0):
			cheat_item_switch_activate(Global.piece_selected)


# Function to add bomb positions to the array
func add_bomb_position(index):
	var grid_size = 7
	var grid_length = grid_size * grid_size
	if index not in bomb_positions and index >= 0 and index < grid_length:
		# Add the bomb position
		bomb_positions.append(index)
		# Determine the row and column of the selected position
		var row = index / grid_size
		var col = index % grid_size
		# Check neighboring positions and add them to the bomb positions array
		add_neighbor(row - 1, col)  # Top
		add_neighbor(row + 1, col)  # Bottom
		add_neighbor(row, col - 1)  # Left
		add_neighbor(row, col + 1)  # Right


# Function to add neighboring positions
func add_neighbor(row, col):
	var grid_size = 7
	var grid_length = grid_size * grid_size
	if row >= 0 and row < grid_size and col >= 0 and col < grid_size:
		var neighbor_position = row * grid_size + col
		if neighbor_position not in bomb_positions and neighbor_position >= 0 and neighbor_position < grid_length:
			bomb_positions.append(neighbor_position)


# Toggles the bomb cheat item in the UI.
func cheat_item_bomb():
	if Global.player["bombs"] > 0:
		cheat_item_bomb_active = not cheat_item_bomb_active
		if cheat_item_bomb_active:
			$bomb.scale = Vector2(1.2, 1.2)
		else:
			$bomb.scale = Vector2(1.0, 1.0)
	else:
		$bomb.scale = Vector2(1.0, 1.0)


# Activate the bomb cheat item at the selected piece's position.
func cheat_item_bomb_activate(piece_selected):
	Global.player["bombs"] -= 1
	$oddworld_bomb.play()
	# Get the selected position and the surrounding postions
	add_bomb_position(piece_selected)
	# Toggle the cheat item in the UI
	cheat_item_bomb()
	# Animate the piece being removed from the board
	for index in len(bomb_positions):
		var node_path = "board/slot" + str(bomb_positions[index])
		var node = get_node(node_path)
		var tween = get_tree().create_tween()
		tween.tween_property(node, "modulate", Color.RED, 1).set_trans(Tween.TRANS_SINE)
		tween.tween_property(node, "scale", Vector2(), 1).set_trans(Tween.TRANS_BOUNCE)
		tween.tween_callback(remove_piece_callback)
		pieces_to_remove += 1


# Toggles the bomb cheat item in the UI.
func cheat_item_milk():
	if Global.player["milks"] > 0:
		cheat_item_milk_active = not cheat_item_milk_active
		if cheat_item_milk_active:
			$milk.scale = Vector2(1.2, 1.2)
		else:
			$milk.scale = Vector2(1.0, 1.0)
	else:
		$milk.scale = Vector2(1.0, 1.0)


# Activate the milk cheat item at the selected piece's position.
func cheat_item_milk_activate(piece_selected):
	Global.player["milks"] -= 1
	$splattt.play()


# Toggles the sugar cheat item in the UI.
func cheat_item_sugar():
	if Global.player["sugars"] > 0:
		cheat_item_sugar_active = not cheat_item_sugar_active
		if cheat_item_sugar_active:
			$sugar.scale = Vector2(1.2, 1.2)
		else:
			$sugar.scale = Vector2(1.0, 1.0)
	else:
		$sugar.scale = Vector2(1.0, 1.0)


# Activate the sugar cheat item at the selected piece's position.
func cheat_item_sugar_activate(piece_selected):
	Global.player["sugars"] -= 1


# Toggles the switch cheat item in the UI.
func cheat_item_switch():
	if Global.player["switches"] > 0:
		cheat_item_switch_active = not cheat_item_switch_active
		if cheat_item_switch_active:
			$switch.scale = Vector2(1.2, 1.2)
		else:
			$switch.scale = Vector2(1.0, 1.0)
	else:
		$switch.scale = Vector2(1.0, 1.0)


# Activate the switch cheat item at the selected piece's position.
func cheat_item_switch_activate(piece_selected):
	Global.player["switches"] -= 1


# Returns true if there are empty board positions.
func check_for_empty_positions():
	for i in len(board):
		var node_path = "board/slot" + str(i)
		var node = get_node(node_path)
		if node.texture == null:
			return true
	return false


# Checks each row for matches.
func check_matches_horizontal():
	var index = 0
	# For each row
	for x in range(7):
		# Each column
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
			# Check for 7 match
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
			# Check for 6 match
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
			# Check for 5 match
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
			# Check for 4 match
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
			# Check for 3 match
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
			# Increment the index
			index += 1


# Checks each column for matches.
func check_matches_vertical():
	# Check each of the 49 positions
	for index in range(49):
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
		# Check for 7 match
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
		# Check for 6 match
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
		# Check for 5 match
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
		# Check for 4 match
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
		# Check for 3 match
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


# Updates each customer request quantity in the UI.
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
		if Global.enabled_sound: $marimba_bloop_3.play()
	if customer2_fulfilled == false and customer2_remaining <= 0:
		customer2_fulfilled = true
		if Global.enabled_sound: $marimba_bloop_3.play()
	if customer3_fulfilled == false and customer3_remaining <= 0:
		customer3_fulfilled = true
		if Global.enabled_sound: $marimba_bloop_3.play()
	if (customer1_fulfilled
	and customer2_fulfilled
	and customer3_fulfilled):
		level_complete = true


# Drop pieces into empty positions.
func drop_pieces():
	if matches_left_to_remove == 0 and pieces_to_remove == 0:
		bomb_positions = []
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


# Plays a random "cute animal squeak" (if it is not already playing).
func random_excited_effect():
	if Global.enabled_sound:
		# Assign a random sound (1-5)
		var randomNumber = randi() % 5 + 1
		if randomNumber == 1:
			if not $cute_animal_squeak_1.is_playing():
				$cute_animal_squeak_1.play()
		if randomNumber == 2:
			if not $cute_animal_squeak_2.is_playing():
				$cute_animal_squeak_2.play()
		if randomNumber == 3:
			if not $cute_animal_squeak_3.is_playing():
				$cute_animal_squeak_3.play()
		if randomNumber == 4:
			if not $cute_animal_squeak_4.is_playing():
				$cute_animal_squeak_4.play()
		if randomNumber == 5:
			if not $cute_animal_squeak_5.is_playing():
				$cute_animal_squeak_5.play()


# Remove matching pieces from the board using a tween.
func remove_matches():
	var customer1_excited = false
	var customer2_excited = false
	var customer3_excited = false
	# Check both sets of matches
	var matches = horizontal_matches + vertical_matches
	for i in range(len(matches)):
		# Check that the match is in range of the board
		if matches[i] < len(board):
			# Check that we aren't in the process of removing the piece
			if matches[i] not in matches_being_tweened:
				var node_path = "board/slot" + str(matches[i])
				var node = get_node(node_path)
				# Check a piece exists
				if node:
					# Check we aren't changing scenes
					var tree = get_tree()
					if tree:
						var tween = tree.create_tween()
						# The customer is excited
						if get_piece_id(matches[i]) == customer1_desires_candy:
							var texture_path = "res://assets/won"+ str(customer1_id) + ".png"
							$customer1/character.texture = load(texture_path)
							customer1_excited = true
							serve_candy(node, customer1_desires_candy, $bowl1)
							# Animate removing the piece
							tween.tween_property(node, "visible", false, 0.0)
							tween.tween_property(node, "visible", false, 0.75) # creates a slight delay
						elif get_piece_id(matches[i]) == customer2_desires_candy:
							var texture_path = "res://assets/won"+ str(customer2_id) + ".png"
							$customer2/character.texture = load(texture_path)
							customer2_excited = true
							serve_candy(node, customer2_desires_candy, $bowl2)
							# Animate removing the piece
							tween.tween_property(node, "visible", false, 0.0)
							tween.tween_property(node, "visible", false, 0.75) # creates a slight delay
						elif get_piece_id(matches[i]) == customer3_desires_candy:
							var texture_path = "res://assets/won"+ str(customer3_id) + ".png"
							$customer3/character.texture = load(texture_path)
							customer3_excited = true
							serve_candy(node, customer3_desires_candy, $bowl3)
							# Animate removing the piece
							tween.tween_property(node, "visible", false, 0.0)
							tween.tween_property(node, "visible", false, 0.75) # creates a slight delay
						else:
							# Animate removing the piece
							tween.tween_property(node, "modulate", Color.RED, 0.75)
							tween.tween_property(node, "scale", Vector2(), 0.75)
						tween.tween_callback(remove_matches_callback)
						matches_being_tweened += [matches[i]]
						matches_left_to_remove += 1
						# Play clear candy sound
						if not $multi_pop_6.is_playing():
							if Global.enabled_sound: $multi_pop_6.play()
	if customer1_excited:
		random_excited_effect()
	if customer2_excited:
		random_excited_effect()
	if customer3_excited:
		random_excited_effect()


# The callback function for when a piece is removed (via Tween).
func remove_piece_callback():
	for i in len(bomb_positions):
		if bomb_positions[i] < len(board):
			board[bomb_positions[i]].texture = null
			board[bomb_positions[i]].modulate = $background1.modulate
			board[bomb_positions[i]].scale = Vector2(0.2, 0.2)
	pieces_to_remove -= 1


# Moves matched candy to the customer's bowl.
func serve_candy(matched_piece, piece_id, bowl):
	# Create a copy at the current piece's position
	var sprite = Sprite2D.new()
	sprite.position = matched_piece.global_position
	sprite.scale = Vector2(0.08, 0.08)
	sprite.texture = load("res://assets/candy" + str(piece_id) + ".png")
	get_parent().add_child(sprite)
	# Animate moving the piece
	var tween = get_tree().create_tween()
	var bowl_position = bowl.global_position + Vector2(0, -10)
	tween.tween_property(sprite, "scale", Vector2(0.05, 0.05), 0.75)
	tween.tween_property(sprite, "position", bowl_position, 0.75)
	tween.tween_callback(serve_candy_callback)
	candies_to_serve += 1


func serve_candy_callback():
	candies_to_serve -= 1


# The callback function for the remove_matches() tween.
func remove_matches_callback():
	# Reset each board position that was tweened
	var matches = horizontal_matches + vertical_matches
	for i in len(matches):
		if matches[i] < len(board):
			board[matches[i]].texture = null
			board[matches[i]].modulate = $background1.modulate
			board[matches[i]].scale = Vector2(0.2, 0.2)
			board[matches[i]].visible = true
	matches_left_to_remove -= 1
	remove_tween_tracker()
	# Settle the customer(s)
	var texture_path = "res://assets/character"+ str(customer1_id) + "_1.png"
	$customer1/character.texture = load(texture_path)
	texture_path = "res://assets/character"+ str(customer2_id) + "_1.png"
	$customer2/character.texture = load(texture_path)
	texture_path = "res://assets/character"+ str(customer3_id) + "_1.png"
	$customer3/character.texture = load(texture_path)


# Resets the Tween tracker if there are no matches being tweened.
func remove_tween_tracker():
	var matches = horizontal_matches + vertical_matches
	for i in range(len(matches_being_tweened)):
		for j in range(len(matches)):
			if len(matches_being_tweened) > i:
				if matches_being_tweened[i] == matches[j]:
					matches_being_tweened.remove_at(i)


# Shows the tutorial for the current level.
func show_tutorial():
	if tutorial == 1:
		Global.timer_running = false
		$help.visible = true
		$help/bottom.visible = true
		$help/bottom/bubble/content.text = "match 3 or more candies to feed the animals!"
		tutorial = -1
	elif tutorial == 2:
		Global.timer_running = false
		$help.visible = true
		$help/bottom.visible = false
		$help/left.visible = true
		$help/left/bubble/content.text = "use boosters to CHEAT the game!"
		tutorial = -2
	else:
		Global.timer_running = true
		$help.visible = false
		$help/bottom.visible = false
		$help/left.visible = false
		tutorial = 0


# Swap the selected piece with the adjacent one based on swipe direction.
func swap_pieces():
	# Ensure a piece has been swiped on
	if Global.piece_selected != null and Global.swipe_direction != null:
		var next_node_path = null
		var next_node = null
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
		# Handle `moves` count
		moves -= 1
		$top_moves/moves.text = str(moves)
