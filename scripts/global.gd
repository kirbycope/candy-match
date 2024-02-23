# global.gd :: Autoloaded as "Global"

extends Node


var character = 1
var enabled_music = true
var enabled_sound = true
var timer_duration = 0
var timer_running = false
var timer_time = timer_duration


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


func _process(delta):
	if timer_running:
		timer_time -= delta
		if timer_time <= 0:
			timer_running = false
			timer_time = 0


func _input(event):
	if event is InputEventAction and event.pressed:
		if event.action == "Main":
			get_tree().change_scene_to_file("res://scenes/main.tscn")
		if Global.enabled_sound:
			var current_scene = get_tree().get_current_scene()
			if current_scene:
				var taps_1 = current_scene.get_node("taps_1")
				taps_1.play()


func start_timer():
	timer_running = true
	timer_time = 120  # 120 seconds == 2 minutes
