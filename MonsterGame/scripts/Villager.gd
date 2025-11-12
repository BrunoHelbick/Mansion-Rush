extends Node2D
@export var walk_speed = 100.0
@export var walk_distance = 200.0
var animated_sprite: AnimatedSprite2D
var current_direction = 1
var start_position: Vector2
var target_position: Vector2
var is_walking = false
var idle_timer = 0.0
var idle_duration = 0.0

func _ready():
	animated_sprite = $Villager
	start_position = global_position
	target_position = start_position + Vector2(walk_distance * current_direction, 0)
	is_walking = true
	animated_sprite.play("Move_right")

func _process(delta: float) -> void:
	if is_walking:
		global_position = global_position.move_toward(target_position, walk_speed * delta)
		
		if global_position.distance_to(target_position) < 5:
			is_walking = false
			idle_timer = 0.0
			idle_duration = randf_range(3.0, 15.0)
			animated_sprite.play("Idle")
	else:
		idle_timer += delta
		if idle_timer >= idle_duration:
			current_direction *= -1
			target_position = global_position + Vector2(walk_distance * current_direction, 0)
			is_walking = true
			animated_sprite.play("Move_left" if current_direction == -1 else "Move_right")
