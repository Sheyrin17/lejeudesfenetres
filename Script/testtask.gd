extends Control
#Préchargement de certains fichier (sprite, scene, script, etc...).

#Les variables exportées sont visibles dans l'inspecteur de l'objet.
@export var name_task = "Test Task"


#Fonction appelée quand le bouton "Finish" est cliquée (résolution de la tâche). Demande à son parent "WindowTask" de s'effacer.
func _on_finish_pressed():
	get_parent().DeleteWindow()
