extends CharacterBody2D
@export var speed = 90
@export var projectile_speed = 200
@export var projectile_spawn_interval = 3.0
@export var max_health = 20
var health = 20
var player: Node2D
var Level1: String
var is_scene_changing = false
var player_in_zone = false
var has_triggered_jumpscare = false 
var projectile_spawn_timer = 0.0

@onready var ghostJumpscare = $CanvasLayer/GhostJumpscare
@onready var ghostJumpscareText = $CanvasLayer/Label
@onready var audio_player = $AudioStreamPlayer
@onready var detection_area = $Hunter/Area2D2
@onready var kill_area = $Hunter/Enemy
@onready var hunter = $Hunter


func _ready():
	add_to_group("enemy") 
	health = max_health
	Level1 = "res://scenes/Level" + str(GameState.nextlvl) + ".tscn"
	
	detection_area.body_entered.connect(_on_detection_area_entered)
	detection_area.body_exited.connect(_on_detection_area_exited)
	kill_area.body_entered.connect(_on_kill_area_entered)

# Main game loop
func _process(delta: float) -> void:
	if get_tree().paused:
		return
	
	var hud = get_tree().get_first_node_in_group("hud")
	if hud and hud.has_method("update_health"):
		hud.update_health(health, max_health)
	projectile_spawn_timer += delta
	
	# Spawn projectiles every 3 seconds
	if projectile_spawn_timer >= projectile_spawn_interval:
		spawn_projectile()
		projectile_spawn_timer = 0.0
	
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
	hunter.play()

func spawn_projectile() -> void:
	var projectile = preload("res://scenes/projectile.tscn").instantiate()
	projectile.position = global_position
	
	# Random direction
	var random_angle = randf() * TAU
	var direction = Vector2(cos(random_angle), sin(random_angle))
	projectile.velocity = direction * projectile_speed
	projectile.set_meta("velocity", projectile.velocity)
	
	get_parent().add_child(projectile)

func _on_detection_area_entered(body):
	if body is Character:
		player_in_zone = true

func _on_detection_area_exited(body):
	if body is Character:
		player_in_zone = false

# Check for player entering kill area, trigger jumpscare
func _on_kill_area_entered(body):
	if body is Character and not has_triggered_jumpscare:
		if body.get_is_invincible():
			return
		has_triggered_jumpscare = true
		ghostJumpscare.visible = true
		ghostJumpscareText.visible = true
		audio_player.play()
		start_vibration()

# Jumpscare 		
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
		get_tree().change_scene_to_file("res://scenes/Colosseum.tscn")
		is_scene_changing = false

func take_damage(amount: int):
	health -= amount
	var hud = get_tree().get_first_node_in_group("hud")
	if hud and hud.has_method("update_health"):
		hud.update_health(health, max_health)
	if health <= 0:
		GameState.gold += 10
		GameState.save_game()
		call_deferred("change_scene", "res://scenes/Village.tscn")

func change_scene(scene: String):
	get_tree().change_scene_to_file(scene)
		
func trigger_jumpscare():
	if not has_triggered_jumpscare:
		has_triggered_jumpscare = true
		ghostJumpscare.visible = true
		ghostJumpscareText.visible = true
		audio_player.play()
		start_vibration()
