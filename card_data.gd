extends Node

var all_cards : Array[Card] = []

#	wealth = 0.0,
	#happiness = 0.0,
	#education = 0.0
var data = [
	[{Utils.Languages.fr : "Retraite à 60 ans",
	Utils.Languages.en: "Retirement from 60yo"},
	{Utils.Languages.fr: "Partir plus tôt à la retraite serait bon pour le moral du peuple mais le coût économique est à prendre en compte dans les budgets",
	Utils.Languages.en: "Earlier retirement would improve the population mental health but the cost must be calculated into the budget"}, {wealth = -5.0, happiness = 3.0, education = 0.0}],
	[{Utils.Languages.fr: "Taxer les milliardaires", Utils.Languages.en: "Tax the billionaires"}, {Utils.Languages.fr: "Établir des taxes pour récupérer une plus grande part des revenus du patrimoine pour les plus aisés", Utils.Languages.en: "Create taxes to gain a higher amount from the most wealthy"}, {wealth = 25.0, happiness = -4.0, education = 0.0}],
	[{Utils.Languages.fr: "Conditionner les aides sociales des chômeur-euses", Utils.Languages.en: "Condition unemployment compensation"}, {Utils.Languages.fr: "Pour obtenir les aides sociales, les personnes sans emploi devront justifier de 10h hebdomadaire de travail", Utils.Languages.en: "Unemployed people must work at least 10h weekly 10h to be eligible to social benefits"}, {wealth = 2.0, happiness = -7.0, education = 0.0}],
	[{Utils.Languages.fr: "Réduire l'écart brut-net sur les salaires", Utils.Languages.en: "Reduce the gap between gross and net salary"}, {Utils.Languages.fr: "Les travailleur-euses doivent toucher une part plus importante de leur salaire brut afin de décider librement de son usage et augmenter le pouvoir d'achat", Utils.Languages.en: "Workers should get a higher percentage of the gross salary directly in order to be able to decide freely how to use their money and increase their spending power"}, {wealth = 1.5, happiness = -7.0, education = 0.0, solidarity = -3.0}],
	
	]
	
func _ready() -> void:
	print("Card data _ready")
	var count = 0
	for cd in data:
		print("cd: ", cd)
		print("---")
		var c : Card = Card.new()
		print("data: ", cd[0])
		print(cd[1][Utils.selected_language])
		print(cd[2])
		c.id = count
		c.set_card(cd[0][Utils.selected_language], cd[1][Utils.selected_language], cd[2])
		all_cards.append(c)
		count += 1
		
	print(all_cards)
