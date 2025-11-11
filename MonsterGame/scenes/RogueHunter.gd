extends CharacterBody2D

@export var speed = 90
var player: Node2D
var Level1: String
var is_scene_changing = false
var player_in_zone = false
var has_triggered_jumpscare = false 

@onready var ghostJumpscare = $CanvasLayer/GhostJumpscare
@onready var ghostJumpscareText = $CanvasLayer/Label
@onready var audio_player = $AudioStreamPlayer
@onready var detection_area = $Hunter/Area2D2
@onready var kill_area = $Hunter/Area2D
@onready var hunter = $Hunter

func _ready():
	Level1 = "res://scenes/Level" + str(GameState.nextlvl) + ".tscn"
	
	detection_area.body_entered.connect(_on_detection_area_entered)
	detection_area.body_exited.connect(_on_detection_area_exited)
	kill_area.body_entered.connect(_on_kill_area_entered)

func _process(delta: float) -> void:
	player = get_tree().get_first_node_in_group("player")
	
	if not player or not player_in_zone:
		hunter.animation = "Idle"
		velocity = Vector2.ZERO
		return
	
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	move_and_slide()
	
	if abs(direction.x) > abs(direction.y):
		hunter.animation = "Move_right" if direction.x > 0 else "Move_left"
	else:
		hunter.animation = "Move_down" if direction.y > 0 else "Move_up"
		
func _on_detection_area_entered(body):
	if body is Character:
		player_in_zone = true

func _on_detection_area_exited(body):
	if body is Character:
		player_in_zone = false
		
func _on_kill_area_entered(body):
	if body is Character and not has_triggered_jumpscare:
		has_triggered_jumpscare = true
		ghostJumpscare.visible = true
		ghostJumpscareText.visible = true
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
		await get_tree().create_timer(shake_interval).timeout
		elapsed_time += shake_interval

	ghostJumpscare.position = original_position
	ghostJumpscare.visible = false
	ghostJumpscareText.visible = false
	
	if !is_scene_changing:
		is_scene_changing = true
		if get_tree():
			await get_tree().create_timer(0.1).timeout
		GameState.resetTreasure()
		get_tree().change_scene_to_file(Level1)
		is_scene_changing = false
