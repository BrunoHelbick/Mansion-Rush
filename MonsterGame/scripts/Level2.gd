extends Node2D

var audio_player : AudioStreamPlayer

func _enter_tree():
	GameState.nextlvl = 2


func _ready():
	audio_player = $AudioStreamPlayer
	audio_player.volume_db = -30
	audio_player.play() 
