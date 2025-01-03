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

#@onready var obj1 = $CanvasLayer/Objective_Container/VBoxContainer/HBoxContainer
@onready var obj2 = $CanvasLayer/Objective_Container/VBoxContainer/HBoxContainer2
#@onready var obj3 = $CanvasLayer/Objective_Container/VBoxContainer/HBoxContainer3
#@onready var obj1label = $CanvasLayer/Objective_Container/VBoxContainer/HBoxContainer/Label
@onready var obj2label = $CanvasLayer/Objective_Container/VBoxContainer/HBoxContainer2/Label
#@onready var obj3label = $CanvasLayer/Objective_Container/VBoxContainer/HBoxContainer3/Label

@onready var primary_obj = $CanvasLayer/Objective_Container/VBoxContainer/PrimaryObjectiveLabel
@onready var primary_obj_label = $CanvasLayer/Objective_Container/VBoxContainer/PrimaryObjectiveLabel/Label
@onready var extract_obj = $CanvasLayer/Objective_Container/VBoxContainer/ExtractObjectiveLabel

var killed_snowmen = 0
var amount_to_kill = 10
var level = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	if level == 1:
		#obj1label.text = "Destroy the Generator"
		obj2label.text = "Kill  "+str(killed_snowmen)+"/"+str(amount_to_kill)+"  Snowmen"
		#obj3label.text = "Escape"
	pass # Replace with function body.

func take_damage():
	health_bar.value -= 1

func update_primary():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if p
	pass
	
func killed_snowman():
	obj2.pivot_offset = obj2.size/2
	var tween = create_tween()
	tween.tween_property(obj2, "scale", Vector2(1.2, 1), .15)
	tween.tween_property(obj2, "scale", Vector2(1, 1), .15)
	killed_snowmen += 1
	if killed_snowmen == amount_to_kill:
			completeobj2()

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

func completeobj2():
	obj2.pivot_offset = obj2.size/2
	var tween = create_tween()
	tween.tween_property(obj2, "scale", Vector2(1.2, 1), .15)
	tween.tween_property(obj2, "scale", Vector2(1, 1), .15)
	obj2.modulate = Color.GREEN_YELLOW

func completeobj3():
	#obj3.pivot_offset = obj3.size/2
	#var tween = create_tween()
	#tween.tween_property(obj3, "scale", Vector2(1.2, 1), .15)
	#tween.tween_property(obj3, "scale", Vector2(1, 1), .15)
	#obj3.modulate = Color.GREEN_YELLOW
	pass


func _on_button_pressed():
	killed_snowman()


#func _on_generator_just_destroyed():
	#completeob1()
