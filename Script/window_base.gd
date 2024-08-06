extends Control

@export var can_window_be_moved = true
@export var can_window_be_resized = true

#@export var resize_border = 5

var start_pos = Vector2()
var initial_pos = Vector2()

var is_moving = false
var can_move = false

var is_size_double = false

#var initial_size = Vector2()

#var is_resizing_x = false
#var is_resizing_y = false

func _input(event):
	if can_move and can_window_be_moved:
		if Input.is_action_just_pressed("LeftClick"):
			start_pos = event.position
			initial_pos = get_global_position()
			is_moving = true
		
		if Input.is_action_pressed("LeftClick"):
			if is_moving:
				set_position(initial_pos + (event.position - start_pos) )
		
		if Input.is_action_just_released("LeftClick"):
			is_moving = false
			initial_pos = Vector2(0,0)
	
	
	#if can_window_be_resized and !is_moving:
		#
		#if Input.is_action_just_pressed("LeftClick"):
		#
			#var rect = get_global_rect()
			#var local_mouse_pos = event.position - get_global_position()
			#if abs( local_mouse_pos.x - rect.size.x ) < resize_border:
				#start_pos.x = event.position.x
				#initial_size.x = get_size().x
				#is_resizing_x = true
			#
			#if abs( local_mouse_pos.y - rect.size.y ) < resize_border :
				#start_pos.y = event.position.y
				#initial_size.y = get_size().y
				#is_resizing_y = true
			#
			#if local_mouse_pos.x < resize_border and local_mouse_pos.x > -resize_border:
				#start_pos.x = event.position.x
				#initial_pos.x = get_global_position().x
				#initial_size.x = get_size().x
				#is_resizing_x = true
			#
			#if local_mouse_pos.y < resize_border and local_mouse_pos.y > -resize_border:
				#start_pos.y = event.position.y
				#initial_pos.y = get_global_position().y
				#initial_size.y = get_size().y
				#is_resizing_y = true
		#
		#if Input.is_action_pressed("LeftClick"):
			#if is_resizing_x or is_resizing_y:
				#var new_width = get_size().x
				#var new_height = get_size().y
				#
				#if is_resizing_x:
					#new_width = initial_size.x - (start_pos.x - event.position.x)
				#
				#if is_resizing_y:
					#new_height = initial_size.y - (start_pos.y - event.position.y)
				#
				#if initial_pos.x != 0:
					#new_width = initial_size.x + (start_pos.x - event.position.x)
					#set_position(Vector2( initial_pos.x - ( new_width - initial_size.x ), get_position().y ))
				#
				#if initial_pos.y != 0:
					#new_height = initial_size.y + (start_pos.y - event.position.y)
					#set_position(Vector2( get_position().x , initial_pos.y - ( new_height - initial_size.y ) ))
				#
				#set_size( Vector2(new_width, new_height) )
		#
		#if Input.is_action_just_released("LeftClick"):
			#initial_pos = Vector2(0,0)
			#is_resizing_x = false
			#is_resizing_y = false


func _on_title_bar_mouse_entered():
	if can_window_be_moved:
		can_move = true


func _on_title_bar_mouse_exited():
	if can_window_be_moved:
		if !is_moving:
			can_move = false


func _on_resize_pressed():
	if can_window_be_resized:
		if !is_size_double:
			set_size( Vector2(get_size().x * 2, get_size().y * 2) )
			is_size_double = true
		else:
			set_size( Vector2(get_size().x / 2, get_size().y / 2) )
			is_size_double = false


func _on_close_pressed():
	queue_free()
