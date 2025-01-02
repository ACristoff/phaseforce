extends Control

@export_group("Ammo Types")
@export var smg_ammo = preload("res://assets/ui/ammo_types/45cal.png")
@export var deagle_ammo = preload("res://assets/ui/ammo_types/50cal.png")
@export var rifle_ammo = preload("res://assets/ui/ammo_types/223remington.png")
@export var artillery_ammo = preload("res://assets/ui/ammo_types/artillery_shell.png")
@export var charge_cannon_ammo = preload("res://assets/ui/ammo_types/power_cell.png")
@export var shotgun_ammo = preload("res://assets/ui/ammo_types/shotgun_shell.png")

@onready var obj1 = $CanvasLayer/Objective_Container/VBoxContainer/HBoxContainer
@onready var obj2 = $CanvasLayer/Objective_Container/VBoxContainer/HBoxContainer2
@onready var obj3 = $CanvasLayer/Objective_Container/VBoxContainer/HBoxContainer3
@onready var obj1label = $CanvasLayer/Objective_Container/VBoxContainer/HBoxContainer/Label
@onready var obj2label = $CanvasLayer/Objective_Container/VBoxContainer/HBoxContainer2/Label
@onready var obj3label = $CanvasLayer/Objective_Container/VBoxContainer/HBoxContainer3/Label

var killed_snowmen = 0
var amount_to_kill = 10
var level = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if level == 1:
		obj1label.text = "Destroy the Generator"
		obj2label.text = "Kill  "+str(killed_snowmen)+"/"+str(amount_to_kill)+"  Snowmen"
		obj3label.text = "Escape"
	
func killed_snowman():
	obj2.pivot_offset = obj2.size/2
	var tween = create_tween()
	tween.tween_property(obj2, "scale", Vector2(1.2, 1), .15)
	tween.tween_property(obj2, "scale", Vector2(1, 1), .15)
	killed_snowmen += 1
	if killed_snowmen == amount_to_kill:
			completeobj2()
	
func completeob1():
	obj1.pivot_offset = obj1.size/2
	var tween = create_tween()
	tween.tween_property(obj1, "scale", Vector2(1.2, 1), .15)
	tween.tween_property(obj1, "scale", Vector2(1, 1), .15)
	obj1.modulate = Color.GREEN_YELLOW
func completeobj2():
	obj2.pivot_offset = obj2.size/2
	var tween = create_tween()
	tween.tween_property(obj2, "scale", Vector2(1.2, 1), .15)
	tween.tween_property(obj2, "scale", Vector2(1, 1), .15)
	obj2.modulate = Color.GREEN_YELLOW
func completeobj3():
	obj3.pivot_offset = obj3.size/2
	var tween = create_tween()
	tween.tween_property(obj3, "scale", Vector2(1.2, 1), .15)
	tween.tween_property(obj3, "scale", Vector2(1, 1), .15)
	obj3.modulate = Color.GREEN_YELLOW


func _on_button_pressed():
	killed_snowman()


func _on_generator_just_destroyed():
	completeob1()
