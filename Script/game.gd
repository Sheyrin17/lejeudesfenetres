extends Node2D

@onready var LabelMessageCharacter = preload("res://Scene/label_message_character.tscn")
@onready var LabelMessageFriend = preload("res://Scene/label_message_friend.tscn")

@onready var TimerBetweenPhases = $TimerBetweenPhases

@onready var AnimDay = $AnimDay

@onready var PopUp = $PopUp
@onready var PopUpNotif = $PopUp/PopUpNotif
@onready var PopUpContacts = $PopUp/PopUpContacts
@onready var PopUpDiscussion = $PopUp/PopUpDiscussion

@onready var VBoxMessage = $PopUp/PopUpDiscussion/ScrollMessage/VBoxMessage
@onready var ButtonAnswerA = $PopUp/PopUpDiscussion/BackgroundAnswer/VBoxAnswer/ButtonAnswerA
@onready var ButtonAnswerB = $PopUp/PopUpDiscussion/BackgroundAnswer/VBoxAnswer/ButtonAnswerB

@onready var ScrollMessage = $PopUp/PopUpDiscussion/ScrollMessage

@export var tab_all_level : Array[Node2D]

@export var tab_first_dialog_with_friend : Array[String]
var current_message_with_friend = 0

var is_making_a_choice = false

enum PHASE { LOADING, DIALOG_FRIEND, LEVEL_1, DIALOG_BREAK, LEVEL_2, DIALOG_ENDDAY }
var current_phase = PHASE.LOADING

var current_level = 0


signal phase_changed


func _ready():
	#TimerBetweenLevels.start()
	current_phase = PHASE.LOADING
	AnimDay.play("loading_desktop")
	
	ChatWithFriend()


func LaunchLevel():
	if current_level < tab_all_level.size():
		tab_all_level[current_level].StartLevel()


func _on_level_level_finish():
	print("level of " + tab_all_level[current_level].name + " finish." )
	
	current_level += 1
	
	if current_level < tab_all_level.size():
		TimerBetweenPhases.start()
	else:
		GameEnd()


func GameEnd():
	print("END")


func _on_timer_between_level_timeout():
	if current_phase == PHASE.LOADING:
		current_phase = PHASE.DIALOG_FRIEND
		emit_signal("phase_changed")
	
	if current_phase == PHASE.DIALOG_FRIEND and tab_first_dialog_with_friend.size() != current_message_with_friend and !is_making_a_choice:
		ChatWithFriend()


func _on_anim_day_animation_finished(anim_name):
	if anim_name == "loading_desktop":
		TimerBetweenPhases.start()


func _on_pop_up_notif_close_requested():
	PopUpNotif.hide()


func _on_phase_changed():
	match current_phase:
		PHASE.LOADING:
			pass
		
		PHASE.DIALOG_FRIEND:
			PopUpNotif.show()
			ChatWithFriend()
		
		PHASE.LEVEL_1:
			pass
		
		PHASE.DIALOG_BREAK:
			pass
		
		PHASE.LEVEL_2:
			pass
		
		PHASE.DIALOG_ENDDAY:
			pass


func _on_button_contact_pressed():
	PopUpNotif.hide()
	PopUpContacts.show()


func _on_pop_up_contacts_close_requested():
	PopUpContacts.hide()


func _on_button_friend_pressed():
	PopUpContacts.hide()
	PopUpDiscussion.show()


func _on_pop_up_discussion_close_requested():
	PopUpDiscussion.hide()


func _on_button_answer_a_pressed():
	CharacterSendMessageButton(ButtonAnswerA.text)
	ButtonAnswerA.visible = false
	ButtonAnswerB.visible = false


func _on_button_answer_b_pressed():
	CharacterSendMessageButton(ButtonAnswerB.text)
	ButtonAnswerA.visible = false
	ButtonAnswerB.visible = false


func CharacterSendMessageButton(message):
	var tmp_message_character = LabelMessageCharacter.instantiate()
	tmp_message_character.text = message
	VBoxMessage.add_child(tmp_message_character)
	is_making_a_choice = false
	TimerBetweenPhases.start()


func ChatWithFriend():
	if current_message_with_friend < tab_first_dialog_with_friend.size():
		if tab_first_dialog_with_friend[current_message_with_friend].begins_with("Character : "):
			var tmp_message = tab_first_dialog_with_friend[current_message_with_friend].erase(0,12)
			if tmp_message.contains(";"):
				var button_messages = tmp_message.split(";")
				
				ButtonAnswerA.visible = true
				ButtonAnswerA.text = button_messages[0]
				
				ButtonAnswerB.visible = true
				ButtonAnswerB.text = button_messages[1]
				
				is_making_a_choice = true
			
			else:
				var tmp_message_character = LabelMessageCharacter.instantiate()
				tmp_message_character.text = tmp_message
				VBoxMessage.add_child(tmp_message_character)
				TimerBetweenPhases.start()
		
		elif tab_first_dialog_with_friend[current_message_with_friend].begins_with("Friend : "):
			var tmp_message = tab_first_dialog_with_friend[current_message_with_friend].erase(0,9)
			var tmp_label_friend = LabelMessageFriend.instantiate()
			tmp_label_friend.text = tmp_message
			VBoxMessage.add_child(tmp_label_friend)
			TimerBetweenPhases.start()
		
		elif tab_first_dialog_with_friend[current_message_with_friend].contains("&"):
			print("EndDialog")
			TimerBetweenPhases.start()
		
		current_message_with_friend += 1
