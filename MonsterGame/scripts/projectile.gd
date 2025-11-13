extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var sword_detector = $Area2D

# Set back spin animation
func _ready():
	sprite.animation = "default"
	sprite.play()
	sword_detector.area_entered.connect(_on_sword_detector_entered)

# handle collision and movement
func _physics_process(delta: float) -> void:
	velocity = get_meta("velocity")
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		var collider = collision.get_collider()
		
		# Hit player = restart level
		if collider is Character:
			if not collider.get_is_invincible():
				var belmod = get_tree().get_first_node_in_group("enemy")
				if belmod and belmod.has_method("trigger_jumpscare"):
					belmod.trigger_jumpscare()
		else:
			# Bounce off other physics bodies
			velocity = velocity.bounce(collision.get_normal())
			set_meta("velocity", velocity)

func _on_sword_detector_entered(area):
	if area.is_in_group("sword"):
		sprite.animation = "Explode"
		sprite.play()
		await sprite.animation_finished
		queue_free()
