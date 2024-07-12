extends Node2D

@onready var LabelMessageCharacter = preload("res://Scene/label_message_character.tscn")
@onready var LabelMessageFriend = preload("res://Scene/label_message_friend.tscn")
@onready var ButtonToAdd = preload("res://Scene/button_to_add.tscn")

@onready var TimerBetweenPhases = $TimerBetweenPhases

@onready var AnimDay = $AnimDay

@onready var PopUp = $PopUp
@onready var PopUpNotif = $PopUp/PopUpNotif
@onready var PopUpContacts = $PopUp/PopUpContacts
@onready var PopUpDiscussion = $PopUp/PopUpDiscussion
@onready var PopUpDownloadBar = $PopUp/PopUpDownloadPA
@onready var PopUpPA = $PopUp/PopUpPA

@onready var VBoxMessagePA = $PopUp/PopUpPA/ScrollMessagePA/VBoxMessagePA
@onready var ButtonAnswerPAA = $PopUp/PopUpPA/BackgroundAnswer/VBoxAnswer/ButtonAnswerPAA
@onready var ButtonAnswerPAB = $PopUp/PopUpPA/BackgroundAnswer/VBoxAnswer/ButtonAnswerPAB

@onready var LabelPAWriting = $PopUp/PopUpPA/BackgroundAll/LabelPAWriting
@onready var LabelCharacterWritingPA = $PopUp/PopUpPA/BackgroundAnswer/VBoxAnswer/LabelCharacterWriting

@onready var LabelFriendWriting = $PopUp/PopUpDiscussion/BackgroundAll/LabelFriendWriting
@onready var LabelCharacterWriting = $PopUp/PopUpDiscussion/BackgroundAnswer/VBoxAnswer/LabelCharacterWriting

@onready var VBoxMessage = $PopUp/PopUpDiscussion/ScrollMessage/VBoxMessage
@onready var ButtonAnswerA = $PopUp/PopUpDiscussion/BackgroundAnswer/VBoxAnswer/ButtonAnswerA
@onready var ButtonAnswerB = $PopUp/PopUpDiscussion/BackgroundAnswer/VBoxAnswer/ButtonAnswerB

@onready var ScrollMessage = $PopUp/PopUpDiscussion/ScrollMessage

@onready var ScrollMessagePA = $PopUp/PopUpPA/ScrollMessagePA

@onready var TextureInfoGame = $HUDDay/TextureInfoGame

@export var tab_all_level : Array[Node2D]

@export var tab_first_dialog_with_friend_phasedialog1 : Array[String]
var current_message_with_friend_phasedialog1 = 0

@export var tab_first_dialog_with_pa_phasedialog1 : Array[String]
var current_message_with_pa_phasedialog1 = 0

@export var tab_pa_encouraging : Array[String]

@export var tab_break_dialog : Array[String]
var current_message_break_dialog = 0

@export var tab_endday_dialog_with_pa : Array[String]
var current_message_endday_dialog_with_pa = 0

@export var tab_endday_dialog_with_friend : Array[String]
var current_message_endday_dialog_with_friend = 0

var time_to_show_message = 0

var is_making_a_choice = false

enum PHASE { LOADING, DIALOG_FRIEND, LEVEL_1, DIALOG_BREAK, LEVEL_2, DIALOG_ENDDAY }
var current_phase = PHASE.LOADING

var current_level = 0

var pa_is_encouraging = true

#Variable qui va permettre de générer des nombres aléatoire.
var rng_number = RandomNumberGenerator.new()

signal phase_changed


func _ready():
	#TimerBetweenLevels.start()
	current_phase = PHASE.LOADING
	#current_phase = PHASE.DIALOG_BREAK
	#emit_signal("phase_changed")
	AnimDay.play("loading_desktop")
	
	current_message_with_friend_phasedialog1 = await ChatWithFriend(current_message_with_friend_phasedialog1, tab_first_dialog_with_friend_phasedialog1)


#func LaunchLevel():
	#if current_level < tab_all_level.size():
		#tab_all_level[current_level].StartLevel()


func GameEnd():
	print("END")


func _on_timer_between_level_timeout():
	if current_phase == PHASE.LOADING:
		current_phase = PHASE.DIALOG_FRIEND
		emit_signal("phase_changed")
	
	if current_phase == PHASE.DIALOG_FRIEND and tab_first_dialog_with_friend_phasedialog1.size() != current_message_with_friend_phasedialog1 and !is_making_a_choice:
		if !PopUpNotif.visible:
			current_message_with_friend_phasedialog1 = await ChatWithFriend(current_message_with_friend_phasedialog1, tab_first_dialog_with_friend_phasedialog1)
	
	elif current_phase == PHASE.DIALOG_FRIEND and tab_first_dialog_with_friend_phasedialog1.size() == current_message_with_friend_phasedialog1 and !is_making_a_choice and (!PopUpDownloadBar.visible and !PopUpDiscussion.visible):
		current_message_with_pa_phasedialog1 = await ChatWithPA(current_message_with_pa_phasedialog1, tab_first_dialog_with_pa_phasedialog1)
		
		if current_phase == PHASE.DIALOG_FRIEND and tab_first_dialog_with_pa_phasedialog1.size() == current_message_with_pa_phasedialog1 and !is_making_a_choice:
			current_phase += 1
			emit_signal("phase_changed")
	
	if current_phase == PHASE.LEVEL_1:
		pass
	
	if current_phase == PHASE.DIALOG_BREAK and !is_making_a_choice and tab_break_dialog.size() != current_message_break_dialog:
		current_message_break_dialog = await ChatWithPA(current_message_break_dialog, tab_break_dialog)
	
	elif current_phase == PHASE.DIALOG_BREAK and tab_break_dialog.size() == current_message_break_dialog and !is_making_a_choice:
		current_phase += 1
		emit_signal("phase_changed")
	
	if current_phase == PHASE.LEVEL_2:
		pass
	
	if current_phase == PHASE.DIALOG_ENDDAY and tab_endday_dialog_with_pa.size() != current_message_endday_dialog_with_pa and !is_making_a_choice:
		current_message_endday_dialog_with_pa = await ChatWithPA(current_message_endday_dialog_with_pa, tab_endday_dialog_with_pa)
	
	elif current_phase == PHASE.DIALOG_ENDDAY and tab_endday_dialog_with_pa.size() == current_message_endday_dialog_with_pa and !is_making_a_choice and current_message_endday_dialog_with_friend != tab_endday_dialog_with_friend.size():
		if current_message_endday_dialog_with_friend == 0:
			PopUpNotif.show()
		current_message_endday_dialog_with_friend = await ChatWithFriend(current_message_endday_dialog_with_friend, tab_endday_dialog_with_friend)
	
	
	elif current_phase == PHASE.DIALOG_ENDDAY and tab_endday_dialog_with_friend.size() == current_message_endday_dialog_with_friend and !is_making_a_choice:
		
		PopUpDiscussion.hide()
		PopUpPA.hide()
		
		AnimDay.play("end_day")


func _on_anim_day_animation_finished(anim_name):
	if anim_name == "loading_desktop":
		TimerBetweenPhases.start()
	
	if anim_name == "end_day":
		print("end of the day")


func _on_pop_up_notif_close_requested():
	PopUpNotif.hide()


func _on_phase_changed():
	match current_phase:
		PHASE.LOADING:
			pass
		
		PHASE.DIALOG_FRIEND:
			PopUpNotif.show()
			current_message_with_friend_phasedialog1 = await ChatWithFriend(current_message_with_friend_phasedialog1, tab_first_dialog_with_friend_phasedialog1)
		
		PHASE.LEVEL_1:
			tab_all_level[current_level].StartLevel()
		
		PHASE.DIALOG_BREAK:
			current_message_break_dialog = await ChatWithPA(current_message_break_dialog, tab_break_dialog)
		
		PHASE.LEVEL_2:
			tab_all_level[current_level].StartLevel()
		
		PHASE.DIALOG_ENDDAY:
			current_message_endday_dialog_with_pa = await ChatWithPA(current_message_endday_dialog_with_pa, tab_endday_dialog_with_pa)


func _on_button_contact_pressed():
	PopUpNotif.hide()
	PopUpContacts.show()


func _on_pop_up_contacts_close_requested():
	PopUpContacts.hide()


func _on_button_friend_pressed():
	PopUpContacts.hide()
	PopUpNotif.hide()
	PopUpDiscussion.show()


func _on_pop_up_discussion_close_requested():
	PopUpDiscussion.hide()


func _on_button_answer_a_pressed():
	CharacterSendMessageButton(ButtonAnswerA, ButtonAnswerA.text)
	ButtonAnswerA.visible = false
	ButtonAnswerB.visible = false


func _on_button_answer_b_pressed():
	CharacterSendMessageButton(ButtonAnswerB, ButtonAnswerB.text)
	ButtonAnswerA.visible = false
	ButtonAnswerB.visible = false


func CharacterSendMessageButton(button, message):
	var tmp_message_character = LabelMessageCharacter.instantiate()
	tmp_message_character.text = message
	
	if button.get_parent().get_parent().get_parent() == PopUpDiscussion:
		if time_to_show_message != 0:
			LabelCharacterWriting.visible = true
			await get_tree().create_timer(time_to_show_message).timeout
			LabelCharacterWriting.visible = false
		
		VBoxMessage.add_child(tmp_message_character)
		ScrollMessage.NewMessage()
	
	elif button.get_parent().get_parent().get_parent() == PopUpPA:
		if time_to_show_message != 0:
			LabelCharacterWritingPA.visible = true
			await get_tree().create_timer(time_to_show_message).timeout
			LabelCharacterWritingPA.visible = false
		
		VBoxMessagePA.add_child(tmp_message_character)
		ScrollMessagePA.NewMessage()
	
	is_making_a_choice = false
	TimerBetweenPhases.start()


func ChatWithFriend(current_index, tab_dialog):
	if current_index < tab_dialog.size():
		if tab_dialog[current_index].begins_with("Character : "):
			
			var tmp_message = ""
			if tab_dialog[current_index].contains("["):
				var tmp_message_time = tab_dialog[current_index].erase(0,12)
				var tmp_split_message_time = tmp_message_time.split("[")
				
				tmp_message = tmp_split_message_time[0]
				time_to_show_message = tmp_split_message_time[1].to_int()
			
			else:
				tmp_message = tab_dialog[current_index].erase(0,12)
			
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
				LabelCharacterWriting.visible = true
				await get_tree().create_timer(time_to_show_message).timeout
				LabelCharacterWriting.visible = false
				VBoxMessage.add_child(tmp_message_character)
				
		
		elif tab_dialog[current_index].begins_with("Friend : "):
			
			var tmp_message = ""
			if tab_dialog[current_index].contains("["):
				var tmp_message_time = tab_dialog[current_index].erase(0,9)
				var tmp_split_message_time = tmp_message_time.split("[")
				
				tmp_message = tmp_split_message_time[0]
				time_to_show_message = tmp_split_message_time[1].to_int()
			else:
				tmp_message = tab_dialog[current_index].erase(0,9)
				
			var tmp_label_friend = LabelMessageFriend.instantiate()
			tmp_label_friend.text = tmp_message
			LabelFriendWriting.visible = true
			await get_tree().create_timer(time_to_show_message).timeout
			LabelFriendWriting.visible = false
			VBoxMessage.add_child(tmp_label_friend)
		
		elif tab_dialog[current_index].contains("&"):
			if tab_dialog[current_index].length() > 1:
				var tmp_button = ButtonToAdd.instantiate()
				tmp_button.text = tab_dialog[current_index].erase(0,1)
				tmp_button.pressed.connect(PressDownloadPA)
				VBoxMessage.add_child(tmp_button)
		
		current_index += 1
		ScrollMessage.NewMessage()
		TimerBetweenPhases.start()
	
	return current_index


func PressDownloadPA():
	var tmp_button = null
	for i in VBoxMessage.get_children():
		if i is Button:
			tmp_button = i
			tmp_button.pressed.disconnect(PressDownloadPA)
	PopUpDownloadBar.show()


func _on_pop_up_download_pa_download_finish():
	PopUpContacts.hide()
	PopUpDiscussion.hide()
	PopUpDownloadBar.hide()
	TimerBetweenPhases.start()
	PopUpPA.show()


func ChatWithPA(current_index, tab_dialog):
	if current_index < tab_dialog.size():
		if tab_dialog[current_index].begins_with("Character : "):
			var tmp_message = ""
			
			if tab_dialog[current_index].contains("["):
				var tmp_message_time = tab_dialog[current_index].erase(0,12)
				var tmp_split_message_time = tmp_message_time.split("[")
				
				tmp_message = tmp_split_message_time[0]
				time_to_show_message = tmp_split_message_time[1].to_int()
			
			else:
				tmp_message = tab_dialog[current_index].erase(0,12)
			
			if tmp_message.contains(";"):
				var button_messages = tmp_message.split(";")
				
				ButtonAnswerPAA.visible = true
				ButtonAnswerPAA.text = button_messages[0]
				
				ButtonAnswerPAB.visible = true
				ButtonAnswerPAB.text = button_messages[1]
				
				is_making_a_choice = true
			
			else:
				var tmp_message_character = LabelMessageCharacter.instantiate()
				tmp_message_character.text = tmp_message
				LabelCharacterWritingPA.visible = true
				await get_tree().create_timer(time_to_show_message).timeout
				LabelCharacterWritingPA.visible = false
				VBoxMessagePA.add_child(tmp_message_character)
		
		#elif tab_dialog[current_index].contains("<"):
			#var tmp_message = tab_dialog[current_index].erase(0,5)
			#
			#var tmp_ = tmp_message.split("<")
			#var tmp_1 = tmp_[0]
			#var tmp_2 = tmp_[1]
			#
			#if tab_all_level[current_level].game_mode == 0:
				#tmp_1 = tmp_1 + str(tab_all_level[current_level].timer_playmode_wait_time) + tmp_2
			#
			#elif tab_all_level[current_level].game_mode == 1:
				#tmp_1 = tmp_1 + str(tab_all_level[current_level].nb_task_to_finish) + tmp_2
			#
			#var tmp_label_friend = LabelMessageFriend.instantiate()
			#tmp_label_friend.text = tmp_1
			#VBoxMessagePA.add_child(tmp_label_friend)
			#TimerBetweenPhases.start()
		
		elif tab_dialog[current_index].begins_with("PA : "):
			var tmp_message = ""
			
			if tab_dialog[current_index].contains("["):
				var tmp_message_time = tab_dialog[current_index].erase(0,5)
				var tmp_split_message_time = tmp_message_time.split("[")
				
				tmp_message = tmp_split_message_time[0]
				time_to_show_message = tmp_split_message_time[1].to_int()
			
			else:
				tmp_message = tab_dialog[current_index].erase(0,5)
			
			if tmp_message.contains("<"):
				var tmp_ = tmp_message.split("<")
				var tmp_1 = tmp_[0]
				var tmp_2 = tmp_[1]
				
				if tab_all_level[current_level].game_mode == 0:
					tmp_1 = tmp_1 + str(tab_all_level[current_level].timer_playmode_wait_time) + tmp_2
				
				elif tab_all_level[current_level].game_mode == 1:
					tmp_1 = tmp_1 + str(tab_all_level[current_level].nb_task_to_finish) + tmp_2
				
				tmp_message = tmp_1
			
			var tmp_label_friend = LabelMessageFriend.instantiate()
			tmp_label_friend.text = tmp_message
			LabelPAWriting.visible = true
			await get_tree().create_timer(time_to_show_message).timeout
			LabelPAWriting.visible = false
			VBoxMessagePA.add_child(tmp_label_friend)
		
		elif tab_dialog[current_index].contains("&"):
			pass
		
		current_index += 1
		ScrollMessagePA.NewMessage()
		TimerBetweenPhases.start()
	
	return current_index


func _on_button_answer_paa_pressed():
	CharacterSendMessageButton(ButtonAnswerPAA, ButtonAnswerPAA.text)
	ButtonAnswerPAA.visible = false
	ButtonAnswerPAB.visible = false


func _on_button_answer_pab_pressed():
	CharacterSendMessageButton(ButtonAnswerPAB, ButtonAnswerPAB.text)
	ButtonAnswerPAA.visible = false
	ButtonAnswerPAB.visible = false


func _on_level_0_level_finish():
	@warning_ignore("int_as_enum_without_cast")
	current_phase += 1
	current_level += 1
	emit_signal("phase_changed")


func _on_level_1_level_finish():
	@warning_ignore("int_as_enum_without_cast")
	current_phase += 1
	current_level += 1
	emit_signal("phase_changed")


func OnAnyFinishTask():
	if pa_is_encouraging:
		var tmp_index = rng_number.randi_range(0, tab_pa_encouraging.size()-1)
		
		var tmp_label_friend = LabelMessageFriend.instantiate()
		tmp_label_friend.text = tab_pa_encouraging[tmp_index]
		VBoxMessagePA.add_child(tmp_label_friend)
		ScrollMessagePA.NewMessage()


func _on_pop_up_discussion_visibility_changed():
	if PopUpDiscussion != null and PopUpDiscussion.visible:
		ScrollMessage.NewMessage()
