extends Node2D

@onready var mansion_area = $Mansion
@onready var forest_area = $Forest
@onready var locked_label = $Locked
@onready var locked_label2 = $Locked2
@onready var audio = $AudioStreamPlayer
@onready var gold_label = $Control/CanvasLayer/GoldCount

func _ready():
	mansion_area.body_entered.connect(_on_mansion_entered)
	forest_area.body_entered.connect(_on_forest_entered)
	hide_ui_elements()
	audio.play()
	var player = $Character
	player.visible = true
	audio.volume_db = -30
	audio.finished.connect(_on_audio_finished)
	if GameState.unlockedLevels > 1:
		locked_label.visible = false
	if GameState.unlockedLevels > 2:
		locked_label2.visible = false

func _process(delta):
	gold_label.text = "Gold: " + str(GameState.gold)

func _on_mansion_entered(body):
	if body is Character:
		hide_ui_elements()
		get_tree().call_deferred("change_scene_to_file", "res://scenes/Level1.tscn")

func _on_forest_entered(body):
	if body is Character:
		if GameState.unlockedLevels > 2:
			hide_ui_elements()
			get_tree().call_deferred("change_scene_to_file", "res://scenes/Level3.tscn")

func hide_ui_elements():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var light = player.get_node("LightBrighter")
		var light2 = player.get_node("LightBrighter2")
		if light:
			light.visible = false
		if light2:
				light2.visible = false
func _on_audio_finished():
	audio.play()

func _on_mansion_2_body_entered(body):
	if body is Character:
		if GameState.unlockedLevels > 1:
			hide_ui_elements()
			get_tree().call_deferred("change_scene_to_file", "res://scenes/Level2.tscn")
