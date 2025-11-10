extends Node2D
var target: Character
var Level1: String
@onready var whisker = $CanvasLayer/Whiskersjumpscare
@onready var audio_player = $AudioStreamPlayer

func _ready():
	Level1 = "res://scenes/Level" + str(GameState.nextlvl) + ".tscn"

func _on_area_2d_body_entered(body):
	if body is Character:
		if whisker:
			whisker.visible = true
			GameState.resetTreasure()
			audio_player.play()
			start_vibration()

func start_vibration() -> void:
	var original_position = whisker.position
	var shake_intensity = 20
	var shake_duration = 1
	var elapsed_time = 0.0
	var shake_interval = 0.05

	while elapsed_time < shake_duration:
		whisker.position = original_position + Vector2(randf_range(-shake_intensity, shake_intensity), randf_range(-shake_intensity, shake_intensity))
		await get_tree().create_timer(shake_interval).timeout  
		elapsed_time += shake_interval

	whisker.position = original_position
	whisker.visible =false
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file(Level1)
