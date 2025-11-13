extends Node

const village := "res://scenes/Village.tscn"
const Settings := "res://scenes/Settings.tscn"

# Quit
func _on_button_2_pressed():
	get_tree().quit()

# Start game
func _on_button_pressed():
	await get_tree().create_timer(0.1).timeout
	get_tree().call_deferred("change_scene_to_file", village)

# Open settings
func _on_button_3_pressed():
	await get_tree().create_timer(0.1).timeout
	get_tree().call_deferred("change_scene_to_file", Settings)

# Reset game
func _on_button_4_pressed():
	GameState.reset_game()
	get_tree().call_deferred("change_scene_to_file", village)

