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


@onready var primary_obj = $CanvasLayer/Objective_Container/VBoxContainer/PrimaryObjectiveLabel
@onready var primary_obj_label = $CanvasLayer/Objective_Container/VBoxContainer/PrimaryObjectiveLabel/Label
@onready var optional_objective = $CanvasLayer/Objective_Container/VBoxContainer/OptionalObjective
@onready var optional_objective_label = $CanvasLayer/Objective_Container/VBoxContainer/OptionalObjective/Label
@onready var extract_obj = $CanvasLayer/Objective_Container/VBoxContainer/ExtractObjectiveLabel
@onready var timer_container = $CanvasLayer/TimerContainer
@onready var timer_label = $CanvasLayer/TimerContainer/HBoxContainer/TimerLabel

#var killed_snowmen = 0
#var amount_to_kill = 10
#var level = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	#if 
	#if level == 1:
		#obj1label.text = "Destroy the Generator"
		#obj2label.text = "Kill  "+str(killed_snowmen)+"/"+str(amount_to_kill)+"  Snowmen"
		#obj3label.text = "Escape"
	pass # Replace with function body.

func take_damage():
	health_bar.value -= 1

func gain_health():
	health_bar.value += 1

func update_primary():
	pass

func secret_found():
	secret_container.visible = true
	secret_timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if p
	pass
	
func tick_up():
	optional_objective.pivot_offset = optional_objective.size/2
	var tween = create_tween()
	tween.tween_property(optional_objective, "scale", Vector2(1.2, 1), .15)
	tween.tween_property(optional_objective, "scale", Vector2(1, 1), .15)
	#killed_snowmen += 1
	#if killed_snowmen == amount_to_kill:
			#completeobj2()

func complete_primary():
	primary_obj.pivot_offset = primary_obj.size/2
	var tween = create_tween()
	tween.tween_property(primary_obj, "scale", Vector2(1.2, 1), .15)
	tween.tween_property(primary_obj, "scale", Vector2(1, 1), .15)
	primary_obj.modulate = Color.GREEN_YELLOW
	go_to_extract()

func go_to_extract():
	extract_obj.visible = true
	#pass

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
