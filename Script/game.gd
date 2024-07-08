extends Node2D

#Préchargement de certains fichier (sprite, scene, script, etc...).
@onready var preload_window_task = preload("res://Scene/windowtask.tscn")

#Les variables exportées sont visibles dans l'inspecteur de l'objet.

#Sert à placer la prochaine fenêtre de tâche à côté de la dernière crée. Ce qui permet de la voir malgré qu'elle soit en dessous des autres fenêtres.
@export var offset_windows_when_create = Vector2(30,30)

#Tableau dont les éléments sont toutes les fenêtres de tâches existantes. L'ordre des éléments corresponds à l'ordre de focus des fenêtres.
var tab_window_exist = []

#Booléen qui permet d'autoriser les fenêtres à prendre le focus ou non.
var can_change_focus = true

var rng_number = RandomNumberGenerator.new()
#Fonction qui permet de donner à la fenêtre "wdw" le focus. Une réorganisation de "tab_window_exist" se fait alors.
func ChangeFocus(wdw):
	if !can_change_focus:
		return
	
	var tmp_tab_sort = []
	tmp_tab_sort += [wdw]
	
	for i in tab_window_exist:
		if i != wdw:
			tmp_tab_sort += [i]
	
	tab_window_exist = tmp_tab_sort


#Fonction qui permet d'effacer la fenêtre "wdw" de "tab_window_exist".
func ThisWindowDelete(wdw):
	tab_window_exist.erase(wdw)
	if tab_window_exist != []:
		tab_window_exist[0].grab_focus()


#Fonction appelée quand le timer "TimerLoadTask" se finit. Crée alors une nouvelle fenêtre de tâche. L'intègre à "tab_window_exist". La fait apparaître dans les limitations de la fenêtre de jeu.
func _on_timer_load_task_timeout():
	can_change_focus = false
	
	var tmp_window = preload_window_task.instantiate()
	add_child(tmp_window)
	
	#var pos_last_wdw = Vector2(0,0)
	#if tab_window_exist != []:
		#pos_last_wdw = tab_window_exist[-1].position
	
	var gamewindow_size = DisplayServer.window_get_size()
	
	var rng_x = rng_number.randi_range(offset_windows_when_create.x, gamewindow_size.x)
	var rng_y = rng_number.randi_range(offset_windows_when_create.y, gamewindow_size.y)
	
	tmp_window.position = Vector2(rng_x, rng_y)
	
	#tmp_window.position = Vector2(pos_last_wdw.x + offset_windows_when_create.x, pos_last_wdw.y + offset_windows_when_create.y)
	
	if tmp_window.position.x + tmp_window.size.x + offset_windows_when_create.x > gamewindow_size.x:
		tmp_window.position.x = gamewindow_size.x - tmp_window.size.x - offset_windows_when_create.x
	
	if tmp_window.position.y + tmp_window.size.y + offset_windows_when_create.y > gamewindow_size.y:
		tmp_window.position.y = gamewindow_size.y - tmp_window.size.y - offset_windows_when_create.y
	
	if tab_window_exist != []:
		var focus_elem = tab_window_exist.pop_front()
		tab_window_exist.push_front(tmp_window)
		tab_window_exist.push_front(focus_elem)
	else:
		tab_window_exist.push_front(tmp_window)
	
	#tab_window_exist += [tmp_window]
	#for i in range(tab_window_exist.size()-1, 0, -1):
		#tab_window_exist[i].grab_focus()
		
	tab_window_exist[0].grab_focus()
	
	can_change_focus = true
