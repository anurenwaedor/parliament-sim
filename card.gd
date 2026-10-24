class_name Card extends Node

#var current_card : Dictionary = {
	#title = "",
	#description = ""
	##icon = Texture2D
	#}

# lang, text
var id : int = 0
var title : String = "{}"
var description : String = "{}"
var modifiers : Dictionary = {
	wealth = 0.0,
	happiness = 0.0,
	education = 0.0,
	solidarity = 0.0
	}
enum Status {rejected = -1, undecided = 0, accepted = 1}
var card_status : int = Status.undecided

func set_card(name_: String, desc_: String, mods_: Dictionary) -> void:
	title = name_
	description = desc_
	for k in mods_.keys():
		if k in modifiers.keys():
			modifiers[k] = mods_[k]
		else:
			print("unknown key: ", k)
