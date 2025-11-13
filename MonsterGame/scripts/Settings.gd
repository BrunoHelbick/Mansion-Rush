extends Node

@onready var audio_slider = $Control/HSlider
@onready var fullscreen_button = $Control/CheckButton

func _ready():
	audio_slider.min_value = 0
	audio_slider.max_value = 100
	audio_slider.value = 100
	audio_slider.value_changed.connect(_on_audio_slider_changed)
	
	fullscreen_button.button_pressed = true
	fullscreen_button.toggled.connect(_on_fullscreen_toggled)
	get_window().mode = Window.MODE_FULLSCREEN

func _on_audio_slider_changed(value: float):
	var volume_db = linear_to_db(value / 100.0)
	AudioServer.set_bus_volume_db(0, volume_db)
	print("Audio volume: ", value, "%")

func _on_fullscreen_toggled(toggled_on: bool):
	if toggled_on:
		get_window().mode = Window.MODE_FULLSCREEN
	else:
		get_window().mode = Window.MODE_WINDOWED
	print("Fullscreen: ", toggled_on)

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/Menu.tscn")
