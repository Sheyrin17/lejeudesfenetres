extends Label

func _physics_process(delta):
	var tmp_line = get_line_count()
	if tmp_line > 1:
		set_horizontal_alignment(0)
	set_physics_process(false)
