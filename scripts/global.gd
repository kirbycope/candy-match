# global.gd :: Autoloaded as "Global"

extends Node


var current_level = 0
var enabled_music = true
var enabled_sound = true
var levels = null
var piece_selected = null
var player = null
var swipe_direction = null
var timer_duration = 0
var timer_running = false
var timer_time = timer_duration


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	if levels == null:
		levels = read_file_into_memory("res://levels.json")
	if player == null:
		player = read_file_into_memory("res://player.json")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer_running:
		timer_time -= delta
		if timer_time <= 0:
			timer_running = false
			timer_time = 0


# Called once for every event before _unhandled_input(), allowing you to consume some events.
func _input(event):
	if event is InputEventAction and event.pressed:
		if event.action == "Main":
			await get_tree().create_timer(0.2).timeout # Godot to sleep
			get_tree().change_scene_to_file("res://scenes/main.tscn")
		if Global.enabled_sound:
			var current_scene = get_tree().get_current_scene()
			if current_scene:
				var taps_1 = current_scene.get_node("taps_1")
				taps_1.play()


# Reads a file with into an object in memory.
func read_file_into_memory(file):
	var json_as_text = FileAccess.get_file_as_string(file)
	return JSON.parse_string(json_as_text)


# Starts a global timer for the given time in seconds.
func start_timer(time = 120):
	timer_running = true
	timer_time = time
