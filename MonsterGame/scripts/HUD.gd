extends Node2D
class_name HUD

@onready var label = $Control/CanvasLayer/Label
@onready var label2 = $Control/CanvasLayer/Label2

func _ready():
	label.text = "Meatsacks Collected: " + str(GameState.TreasureCount) + "/7"

func _process(delta):
	label2.visible = GameState.invincibility_activated

func update_display():
	label.text = "Meatsacks Collected: " + str(GameState.TreasureCount) + "/7"

