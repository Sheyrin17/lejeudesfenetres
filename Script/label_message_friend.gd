extends Label


func _ready():
	if get_parent().name.contains("PA"):
		custom_minimum_size.x = 200
