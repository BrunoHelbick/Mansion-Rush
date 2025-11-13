extends Area2D

@export var orbit_radius = 40.0
@export var rotation_speed = 4.0
@export var damage = 2
@onready var slash = $AudioStreamPlayer

var angle = 0.0
var damaged_enemies = []

# Orbit sword around player
func _process(delta):
	angle += rotation_speed * delta
	global_position = get_parent().global_position + Vector2(cos(angle) * orbit_radius, sin(angle) * orbit_radius)
	rotation = angle

# On enter call take damage method on enemy
func _on_area_entered(area):
	print(area.name)
	if area.name == "Enemy":
		var enemy = area.get_parent().get_parent()
		if enemy.has_method("take_damage"):
			enemy.take_damage(damage)
			slash.play()
			print("Hit enemy!")
