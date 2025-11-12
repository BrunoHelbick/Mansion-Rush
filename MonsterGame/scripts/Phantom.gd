extends Node2D

@export var orbit_radius = 100
@export var orbit_speed = 2.0
@export var spawn_delay = 0.5

var phantoms: Array[AnimatedSprite2D] = []
var phantom_areas: Array[Area2D] = []
var angles: Array[float] = []
var ghost_active: Array[bool] = [false, false, false, false, false]
var elapsed_time = 0.0
var has_triggered_jumpscare = false

var Level1: String
var is_scene_changing = false

@onready var ghostJumpscare = $CanvasLayer/GhostJumpscare
@onready var audio_player = $AudioStreamPlayer

func _ready():
	Level1 = "res://scenes/Level" + str(GameState.nextlvl) + ".tscn"
	
	phantoms = [
		$Phantom1,
		$Phantom2,
		$Phantom3,
		$Phantom4,
		$Phantom5
	]
	
	phantom_areas = [
		$Phantom1/Area2D,
		$Phantom2/Area2D,
		$Phantom3/Area2D,
		$Phantom4/Area2D,
		$Phantom5/Area2D
	]
	
	for area in phantom_areas:
		area.body_entered.connect(_on_phantom_body_entered)
	
	angles = [0.0, TAU/5, TAU*2/5, TAU*3/5, TAU*4/5]
	
	for i in range(5):
		update_phantom_position(i)
		phantoms[i].animation = "default"
		
func _process(delta: float) -> void:
	elapsed_time += delta
	for i in range(5):
		if !ghost_active[i] and elapsed_time >= spawn_delay * i:
			ghost_active[i] = true
			phantoms[i].play()
	
	for i in range(5):
		if ghost_active[i]:
			angles[i] += orbit_speed * delta
			update_phantom_position(i)

func update_phantom_position(index: int) -> void:
	var x = cos(angles[index]) * orbit_radius
	var y = sin(angles[index]) * orbit_radius
	phantoms[index].position = Vector2(x, y)

func _on_phantom_body_entered(body):
	if body is Character and not has_triggered_jumpscare: 
		if body.get_is_invincible():
			return
		has_triggered_jumpscare = true
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
