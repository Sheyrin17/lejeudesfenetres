extends Control
#Préchargement de certains fichier (sprite, scene, script, etc...).

#Les variables exportées sont visibles dans l'inspecteur de l'objet.
#Nom de la tâche, qui sera le titre de sa fenêtre de tâche.
@export var name_task = "Test Task"
#Valeur à ajouter à la ram lors de la création de la tâche.
#@export var ram_charge = 25

#Fonction appelée quand le bouton "Finish" est cliquée (résolution de la tâche). Demande à son parent "WindowTask" de s'effacer.
func _on_finish_pressed():
	get_parent().DeleteWindow()
