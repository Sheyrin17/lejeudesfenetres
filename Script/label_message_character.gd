extends Label


func _ready():
	if get_parent().name.contains("PA"):
		custom_minimum_size.x = 200


@warning_ignore("unused_parameter")
func _physics_process(delta):
	var tmp_line = get_line_count()
	if tmp_line > 1:
		@warning_ignore("int_as_enum_without_cast")
		set_horizontal_alignment(0)
	set_physics_process(false)
