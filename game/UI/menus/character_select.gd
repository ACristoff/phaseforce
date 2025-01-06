extends Control

signal chosen_character

@onready var name_label = $MarginContainer2/ChuubasName
#I know there's a more efficient way to do this but I'm crunching
func _on_button_panko_pressed():
	chosen_character.emit("panko")

func _on_button_lia_pressed():
	chosen_character.emit("lia")	

func _on_button_tenma_pressed():
	chosen_character.emit("tenma")

func _on_button_pippa_pressed():
	chosen_character.emit("pippa")

func _on_button_lumi_pressed():
	chosen_character.emit("lumi")

func _on_button_panko_mouse_entered():
	name_label.text = "Komachi Panko"
	name_label.modulate = Color.MEDIUM_AQUAMARINE
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property($PankoSprite, "offset", Vector2(0, -16), .2)
	tween.tween_property($PankoSprite, "offset", Vector2(0, 0), .2)
	
func _on_button_lia_mouse_entered():
	name_label.text = "Rinkou Ashelia"
	name_label.modulate = Color.DEEP_PINK
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property($LiaSprite, "offset", Vector2(0, -16), .2)
	tween.tween_property($LiaSprite, "offset", Vector2(0, 0), .2)

func _on_button_tenma_mouse_entered():
	name_label.modulate = Color.PLUM
	name_label.text = "Tenma Maemi"
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property($TenmaSprite, "offset", Vector2(0, -16), .2)
	tween.tween_property($TenmaSprite, "offset", Vector2(0, 0), .2)

func _on_button_pippa_mouse_entered():
	name_label.text = "Pipkin Pippa"
	name_label.modulate = Color.PINK
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property($PippaSprite, "offset", Vector2(0, -19), .2)
	tween.tween_property($PippaSprite, "offset", Vector2(0, 0), .2)

func _on_button_lumi_mouse_entered():
	name_label.text = "Kaneko Lumi"
	name_label.modulate = Color.NAVAJO_WHITE
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property($LumiSprite, "offset", Vector2(0, -16), .2)
	tween.tween_property($LumiSprite, "offset", Vector2(0, 0), .2)


func _on_button_panko_mouse_exited():
	pass # Replace with function body.


func _on_button_lia_mouse_exited():
	pass # Replace with function body.


func _on_button_tenma_mouse_exited():
	pass # Replace with function body.


func _on_button_pippa_mouse_exited():
	pass # Replace with function body.


func _on_button_lumi_mouse_exited():
	pass # Replace with function body.
