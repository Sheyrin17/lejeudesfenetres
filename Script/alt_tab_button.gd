extends Button

signal stop_alttab

#Référence à la fenêtre de tâche à laquelle ce bouton est associé. Bouton qui sera dans le menu Alt+Tab like.
var ref_window = null

#Fonction appelée à l'initialisation de l'objet. La fenêtre charge alors une tâche.
func _ready():
	text = ref_window.title

#Fonction appelée quand le bouton est pressé. Emit le signal "stop_altab" qui est reçu par la scène "Game" et qui permet de cacher le menu Alt+Tab like. Donne le focus à la fenêtre qui est associé au bouton.
func _on_pressed():
	ref_window.grab_focus()
	emit_signal("stop_alttab")
