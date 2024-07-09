extends Window
#Préchargement de certains fichier (sprite, scene, script, etc...).
@onready var preload_test_task = preload("res://Scene/Task/testtask.tscn")

#Les variables exportées sont visibles dans l'inspecteur de l'objet.

#Référence à la scène "Game".
var window_parent = null

#Référence à son bouton dans le menu Alt+Tab like.
var ref_buttonalttab = null


#Fonction appelée à l'initialisation de l'objet. La fenêtre charge alors une tâche.
func _ready():
	var tmp_task = preload_test_task.instantiate()
	add_child(tmp_task)
	title = tmp_task.name_task

#Fonction appelé à tout les tick physiques du jeu (par défaut 60 fois par seconde). "delta" est le temps entre chaque tick. 
func _physics_process(delta):
	
	#Vérifie que la fenêtre de tâche reste dans la fenêtre de jeu.
	var gamewindow_size = DisplayServer.window_get_size()
	
	if position.x + size.x > gamewindow_size.x:
		position.x = gamewindow_size.x - size.x
	elif position.x < 0:
		position.x = 0
	
	if position.y + size.y > gamewindow_size.y:
		position.y = gamewindow_size.y - size.y
	elif position.y < 0:
		position.y = 0


#Fonction qui permet de détruire la fenêtre, et donc la tâche. Préviens son pareznt, la scène de jeu "Game".
func DeleteWindow():
	window_parent.ThisWindowDelete(self)
	queue_free()

#Fonction appelée quand la fenêtre de tâche obtient le focus, quand le joueur lui clique dessus. Préviens son parent, la scène "Game", qu'elle récupère le focus.
func _on_focus_entered():
	window_parent.ChangeFocus(self)

