extends Camera2D

signal horizontal_swipe
signal horizontal_swipe_left
signal horizontal_swipe_right
signal vertical_swipe

var swipe_length : int = 150
var max_delta_direction : int = 45
var max_displacement : float = 300
var x_margin : int = 200
var start_pos : Vector2 = Vector2i(0,0)
var current_pos : Vector2 = Vector2i(0,0)

var swiping : bool = false
@onready var line_2d: Line2D = $"../Line2D"
#@onready var proposal: ColorRect = $"../CardArea/Proposal"
@onready var proposal: NinePatchRect = $"../CardArea/Proposal"
@onready var card_area: Area2D = $"../CardArea"
var card_base_position: Vector2

func _ready() -> void:
	card_base_position = card_area.position

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("press"):
		if !swiping:
			swiping = true
			start_pos = get_global_mouse_position()
			print("start= ", start_pos)
			line_2d.clear_points()
			line_2d.add_point(start_pos)
	if Input.is_action_pressed("press"):
		if swiping:
			current_pos = get_global_mouse_position()
			print(current_pos)
			var window_width = get_viewport().get_visible_rect().size[0]
			if current_pos.x < x_margin:
				current_pos.x = x_margin
			elif current_pos.x > window_width - x_margin:
				current_pos.x = window_width - x_margin
			var swipe_distance : float = start_pos.distance_to(current_pos)
			var swipe_x_distance : float = current_pos.x - start_pos.x
			#swipe_x_distance = swipe_x_distance if abs(swipe_x_distance) < max_displacement else (max_displacement if swipe_x_distance > 0 else -max_displacement)
			var card_move_tween = get_tree().create_tween()
			card_move_tween.tween_property(card_area, "position", Vector2(card_base_position.x + swipe_x_distance, card_base_position.y), 1.0*swipe_distance/300.0)
			
			print("card rotation= ", card_area.rotation, " sign = ", signf(swipe_x_distance))
			var card_tilt_tween = get_tree().create_tween()
			card_tilt_tween.tween_property(card_area, "rotation", signf(swipe_x_distance)*15*PI/180.0, 1.0)
			
			
			if swipe_distance > swipe_length:
				if abs(start_pos.x - current_pos.x) < max_delta_direction:
					print("vertical swipe")
					vertical_swipe.emit()
				elif abs(start_pos.y - current_pos.y) < max_delta_direction:
					if start_pos.x > current_pos.x:
						#print("left horizontal swipe")
						horizontal_swipe_left.emit()
					elif start_pos.x < current_pos.x:
						#print("right horizontal swipe")
						horizontal_swipe_right.emit()
				else:
					print("undirected")
				
				#print("SWIPE detected with length ", swipe_distance)
				#swiping = false
				line_2d.add_point(current_pos)
				#print(line_2d.points)
				#print("----------")
	else:
		swiping = false
		var card_move_tween = get_tree().create_tween()
		card_move_tween.tween_property(card_area, "position", card_base_position, 0.5)
		var card_tilt_tween = get_tree().create_tween()
		card_tilt_tween.tween_property(card_area, "rotation", 0.0, 1.0)
