extends Node2D

#Préchargement de certains fichier ou objet/node (sprite, scene, script, node, etc...).
@onready var preload_window_task = preload("res://Scene/windowtask.tscn")
@onready var preload_alttabbutton = preload("res://Scene/alt_tab_button.tscn")

@onready var HBoxAltTab = $HUD/HBoxAltTab

@onready var SubWindowsTask = $CanvasSubWindows/SubWindowsContainer/SubWindowsTask

#Les variables exportées sont visibles dans l'inspecteur de l'objet.

#Sert à placer la prochaine fenêtre de tâche à côté de la dernière crée. Ce qui permet de la voir malgré qu'elle soit en dessous des autres fenêtres.
@export var offset_windows_when_create = Vector2(30,30)

#Tableau dont les éléments sont toutes les fenêtres de tâches existantes. L'ordre des éléments corresponds à l'ordre de focus des fenêtres.
var tab_window_exist = []

var tab_button_alttab = []

#Booléen qui permet d'autoriser les fenêtres à prendre le focus ou non.
var can_change_focus = true

#Booléen qui permet d'autoriser l'ouverture du menu Alt+Tab like.
var can_alttab = true

#Variable qui va permettre de générer des nombres aléatoire.
var rng_number = RandomNumberGenerator.new()


#Fonction qui est appelée à l'initialisation de l'objet, ici la scène "Game".
func _ready():
	SubWindowsTask.gui_embed_subwindows = true;
	SubWindowsTask.size = DisplayServer.window_get_size()


#Fonction appelé à tout les tick physiques du jeu (par défaut 60 fois par seconde). "delta" est le temps entre chaque tick. 
func _physics_process(delta):
	if Input.is_action_pressed("A") and Input.is_action_pressed("Alt") and can_alttab:
		if !HBoxAltTab.visible:
			HBoxAltTab.visible = true
			if tab_button_alttab != []:
				tab_button_alttab[0].grab_focus()
			can_alttab = false
			
			#if tab_button_alttab != []:
				#for i in tab_button_alttab:
					#HBoxAltTab.add_child(i.instantiate())
	
	if Input.is_action_just_released("Alt") or Input.is_action_just_pressed("Enter"):
		StopAltTab()
		can_alttab = true
	
	#if Input.is_action_pressed("A") and Input.is_action_pressed("Alt") and !can_alttab:
		#if tab_button_alttab != []:
			#for i in tab_button_alttab:
				#if i.has_focus():
					#if i.find_valid_focus_neighbor(2) != null:
						#i.find_valid_focus_neighbor(2).grab_focus()
						#break


#Fonction qui permet de donner à la fenêtre "wdw" le focus. Une réorganisation de "tab_window_exist" se fait alors.
func ChangeFocus(wdw):
	if !can_change_focus:
		return
	
	var tmp_tab_sort = []
	tmp_tab_sort.push_front(wdw)
	
	for i in tab_window_exist:
		if i != wdw:
			tmp_tab_sort.push_back(i)
	
	tab_window_exist = tmp_tab_sort
	
	UpdateOrderAltTab(wdw)
	
	
	StopAltTab()

#Fonction qui permet de réorganiser "tab_button_alt" suivant l'ordre de focus des fenêtres de tâches où "wdw" est la fenêtre qui prend le focus.
func UpdateOrderAltTab(wdw):
	var tmp_tab_button = []
	tmp_tab_button.push_front(wdw.ref_buttonalttab)
	
	for i in tab_button_alttab:
		if i != wdw.ref_buttonalttab:
			tmp_tab_button.push_back(i)
	
	tab_button_alttab = tmp_tab_button
	HBoxAltTab.move_child(wdw.ref_buttonalttab, 0)
	
	UpdateFocusOrderAltTab()


#Fonction qui permet de réorganiser les voisins des boutons de la fenêtre Alt+Tab like. Ce qui permet de passer d'un bouton à l'autre en utilisant des touches du clavier, comme les flèches droite/gauche ou encore en appuyant sur A.
func UpdateFocusOrderAltTab():
	
	if HBoxAltTab.get_child_count() > 1:
		for i in range(0, HBoxAltTab.get_child_count()):
			if i > 0:
				HBoxAltTab.get_children()[i].focus_neighbor_left = HBoxAltTab.get_children()[i-1].get_path()
			if i+1 < HBoxAltTab.get_child_count():
				HBoxAltTab.get_children()[i].focus_neighbor_right = HBoxAltTab.get_children()[i+1].get_path()
		
		HBoxAltTab.get_children()[0].focus_neighbor_left = HBoxAltTab.get_children()[-1].get_path()
		HBoxAltTab.get_children()[-1].focus_neighbor_right = HBoxAltTab.get_children()[0].get_path()


#Fonction qui permet d'effacer la fenêtre "wdw" de "tab_window_exist".
func ThisWindowDelete(wdw):
	for i in tab_button_alttab:
		if i.ref_window == wdw:
			tab_button_alttab.erase(i)
			i.queue_free()
	
	tab_window_exist.erase(wdw)
	if tab_window_exist != []:
		tab_window_exist[0].grab_focus()


#Fonction appelée quand le timer "TimerLoadTask" se finit. Crée alors une nouvelle fenêtre de tâche. L'intègre à "tab_window_exist". La fait apparaître dans les limitations de la fenêtre de jeu. Crée un bouton dans "HBoxAltTab" qui fait référence à cette fenêtre.
func _on_timer_load_task_timeout():
	can_change_focus = false
	
	var tmp_window = preload_window_task.instantiate()
	tmp_window.window_parent = self
	SubWindowsTask.add_child(tmp_window)
	
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
	
	var button_alttab = preload_alttabbutton.instantiate()
	
	if tab_window_exist != []:
		var focus_elem = tab_window_exist.pop_front()
		tab_window_exist.push_front(tmp_window)
		tab_window_exist.push_front(focus_elem)
		
		var focus_first_elem = tab_button_alttab.pop_front()
		tab_button_alttab.push_front(button_alttab)
		tab_button_alttab.push_front(focus_first_elem)
	
	else:
		tab_window_exist.push_front(tmp_window)
		
		
		tab_button_alttab.push_front(button_alttab)
	
	button_alttab.ref_window = tmp_window
	tmp_window.ref_buttonalttab = button_alttab
	HBoxAltTab.add_child(button_alttab)
	button_alttab.connect("stop_alttab", StopAltTab)
	UpdateFocusOrderAltTab()
	
	tab_window_exist[0].grab_focus()
	
	can_change_focus = true


#Foncion qui permet de cacher le menu Alt+Tab like.
func StopAltTab():
	can_alttab = false
	for i in tab_button_alttab:
		if i.has_focus():
			i.ref_window.grab_focus()
	HBoxAltTab.visible = false
