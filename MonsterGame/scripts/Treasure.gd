extends Node2D
class_name Treasure

@onready var hud = get_node("../../Hud")
@onready var treasure = $Treasure
@onready var audio_player = $AudioStreamPlayer
var audio_playing = false

func _on_area_2d_body_entered(body):
	if body is Character:
		if hud:
			audio_player.play()
			audio_playing = true
			treasure.visible = false
			GameState.incrementTreasureCount()
			hud.update_display()
			audio_player.finished.connect(_on_audio_finished)

		else:
			print("HUD not found")
			
func _on_audio_finished():
	if audio_playing:
		audio_playing = false
		queue_free()
