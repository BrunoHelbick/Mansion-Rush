extends Node2D

@onready var audio = $AudioStreamPlayer
var game_started = false

func _ready():
	hide_ui_elements()
	spawn_sword()
	get_tree().paused = true  # Start paused
	process_mode = PROCESS_MODE_ALWAYS # Make sure _process runs even when paused

# Checks for start key
func _process(delta):
	if not game_started and Input.is_action_just_pressed("ui_accept"):
		game_started = true
		audio.play()
		get_tree().paused = false

func spawn_sword():
	var player = get_tree().get_first_node_in_group("player")
	if player and GameState.has_any_sword():
		var sword_scene = get_sword_scene(GameState.equipped_sword)
		if sword_scene:
			var sword = sword_scene.instantiate()
			player.add_child(sword)

func get_sword_scene(sword_name: String):
	match sword_name:
		"Basic":
			return preload("res://scenes/Sword.tscn")
		"Fast":
			return preload("res://scenes/FastSword.tscn")
		"Strong":
			return preload("res://scenes/StrongSword.tscn")
		_:
			return preload("res://scenes/Sword.tscn")

# Hide horror theme
func hide_ui_elements():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var light = player.get_node("LightBrighter")
		var light2 = player.get_node("LightBrighter2")
		var rect1 = player.get_node("ColorRect")
		var rect2 = player.get_node("ColorRect2")
		var rect3 = player.get_node("ColorRect3")
		var rect4 = player.get_node("ColorRect4")
		if light:
			light.visible = false
		if light2:
			light2.visible = false
		if rect1:
			rect1.visible = false
		if rect2:
			rect2.visible = false
		if rect3:
			rect3.visible = false
		if rect4:
			rect4.visible = false
