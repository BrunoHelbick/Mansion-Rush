extends Node2D

@onready var canvas_layer = $Control/CanvasLayer
@onready var animation = $AnimatedSprite2D

@onready var sword1_area = $Control/CanvasLayer/Sword1Area
@onready var sword2_area = $Control/CanvasLayer/Sword2Area
@onready var sword3_area = $Control/CanvasLayer/Sword3Area

@onready var sword1_label = $Control/CanvasLayer/Sword1Label
@onready var sword2_label = $Control/CanvasLayer/Sword2Label
@onready var sword3_label = $Control/CanvasLayer/Sword3Label

@onready var sword1_check = $Control/CanvasLayer/Sword1Check
@onready var sword2_check = $Control/CanvasLayer/Sword2Check
@onready var sword3_check = $Control/CanvasLayer/Sword3Check

var player_in_area = false
var caddy_open = false

# Handle connections
func _ready():
	animation.play("default")
	
	sword1_area.mouse_entered.connect(_on_sword1_hover)
	sword1_area.mouse_exited.connect(_on_sword1_unhover)
	sword1_area.input_event.connect(_on_sword1_input)
	
	sword2_area.mouse_entered.connect(_on_sword2_hover)
	sword2_area.mouse_exited.connect(_on_sword2_unhover)
	sword2_area.input_event.connect(_on_sword2_input)
	
	sword3_area.mouse_entered.connect(_on_sword3_hover)
	sword3_area.mouse_exited.connect(_on_sword3_unhover)
	sword3_area.input_event.connect(_on_sword3_input)

# Update equipped sword checkmarks and handle opening menu for caddy
func _process(delta):
	sword1_check.visible = GameState.equipped_sword == "Basic"
	sword2_check.visible = GameState.equipped_sword == "Fast"
	sword3_check.visible = GameState.equipped_sword == "Strong"
	
	if player_in_area and Input.is_action_just_pressed("Interact"):
		caddy_open = !caddy_open
		canvas_layer.visible = caddy_open

# Enter/Exit shop area
func _on_area_2d_body_entered(body):
	if body is Character or body.name == "CharacterBody2D":
		player_in_area = true

func _on_area_2d_body_exited(body):
	if body is Character or body.name == "CharacterBody2D":
		player_in_area = false
		caddy_open = false
		canvas_layer.visible = false

# Sword 1
func _on_sword1_hover():
	sword1_label.visible = true

func _on_sword1_unhover():
	sword1_label.visible = false

func _on_sword1_input(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if GameState.has_sword("Basic"):
			GameState.equipped_sword = "Basic"

# Sword 2
func _on_sword2_hover():
	sword2_label.visible = true

func _on_sword2_unhover():
	sword2_label.visible = false

func _on_sword2_input(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if GameState.has_sword("Fast"):
			GameState.equipped_sword = "Fast"

# Sword 3
func _on_sword3_hover():
	sword3_label.visible = true

func _on_sword3_unhover():
	sword3_label.visible = false

func _on_sword3_input(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if GameState.has_sword("Strong"):
			GameState.equipped_sword = "Strong"
