extends Node

const village := "res://scenes/Village.tscn"
const Settings := "res://scenes/Settings.tscn"

func _on_button_2_pressed():
	get_tree().quit()


func _on_button_pressed():
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file(village)


func _on_button_3_pressed():
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file(Settings)
