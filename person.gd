class_name Person extends Node

var rng : RandomNumberGenerator = RandomNumberGenerator.new()

# current progresssion
var age : int = 1
# this person base level
# 1-5 for regular, 10 for the rich
var social_class : int = 1
# var revenue_per_year = int
# chance to avoid losing/find a new job
var job_stability : int = 1
# chance to avoid/recover from disease :
var health : int = 1
# chance to avoid/recover from bad events 
var social_circle : int = 1


func create_person() -> void:
	age = randi_range(1,70) #society.life_expectancy
	social_class = (randi_range(1, 10) - 5 + randi_range(-2, 2))
	social_class = (social_class if social_class >= 1 else 1) if social_class <= 5 else 5
	job_stability = randi_range(-10, 10) + social_class * 15
	health = randi_range(1, 20) + social_class * 10 - 20 * float(age) / 80
	 #= rand() % 1-20 + social_class * 10 - 30 * age / society.life_expectancy 
	social_circle = randi_range(-10, 10) + social_class * 20
	
func _ready() -> void:
	seed(5)
	#rng.seed = 5
	#rng.state = 1
	for p in range(20):
		var joe = Person.new()
		joe.create_person()
		print("Joe" + str(p), " ", joe.age, " ", joe.social_class, " - job:", joe.job_stability, " - health:", joe.health, " - social:", joe.social_circle)
