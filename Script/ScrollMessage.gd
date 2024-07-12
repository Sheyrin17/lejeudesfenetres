extends ScrollContainer

var auto_scroll = false

@warning_ignore("unused_parameter")
func _physics_process(delta):
	if auto_scroll:
		set_deferred("scroll_vertical", max( 0, get_children()[0].get_rect().size.y - get_rect().size.y  ) )


func NewMessage():
	auto_scroll = true
	await get_tree().create_timer(0.2).timeout
	auto_scroll = false
