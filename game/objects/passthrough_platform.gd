extends Area2D

class_name passthrough_platform


signal disable
signal enable

func disable_platform():
	disable.emit()

func enable_platform():
	enable.emit()
