extends Node2D


func _on_area_2d_body_entered(body):
	if body is Character:
		if GameState.TreasureCount == 7:
			GameState.getNextLevel()
			await get_tree().create_timer(0.1).timeout
			var Level1 = "res://scenes/Level" + str(GameState.nextlvl) + ".tscn"
			get_tree().change_scene_to_file(Level1)
