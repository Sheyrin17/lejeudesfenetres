extends ScrollContainer


@warning_ignore("unused_parameter")
func _physics_process(delta):
	set_deferred("scroll_vertical", max( 0, get_children()[0].get_rect().size.y - get_rect().size.y  ) )
