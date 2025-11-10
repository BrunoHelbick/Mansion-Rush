extends Node2D

var audio_player : AudioStreamPlayer
@onready var label = $CanvasLayer2/Label
@onready var timer = $Timer

func _ready():
	audio_player = $AudioStreamPlayer
	audio_player.volume_db = -30
	audio_player.play() 
	


func _on_timer_timeout():
	label.visible = false
