extends CharacterBody2D
class_name Character

@export var speed: float = 140.0
@onready var animated_sprite = $AnimatedSprite2D
@onready var walking_audio = $AudioStreamPlayer
@onready var light_brighter = $LightBrighter
@onready var light_brighter2 = $LightBrighter2
var last_direction: Vector2 = Vector2.ZERO
var is_invincible = false
var invincibility_time_left = 0.0
var invincibility_duration = 5.0
var invincibility_used_this_level = false

func _ready():
	if animated_sprite == null:
		print("AnimatedSprite2D not found")
	if walking_audio == null:
		print("AudioStreamPlayer not found")
	if GameState.brightness_activated:
		light_brighter.visible = false
		light_brighter2.visible = true
	else:
		light_brighter.visible = true
		light_brighter2.visible = false
	
	invincibility_used_this_level = false

func _physics_process(_delta: float) -> void:
	if is_invincible:
		invincibility_time_left -= _delta
		if invincibility_time_left <= 0:
			is_invincible = false
			animated_sprite.modulate = Color.WHITE
	
	if Input.is_action_just_pressed("T") and GameState.invincibility_activated and not invincibility_used_this_level and not is_invincible:
		activate_invincibility()
	
	@warning_ignore("shadowed_variable_base_class")
	var velocity = Vector2.ZERO
	if GameState.speed_activated:
		speed = 250.0
	else: 
		speed = 140
	if not GameState.shop_open:
		if Input.is_action_pressed("move_right"):
			velocity.x += speed
		if Input.is_action_pressed("move_left"):
			velocity.x -= speed
		if Input.is_action_pressed("move_up"):
			velocity.y -= speed
		if Input.is_action_pressed("move_down"):
			velocity.y += speed

		self.velocity = velocity
		move_and_slide()

	if velocity != Vector2.ZERO:
		if not walking_audio.playing:
			walking_audio.play()
		if abs(velocity.x) > abs(velocity.y):
			if velocity.x > 0:
				animated_sprite.animation = "run_right"
			else:
				animated_sprite.animation = "run_left"
		else:
			if velocity.y > 0:
				animated_sprite.animation = "run_down"
			else:
				animated_sprite.animation = "run_up"

		last_direction = velocity.normalized()
	else:
		if walking_audio.playing:
			walking_audio.stop()
		if last_direction.x > 0:
			animated_sprite.animation = "idle_right"
		elif last_direction.x < 0:
			animated_sprite.animation = "idle_left"
		elif last_direction.y > 0:
			animated_sprite.animation = "idle_down"
		else:
			animated_sprite.animation = "idle_up"
	if animated_sprite.animation != "":
		animated_sprite.play()

func activate_invincibility():
	print("check")
	is_invincible = true
	invincibility_time_left = invincibility_duration
	invincibility_used_this_level = true
	animated_sprite.modulate = Color(250, 250, 0, 1)

func get_is_invincible() -> bool:
	return is_invincible
