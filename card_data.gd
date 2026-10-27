extends Node

var all_cards : Array[Card] = []

#	wealth = 0.0,
	#happiness = 0.0,
	#education = 0.0
	# + or - 10
	#pop_evaluation = ,
'''
	gdp_per_capita = -2,
	social_support = 2,
	healthy_life_exp = 5,
	life_choice_freedom = 5,
	generosity = 0,
	corruption = 0
	'''

var data = [
	[{Utils.Languages.fr : "Retraite à 60 ans",
	Utils.Languages.en: "Retirement from 60yo"},
	{Utils.Languages.fr: "Partir plus tôt à la retraite serait bon pour le moral du peuple mais le coût économique est à prendre en compte dans les budgets",
	Utils.Languages.en: "Earlier retirement would improve the population mental health but the cost must be calculated into the budget"},
	{gdp_per_capita = -2, social_support = 2, healthy_life_exp = 5, life_choice_freedom = 5, generosity = 0, corruption = 0}],
	[{Utils.Languages.fr: "Taxer les milliardaires", Utils.Languages.en: "Tax the billionaires"}, {Utils.Languages.fr: "Établir des taxes pour récupérer une plus grande part des revenus du patrimoine des plus aisés", Utils.Languages.en: "Create taxes to gain a higher amount from the most wealthy"}, {gdp_per_capita = 0, social_support = 0, healthy_life_exp = 0, life_choice_freedom = 0, generosity = 0, corruption = -2}],
	[{Utils.Languages.fr: "Conditionner les aides sociales des chômeur-euses", Utils.Languages.en: "Condition unemployment compensation"}, {Utils.Languages.fr: "Pour obtenir les aides sociales, les personnes sans emploi devront justifier de 10h hebdomadaire de travail", Utils.Languages.en: "Unemployed people must work at least 10h weekly 10h to be eligible to social benefits"}, {gdp_per_capita = 0, social_support = -5, healthy_life_exp = -2, life_choice_freedom = -5, generosity = -2, corruption = -2}],
	[{Utils.Languages.fr: "Réduire l'écart brut-net sur les salaires", Utils.Languages.en: "Reduce the gap between gross and net salary"}, {Utils.Languages.fr: "Les travailleur-euses doivent toucher une part plus importante de leur salaire brut afin de décider librement de son usage et augmenter le pouvoir d'achat", Utils.Languages.en: "Workers should get a higher percentage of the gross salary directly in order to be able to decide freely how to use their money and increase their spending power"}, {gdp_per_capita = 0, social_support = -2, healthy_life_exp = -3, life_choice_freedom = 2, generosity = 0, corruption = 0}],
	[{Utils.Languages.fr: "Supprimer les crédits d'impôts pour les grandes entreprises.", Utils.Languages.en: "Cancel tax credit for large companies"}, {Utils.Languages.fr: "L'efficacité des crédits impôt recherche ou crédit sur l'embauche n'ont pas d'efficacité prouvée et représentent des manques à gagner importants pour l'état.", Utils.Languages.en: "TODO"}, {gdp_per_capita = 0, social_support = -2, healthy_life_exp = -3, life_choice_freedom = 2, generosity = 0, corruption = 0}],
	
	]
	
func _ready() -> void:
	print("Loading Card data")
	var count = 0
	for cd in data:
		#print("cd: ", cd)
		#print("---")
		var c : Card = Card.new()
		#print("data: ", cd[0])
		#print(cd[1][Utils.selected_language])
		#print(cd[2])
		c.id = count
		c.set_card(cd[0][Utils.selected_language], cd[1][Utils.selected_language], cd[2])
		all_cards.append(c)
		count += 1
		
	print(all_cards)
