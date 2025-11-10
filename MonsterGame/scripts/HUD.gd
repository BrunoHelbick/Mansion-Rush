extends Node2D
class_name HUD

@onready var label = $Control/CanvasLayer/Label
func _ready():
	label.text = "Meatsacks Collected: " + str(GameState.TreasureCount) + "/7"

func update_display():
	label.text = "Meatsacks Collected: " + str(GameState.TreasureCount) + "/7"

