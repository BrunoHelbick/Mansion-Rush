extends Node2D

@onready var floorJumpscare = $CanvasLayer/Fakefloorboardsjumpscare
@onready var audio_player = $AudioStreamPlayer
var Level1: String


func _ready():
	Level1 = "res://scenes/Level" + str(GameState.nextlvl) + ".tscn"
			
func start_vibration() -> void:
	var original_position = floorJumpscare.position
	var shake_intensity = 20
	var shake_duration = 1
	var elapsed_time = 0.0
	var shake_interval = 0.05

	while elapsed_time < shake_duration:
		floorJumpscare.position = original_position + Vector2(randf_range(-shake_intensity, shake_intensity), randf_range(-shake_intensity, shake_intensity))
		await get_tree().create_timer(shake_interval).timeout  
		elapsed_time += shake_interval

	floorJumpscare.position = original_position
	floorJumpscare.visible =false
	await get_tree().create_timer(0.1).timeout
	GameState.resetTreasure()
	get_tree().change_scene_to_file(Level1)


func _on_area_2d_body_entered(body):
	if body is Character:
		if body.get_is_invincible():
			return
		if floorJumpscare:
			floorJumpscare.visible = true
			audio_player.play()
			start_vibration()
