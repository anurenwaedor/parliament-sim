extends Node2D

signal card_rejected
signal card_accepted
signal week_finished

var left_area_entered : bool = false
var right_area_entered : bool = false

@onready var card_area: Area2D = $CardArea
@onready var menu_container: MarginContainer = $MenuContainer

var current_card : Card
#@onready var visible_title: Label = $CardArea/VBoxContainer/Title
#@onready var visible_description: Label = $CardArea/VBoxContainer/Description
@onready var visible_description: Label = $CardArea/MarginContainer/VBoxContainer/Description
@onready var visible_title: Label = $CardArea/MarginContainer/VBoxContainer/Title

var nb_law_voted : int = 0
var nb_law_accepted : int = 0
var nb_law_rejected : int = 0
var nb_weekly_law_voted : int = 0
var nb_weekly_law_accepted : int = 0
var nb_weekly_law_rejected : int = 0

var nb_votes_per_week : int = 5

var laws_accepted : Array[Card]
var laws_rejected : Array[Card]

@onready var nb_law_voted_label: Label = $VBoxContainer/HBoxContainer/LawVotedLabel
@onready var nb_law_rejected_label: Label = $VBoxContainer/HBoxContainer/LawRejectedLabel
@onready var nb_law_accepted_label: Label = $VBoxContainer/HBoxContainer/LawAcceptedLabel
@onready var pause_btn: Button = $VBoxContainer/HBoxContainer/PauseBtn
@onready var law_weekly_voted_label: Label = $VBoxContainer/HBoxContainer/LawWeeklyVotedLabel
@onready var law_weekly_rejected_label: Label = $VBoxContainer/HBoxContainer/LawWeeklyRejectedLabel
@onready var law_weekly_accepted_label: Label = $VBoxContainer/HBoxContainer/LawWeeklyAcceptedLabel

@onready var pop_eval_label: Label = $SocietyValuesContainer/PopEvalLabel
@onready var gdp_label: Label = $SocietyValuesContainer/GDPLabel
@onready var social_supp_label: Label = $SocietyValuesContainer/SocialSuppLabel
@onready var healthy_life_label: Label = $SocietyValuesContainer/HealthyLifeLabel
@onready var life_choice_label: Label = $SocietyValuesContainer/LifeChoiceLabel
@onready var generosity_label: Label = $SocietyValuesContainer/GenerosityLabel
@onready var perc_corruption_label: Label = $SocietyValuesContainer/PercCorruptionLabel

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var feedback_label: Label = $VBoxContainer/FeedbackLabel

var society : Dictionary = {
	#life evaluation – subjective rating of overall happiness, rated by each person surveyed on a scale of 0–10. This is the only number considered in each individual country's overall ranking[19]
	population_evaluation = 0,
	#real GDP per capita
	gdp_per_capita = 0,
	#social support
	social_support = 0,
	#healthy life expectancy
	healthy_life_expectancy = 0,
	#freedom to make life choices
	life_choice_freedom = 0,
	#generosity
	generosity = 0,
	#perceptions of corruption
	corruption_perception = 0
}

var society2 : Dictionary = {
	yearly = {state_budget_increase = 0},
	state_budget = 0,
	population = {children = 100, young_adult = 400, adults = 500, old_people = 300}
}

var world : Dictionary = {
	
}

# Gameplay loop
# raedy ->  1st session
# small tutorial
# each session = 1 week = 5 propositions
# each proposition => vote YES/NO => compute modificators / consequences depends on the party that suggested them
# after 4 sessions  = 1 month -> apply effects ; give report of votes, their effects, etc.

func _ready() -> void:
	menu_container.visible = true
	card_area.visible = false
	pause_btn.visible = false

func _process(_delta: float) -> void:
	if card_area.visible:
		if Input.is_action_just_released("press"):
			print("released")
			if left_area_entered:
				card_rejected.emit()
			elif right_area_entered:
				card_accepted.emit()

func start_new_game() -> void:
	print("New game")
	card_area.visible = true
	pause_btn.visible = true
	
	reset_game_values()
	reset_weekly_game_values()
	# updated top bar gui
	updated_law_labels()
	# pick a card
	pick_new_proposal()
	animation_player.play("card_fadein")

	
	# repeat until game lost/exit
		# var result = start_week()
		# month_results.append(result)
		# if end_of_the_month:
		# 	apply_results
			# local_results
			# worldwide_results
		# 	provide_report
	pass

func start_week() -> bool:
	card_area.visible = true
	return false

func _on_detection_left_area_entered(_area: Area2D) -> void:
	if card_area.visible:
		print("Left area entered - no")
		left_area_entered = true
		update_feedback("Release to Reject")

func _on_detection_right_area_entered(_area: Area2D) -> void:
	if card_area.visible:
		print("Right area entered - YES")
		right_area_entered = true
		update_feedback("Release to Accept")

func _on_detection_left_area_exited(_area: Area2D) -> void:
	print("Left area exited - cancel no")
	update_feedback("")
	left_area_entered = false

func _on_detection_right_area_exited(_area: Area2D) -> void:
	print("Right area exited - cancel YES")
	update_feedback("")
	right_area_entered = false

func _on_card_accepted() -> void:
	print("Proposition accepted= ", current_card.title)
	laws_accepted.append(current_card)
	update_progression()

	animation_player.play("card_fadeout")

func _on_card_rejected() -> void:
	print("Proposition rejected= ", current_card.title)
	laws_rejected.append(current_card)
	update_progression()
	animation_player.play("card_fadeout")

# game level
func reset_game_values() -> void:
	nb_law_voted = 0
	nb_law_rejected = 0
	nb_law_accepted = 0
	reset_weekly_game_values()
	# reset society/world values

# weekly
func reset_weekly_game_values() -> void:
	nb_weekly_law_voted = 0
	nb_weekly_law_rejected = 0
	nb_weekly_law_accepted = 0
	
	laws_accepted.clear()
	laws_rejected.clear()
	# reset society/world values

func update_progression() -> void:
	nb_law_voted += 1
	nb_weekly_law_voted += 1
	# rejected
	if left_area_entered:
		nb_law_rejected += 1
		nb_weekly_law_rejected += 1
	elif right_area_entered:
		nb_law_accepted += 1
		nb_weekly_law_accepted += 1
	updated_law_labels()

func updated_law_labels() -> void:
	nb_law_voted_label.text = "Voted: " + str(nb_law_voted)
	nb_law_rejected_label.text = "Rejected: " + str(nb_law_rejected)
	nb_law_accepted_label.text = "Accepted: " + str(nb_law_accepted)
	
	law_weekly_voted_label.text = "Voted: " + str(nb_weekly_law_voted)
	law_weekly_rejected_label.text = "Rejected: " + str(nb_weekly_law_rejected)
	law_weekly_accepted_label.text = "Accepted: " + str(nb_weekly_law_accepted)

func update_society_label()-> void:
	pop_eval_label.text = "Pop evaluation: " + str(society.population_evaluation)
	gdp_label.text = "GPD per cap= " + str(society.gdp_per_capita)
	social_supp_label.text = "Social supp= " + str(society.social_support)
	healthy_life_label.text = "Healthy life exp.= " + str(society.healthy_life_expectancy)
	life_choice_label.text = "Life freedom= " + str(society.life_choice_freedom)
	generosity_label.text = "Generosity= " + str(society.generosity)
	perc_corruption_label.text = "P. Corruption = " + str(society.corruption_perception)

func pick_new_proposal() -> void:
	if nb_weekly_law_voted < nb_votes_per_week:
		current_card = CardData.all_cards.pick_random()
		update_visible_card()
	else:
		week_finished.emit()

func update_visible_card() -> void:
	visible_title.text = "#" + str(current_card.id) + " " + current_card.title
	visible_description.text = current_card.description

func update_feedback(s : String) -> void:
	feedback_label.text = s

func _on_exit_btn_pressed() -> void:
	get_tree().quit()

func _on_new_game_btn_pressed() -> void:
	menu_container.visible = false
	start_new_game()

func _on_pause_btn_pressed() -> void:
	card_area.visible = not card_area.visible
	menu_container.visible = not menu_container.visible

func _on_week_finished() -> void:
	print("Week finished, votes passed:")
	for a in laws_accepted:
		print(a.id, " ", a.title, " ", a.modifiers)
		#apply laws
		#society.population_evaluation = a.modifiers['pop_evaluation']
		society.gdp_per_capita += a.modifiers['gdp_per_capita']
		society.social_support += a.modifiers['social_support']
		society.healthy_life_expectancy += a.modifiers['healthy_life_exp']
		society.life_choice_freedom += a.modifiers['life_choice_freedom']
		society.generosity += a.modifiers['generosity']
		society.corruption_perception += a.modifiers['corruption']
	
	# generate report for checking
	
	update_society_label()
	reset_weekly_game_values()
	pick_new_proposal()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "card_fadeout":
		pick_new_proposal()
		animation_player.play("card_fadein")
