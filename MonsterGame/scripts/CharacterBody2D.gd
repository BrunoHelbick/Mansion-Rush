extends CharacterBody2D
class_name Character

@export var speed: float = 140.0
@onready var animated_sprite = $AnimatedSprite2D
@onready var walking_audio = $AudioStreamPlayer

var last_direction: Vector2 = Vector2.ZERO

func _ready():
	if animated_sprite == null:
		print("AnimatedSprite2D not found")
	if walking_audio == null:
		print("AudioStreamPlayer not found")

func _physics_process(_delta: float) -> void:
	@warning_ignore("shadowed_variable_base_class")
	var velocity = Vector2.ZERO

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
