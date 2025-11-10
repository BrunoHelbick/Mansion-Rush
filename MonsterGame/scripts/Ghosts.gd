extends Node2D

@export var speed = 100
@export var move_distance = 300
var direction = 1
var start_position : Vector2
var ghost : Node2D
var Level1: String
var is_scene_changing = false 
@onready var ghostJumpscare = $CanvasLayer/GhostJumpscare
@onready var audio_player = $AudioStreamPlayer

func _ready():
	Level1 = "res://scenes/Level" + str(GameState.nextlvl) + ".tscn"
	ghost = %Ghost2
	start_position = ghost.position

func _process(delta: float) -> void:
	ghost.position.x += direction * speed * delta
	
	if abs(ghost.position.x - start_position.x) >= move_distance:
		direction *= -1
		start_position = ghost.position
		ghost.scale.x = -abs(ghost.scale.x) if direction == -1 else abs(ghost.scale.x)


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
