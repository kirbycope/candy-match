# global.gd :: Autoloaded as "Global"

extends Node


var character = 1
var enabled_music = true
var enabled_sound = true
var piece_selected = null
var swipe_direction = null
var timer_duration = 0
var timer_running = false
var timer_time = timer_duration


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


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
			get_tree().change_scene_to_file("res://scenes/main.tscn")
		if event.action == "Shoppette":
			shoppette_display()
		if Global.enabled_sound:
			var current_scene = get_tree().get_current_scene()
			if current_scene:
				var taps_1 = current_scene.get_node("taps_1")
				taps_1.play()


func shoppette_display():
	var node_path = "../shoppette"
	var node = get_node(node_path)
	if node == null:
		var scene_instance = load("res://scenes/shoppette.tscn")
		scene_instance = scene_instance.instantiate()
		var root_node = get_tree().get_root()
		root_node.add_child(scene_instance)
	else:
		shoppette_hide()


# Returns true if the shoppette scene is removed as a result of running this function.
func shoppette_hide():
	var node_path = "../shoppette"
	var node = get_node(node_path)
	if node:
		var root_node = get_tree().get_root()
		root_node.remove_child(node)
		return true
	return false


func start_timer():
	timer_running = true
	timer_time = 120  # 120 seconds == 2 minutes
