extends Node2D

@export var max_audio_distance = 200  # Distance to silent
@export var min_audio_distance = 30   # Distance to loudest
var ghost : Node2D
var Level1: String
var is_scene_changing = false 
@onready var ghostJumpscare = $CanvasLayer/GhostJumpscare
@onready var audio_player = $AudioStreamPlayer  # Jumpscare
@onready var audio_player2 = $AudioStreamPlayer2  # Ambient

func _ready():
	Level1 = "res://scenes/Level" + str(GameState.nextlvl) + ".tscn"
	ghost = %Ghost2
	audio_player2.volume_db = -80.0
	if not audio_player2.playing:
		audio_player2.play()
		audio_player2.finished.connect(_on_audio_finished)


func _process(delta: float) -> void:
	update_proximity_audio()

func update_proximity_audio() -> void:
	var player = get_tree().get_first_node_in_group("player")
	
	if not player:
		return
	
	var distance = ghost.global_position.distance_to(player.global_position)
	
	var volume_db: float
	
	if distance < min_audio_distance:
		volume_db = 0.0
	elif distance > max_audio_distance:
		volume_db = -80.0
	else:
		var ratio = (distance - min_audio_distance) / (max_audio_distance - min_audio_distance)
		volume_db = lerp(0.0, -80.0, ratio)
	
	audio_player2.volume_db = volume_db

func _on_area_2d_body_entered(body):
	if body is Character:
		if ghostJumpscare:
			ghostJumpscare.visible = true
			audio_player.play()
			start_vibration()
			
func start_vibration() -> void:
	var original_position = ghostJumpscare.position
	var shake_intensity = 20
	var shake_duration = 1
	var elapsed_time = 0.0
	var shake_interval = 0.05

	while elapsed_time < shake_duration:
		if !get_tree():
			return
		ghostJumpscare.position = original_position + Vector2(randf_range(-shake_intensity, shake_intensity), randf_range(-shake_intensity, shake_intensity))
		if get_tree():
			await get_tree().create_timer(shake_interval).timeout
		elapsed_time += shake_interval

	ghostJumpscare.position = original_position
	ghostJumpscare.visible = false
	if !is_scene_changing:
		is_scene_changing = true
		await get_tree().create_timer(0.1).timeout
		GameState.resetTreasure()
		get_tree().change_scene_to_file(Level1)
		is_scene_changing = false

func _on_audio_finished() -> void:
	if audio_player2:
		audio_player2.play()
