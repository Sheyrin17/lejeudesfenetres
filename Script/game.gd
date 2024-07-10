extends Node2D


@onready var TimerBetweenLevels = $TimerBetweenLevels


@export var tab_all_level : Array[Node2D]


var current_level = 0


func _ready():
	TimerBetweenLevels.start()


func LaunchLevel():
	if current_level < tab_all_level.size():
		tab_all_level[current_level].StartLevel()


func _on_level_level_finish():
	print("level of " + tab_all_level[current_level].name + " finish." )
	
	current_level += 1
	
	if current_level < tab_all_level.size():
		TimerBetweenLevels.start()
	else:
		GameEnd()


func GameEnd():
	print("END")


func _on_timer_between_level_timeout():
	LaunchLevel()
