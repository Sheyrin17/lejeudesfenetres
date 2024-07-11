extends Window

@export var ProgressDownloadBar : ProgressBar
@onready var TimerDownloadPA = $TimerDownloadPA

var signal_send = false

signal download_finish


func _on_timer_download_pa_timeout():
	ProgressDownloadBar.value += 1
	if ProgressDownloadBar.value == 100 and !TimerDownloadPA.is_stopped():
		TimerDownloadPA.stop()
		SendSignal()


func SendSignal():
	if !signal_send:
		signal_send = true
		TimerDownloadPA.stop()
		TimerDownloadPA.queue_free()
		emit_signal("download_finish")
		


func _on_visibility_changed():
	if visible:
		TimerDownloadPA.start()
