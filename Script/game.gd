extends Node2D

@onready var preload_window_task = preload("res://Scene/windowtask.tscn")

@export var offset_windows_when_create = Vector2(30,30)

var tab_window_exist = []

var can_change_focus = true


func ChangeFocus(wdw):
	if !can_change_focus:
		return
	
	var tmp_tab_sort = []
	tmp_tab_sort += [wdw]
	
	for i in tab_window_exist:
		if i != wdw:
			tmp_tab_sort += [i]
	
	tab_window_exist = tmp_tab_sort


func ThisWindowDelete(wdw):
	tab_window_exist.erase(wdw)
	if tab_window_exist != []:
		tab_window_exist[0].grab_focus()


func _on_timer_load_task_timeout():
	can_change_focus = false
	
	var tmp_window = preload_window_task.instantiate()
	add_child(tmp_window)
	
	var pos_last_wdw = Vector2(0,0)
	if tab_window_exist != []:
		pos_last_wdw = tab_window_exist[-1].position
	
	tab_window_exist += [tmp_window]
	
	for i in range(tab_window_exist.size()-1, 0, -1):
		tab_window_exist[i].grab_focus()
	tab_window_exist[0].grab_focus()
	
	tmp_window.position = Vector2(pos_last_wdw.x + offset_windows_when_create.x, pos_last_wdw.y + offset_windows_when_create.y)
	
	var gamewindow_size = DisplayServer.window_get_size()
	if tmp_window.position.x + tmp_window.size.x + offset_windows_when_create.x > gamewindow_size.x:
		tmp_window.position.x = gamewindow_size.x - tmp_window.size.x - offset_windows_when_create.x
	
	if tmp_window.position.y + tmp_window.size.y + offset_windows_when_create.y > gamewindow_size.y:
		tmp_window.position.y = gamewindow_size.y - tmp_window.size.y - offset_windows_when_create.y
	
	
	can_change_focus = true
