extends CharacterBody2D

@export var speed: float = 10
var Speed = 100
var target: Vector2 = Vector2.ZERO
var Level1: String
var is_attacking: bool = false
@onready var ghostJumpscare = $CanvasLayer/Longmanjumpscare
@onready var audio_player = $AudioStreamPlayer
@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	Level1 = "res://scenes/Level" + str(GameState.nextlvl) + ".tscn"

@warning_ignore("unused_parameter")
func _process(delta):
	if not is_attacking and target != Vector2.ZERO:
		velocity = global_position.direction_to(target) * Speed
		if global_position.distance_to(target) > 1:
			if !animated_sprite.is_playing() or animated_sprite.animation != "walk":
				animated_sprite.play("walk")
			move_and_slide()
	else:
		if animated_sprite.animation != "idle":
			animated_sprite.play("idle")

func _on_area_2d_body_entered(body):
	if not is_attacking and body is Character:
		is_attacking = true
		if ghostJumpscare:
			ghostJumpscare.visible = true
			audio_player.play()
			start_vibration()

func _on_area_2d_2_body_entered(body):
	if not is_attacking and body is Character:
		target = body.global_position

func start_vibration() -> void:
	var original_position = ghostJumpscare.position
	var shake_intensity = 20
	var shake_duration = 1
	var elapsed_time = 0.0
	var shake_interval = 0.05

	while elapsed_time < shake_duration:
		ghostJumpscare.position = original_position + Vector2(randf_range(-shake_intensity, shake_intensity), randf_range(-shake_intensity, shake_intensity))
		await get_tree().create_timer(shake_interval).timeout  
		elapsed_time += shake_interval

	ghostJumpscare.position = original_position
	ghostJumpscare.visible = false
	await get_tree().create_timer(0.1).timeout
	GameState.resetTreasure()
	get_tree().change_scene_to_file(Level1)
	is_attacking = false
