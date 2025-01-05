extends Control

class_name HUD

@export_group("Ammo Types")
@export var smg_ammo = preload("res://assets/ui/ammo_types/45cal.png")
@export var deagle_ammo = preload("res://assets/ui/ammo_types/50cal.png")
@export var rifle_ammo = preload("res://assets/ui/ammo_types/223remington.png")
@export var artillery_ammo = preload("res://assets/ui/ammo_types/artillery_shell.png")
@export var charge_cannon_ammo = preload("res://assets/ui/ammo_types/power_cell.png")
@export var shotgun_ammo = preload("res://assets/ui/ammo_types/shotgun_shell.png")

@onready var health_bar = $CanvasLayer/MarginContainer/HealthBar
@onready var secret_timer = $SecretTimer
@onready var secret_container = $CanvasLayer/Secret_container

@onready var bullet_sprite = $CanvasLayer/Ammo_Container/HBoxContainer/AmmoSprite
@onready var bullet_count = $CanvasLayer/Ammo_Container/HBoxContainer/Label

@onready var arrow = $CanvasLayer/Arrow
var extract_zone 

@onready var primary_obj = $CanvasLayer/Objective_Container/VBoxContainer/PrimaryObjectiveLabel
@onready var primary_obj_label = $CanvasLayer/Objective_Container/VBoxContainer/PrimaryObjectiveLabel/Label
@onready var optional_objective = $CanvasLayer/Objective_Container/VBoxContainer/OptionalObjective
@onready var optional_objective_label = $CanvasLayer/Objective_Container/VBoxContainer/OptionalObjective/Label
@onready var extract_obj = $CanvasLayer/Objective_Container/VBoxContainer/ExtractObjectiveLabel
@onready var timer_container = $CanvasLayer/TimerContainer
@onready var timer_label = $CanvasLayer/TimerContainer/HBoxContainer/TimerLabel

var new_bullet_sprite: CompressedTexture2D

func _ready():
	pass # Replace with function body.

func _process(delta):
	if arrow.visible == true:
		arrow.look_at(extract_zone.global_position)
		pass
	pass

func change_bullet_sprite():
	bullet_sprite.texture = new_bullet_sprite

func update_bullets(bullets_total):
	bullet_count.text = bullets_total
	pass

func reload_hud():
	pass

func take_damage():
	health_bar.value -= 1

func gain_health():
	health_bar.value += 1

func update_primary():
	pass

func secret_found():
	secret_container.visible = true
	secret_timer.start()
	
func tick_up():
	optional_objective.pivot_offset = optional_objective.size/2
	var tween = create_tween()
	tween.tween_property(optional_objective, "scale", Vector2(1.2, 1), .15)
	tween.tween_property(optional_objective, "scale", Vector2(1, 1), .15)

func complete_primary(obj):
	primary_obj.pivot_offset = primary_obj.size/2
	var tween = create_tween()
	tween.tween_property(primary_obj, "scale", Vector2(1.2, 1), .15)
	tween.tween_property(primary_obj, "scale", Vector2(1, 1), .15)
	primary_obj.modulate = Color.GREEN_YELLOW
	go_to_extract(obj)

func go_to_extract(obj):
	extract_obj.visible = true
	extract_zone = obj
	arrow.visible = true

func complete_optional():
	optional_objective.pivot_offset = optional_objective.size/2
	var tween = create_tween()
	tween.tween_property(optional_objective, "scale", Vector2(1.2, 1), .15)
	tween.tween_property(optional_objective, "scale", Vector2(1, 1), .15)
	optional_objective.modulate = Color.GREEN_YELLOW

func completeobj3():
	#obj3.pivot_offset = obj3.size/2
	#var tween = create_tween()
	#tween.tween_property(obj3, "scale", Vector2(1.2, 1), .15)
	#tween.tween_property(obj3, "scale", Vector2(1, 1), .15)
	#obj3.modulate = Color.GREEN_YELLOW
	pass


func _on_secret_timer_timeout():
	secret_container.visible = false
