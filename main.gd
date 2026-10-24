extends Node2D

signal card_rejected
signal card_accepted

var left_area_entered : bool = false
var right_area_entered : bool = false

var current_card : Card
#@onready var visible_title: Label = $CardArea/VBoxContainer/Title
#@onready var visible_description: Label = $CardArea/VBoxContainer/Description
@onready var visible_description: Label = $CardArea/MarginContainer/VBoxContainer/Description
@onready var visible_title: Label = $CardArea/MarginContainer/VBoxContainer/Title

var law_passed : int = 0
var law_accepted : int = 0
var law_rejected : int = 0

func _ready() -> void:
	pick_new_proposal()

func _process(_delta: float) -> void:
	if Input.is_action_just_released("press"):
		print("released")
		if left_area_entered:
			card_rejected.emit()
		elif right_area_entered:
			card_accepted.emit()

func _on_detection_left_area_entered(_area: Area2D) -> void:
	print("Left area entered - no")
	left_area_entered = true


func _on_detection_right_area_entered(_area: Area2D) -> void:
	print("Right area entered - YES")
	right_area_entered = true


func _on_detection_left_area_exited(_area: Area2D) -> void:
	print("Left area exited - cancel no")
	left_area_entered = false


func _on_detection_right_area_exited(_area: Area2D) -> void:
	print("Right area exited - cancel YES")
	right_area_entered = false

func _on_card_accepted() -> void:
	print("Proposition accepted= ", current_card.title)
	update_progression()
	pick_new_proposal()

func _on_card_rejected() -> void:
	print("Proposition rejected= ", current_card.title)
	update_progression()
	pick_new_proposal()

func update_progression() -> void:
	law_passed += 1
	# rejected
	if left_area_entered:
		law_rejected += 1
	elif right_area_entered:
		law_accepted += 1
		

func pick_new_proposal() -> void:
	current_card = CardData.all_cards.pick_random()
	update_visible_card()

func update_visible_card() -> void:
	visible_title.text = "#" + str(current_card.id) + " " + current_card.title
	visible_description.text = current_card.description
