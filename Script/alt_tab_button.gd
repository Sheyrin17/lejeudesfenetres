extends Button

var ref_window = null


signal stop_alttab


func _ready():
	text = ref_window.title


func _on_pressed():
	ref_window.grab_focus()
	emit_signal("stop_alttab")
