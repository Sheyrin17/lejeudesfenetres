extends Window

@onready var preload_test_task = preload("res://Scene/Task/testtask.tscn")


func _ready():
	var tmp_task = preload_test_task.instantiate()
	add_child(tmp_task)
	title = tmp_task.name_task

func DeleteWindow():
	get_parent().ThisWindowDelete(self)
	queue_free()


func _on_focus_entered():
	get_parent().ChangeFocus(self)

