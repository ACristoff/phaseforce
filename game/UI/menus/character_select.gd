extends Control

signal chosen_character

#I know there's a more efficient way to do this but I'm crunching
func _on_button_panko_pressed():
	chosen_character.emit("panko")

func _on_button_lia_pressed():
	chosen_character.emit("lia")	

func _on_button_tenma_pressed():
	chosen_character.emit("tenma")

func _on_button_pippa_pressed():
	chosen_character.emit("pippa")
