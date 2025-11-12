extends Node2D
@onready var canvas_layer = $Control/CanvasLayer
@onready var animation = $AnimatedSprite2D
@onready var brightness_area = $Control/CanvasLayer/Brightness2
@onready var invincibility_area = $Control/CanvasLayer/Invincibility2
@onready var speed_area = $Control/CanvasLayer/Speed2
@onready var brightness_label = $Control/CanvasLayer/Brightness
@onready var invincibility_label = $Control/CanvasLayer/Invincibility
@onready var speed_label = $Control/CanvasLayer/Speed
@onready var x1_label = $Control/CanvasLayer/X1
@onready var x2_label = $Control/CanvasLayer/X2
@onready var x3_label = $Control/CanvasLayer/X3

var player_in_area = false
var shop_open = false
var item_cost = 5

func _ready():
	animation.play("default")
	
	brightness_area.mouse_entered.connect(_on_brightness_hover)
	brightness_area.mouse_exited.connect(_on_brightness_unhover)
	brightness_area.input_event.connect(_on_brightness_input)
	
	invincibility_area.mouse_entered.connect(_on_invincibility_hover)
	invincibility_area.mouse_exited.connect(_on_invincibility_unhover)
	invincibility_area.input_event.connect(_on_invincibility_input)
	
	speed_area.mouse_entered.connect(_on_speed_hover)
	speed_area.mouse_exited.connect(_on_speed_unhover)
	speed_area.input_event.connect(_on_speed_input)
	
	x1_label.visible = GameState.brightness_activated
	x2_label.visible = GameState.invincibility_activated
	x3_label.visible = GameState.speed_activated

func _process(delta):
	if player_in_area and Input.is_action_just_pressed("Interact"):
		shop_open = !shop_open
		canvas_layer.visible = shop_open
		GameState.shop_open = shop_open

func _on_area_2d_body_entered(body):
	if body is Character or body.name == "CharacterBody2D":
		player_in_area = true

func _on_area_2d_body_exited(body):
	if body is Character or body.name == "CharacterBody2D":
		player_in_area = false
		shop_open = false
		canvas_layer.visible = false
		GameState.shop_open = false

# Brightness
func _on_brightness_hover():
	brightness_label.visible = true

func _on_brightness_unhover():
	brightness_label.visible = false

func _on_brightness_input(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if not GameState.brightness_activated and GameState.gold >= item_cost:
			GameState.brightness_activated = true
			GameState.gold -= item_cost
			x1_label.visible = true

# Invincibility
func _on_invincibility_hover():
	invincibility_label.visible = true

func _on_invincibility_unhover():
	invincibility_label.visible = false

func _on_invincibility_input(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if not GameState.invincibility_activated and GameState.gold >= item_cost:
			GameState.invincibility_activated = true
			GameState.gold -= item_cost
			x2_label.visible = true

# Speed
func _on_speed_hover():
	speed_label.visible = true

func _on_speed_unhover():
	speed_label.visible = false

func _on_speed_input(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if not GameState.speed_activated and GameState.gold >= item_cost:
			GameState.speed_activated = true
			GameState.gold -= item_cost
			x3_label.visible = true
