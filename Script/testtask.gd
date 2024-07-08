extends Control

@export var name_task = "Test Task"

func _on_finish_pressed():
	get_parent().DeleteWindow()
