extends Node2D
class_name HUD2

@onready var label2 = $Control/CanvasLayer/Label2
@onready var health_bar = $Control/CanvasLayer/TextureProgressBar  

func _process(delta):
	label2.visible = GameState.invincibility_activated

# Update health bar
func update_health(hp: int, max_hp: int):
	if health_bar == null:
		return
	health_bar.max_value = max_hp
	health_bar.value = hp

