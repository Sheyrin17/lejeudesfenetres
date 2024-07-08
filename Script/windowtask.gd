extends Window
#Préchargement de certains fichier (sprite, scene, script, etc...).
@onready var preload_test_task = preload("res://Scene/Task/testtask.tscn")

#Les variables exportées sont visibles dans l'inspecteur de l'objet.


#Fonction appelée à l'initialisation de l'objet. La fenêtre charge alors une tâche.
func _ready():
	var tmp_task = preload_test_task.instantiate()
	add_child(tmp_task)
	title = tmp_task.name_task


#Fonction qui permet de détruire la fenêtre, et donc la tâche. Préviens son pareznt, la scène de jeu "Game".
func DeleteWindow():
	get_parent().ThisWindowDelete(self)
	queue_free()

#Fonction appelée quand la fenêtre de tâche obtient le focus, quand le joueur lui clique dessus. Préviens son parent, la scène "Game", qu'elle récupère le focus.
func _on_focus_entered():
	get_parent().ChangeFocus(self)

