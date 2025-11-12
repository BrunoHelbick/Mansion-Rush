extends Node2D
func _on_area_2d_body_entered(body):
	if body is Character:
		if GameState.TreasureCount >= 7:
			var current_level = get_level_number()
			GameState.gold += 5
			GameState.getNextLevel(current_level)
			await get_tree().create_timer(0.1).timeout
			var Village = "res://scenes/Village.tscn"
			get_tree().change_scene_to_file(Village)

func get_level_number() -> int:
	var scene_path = get_tree().current_scene.scene_file_path
	var scene_name = scene_path.get_file().trim_suffix(".tscn")
	
	if scene_name.begins_with("Level"):
		return int(scene_name.trim_prefix("Level"))
	
	return 0
