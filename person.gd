class_name Person extends Node

var rng : RandomNumberGenerator = RandomNumberGenerator.new()
# after this age, 99% chance of dying
const max_age : int = 85

var person_name : String = ""
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
var retired : bool = false


func create_person() -> void:
	age = randi_range(1,70) #society.life_expectancy
	social_class = (randi_range(1, 10) - 5 + randi_range(-2, 2))
	social_class = (social_class if social_class >= 1 else 1) if social_class <= 5 else 5
	job_stability = randi_range(-10, 10) + social_class * 15
	health = randi_range(1, 20) + social_class * 10 - 20 * float(age) / 80
	 #= rand() % 1-20 + social_class * 10 - 30 * age / society.life_expectancy 
	social_circle = randi_range(-10, 10) + social_class * 20
	if age >= 65:
		retired = true

func roll_for(prob : int) -> bool:
	var roll : int = randi_range(1,100)
	if roll == 1:
		# automatic success
		return true
	elif roll == 100:
		#automatic failure
		return false
	return roll <= prob

func roll_for_age() -> bool:
	var death_probability = max_age + health - age
	#print(death_probability)
	return roll_for(death_probability)

func check_percent_value(value : int) -> int:
	if value > 100:
		return 100
	elif value < 0:
		return 0
	return value
	
func roll_for_health() -> bool:
	return roll_for(health)

func roll_for_job() -> bool:
	return roll_for(job_stability)

func roll_for_social() -> bool:
	return roll_for(social_circle)

func _ready() -> void:
	seed(randi())
	#5, 6, 15, 16, 17
	#rng.seed = 5
	#rng.state = 1
	#for p in range(20):
	#for p in range(1):
	var joe = Person.new()
	joe.create_person()
	joe.person_name = "Joe"
	#var keep_going : bool = true
	for event in range(50):
		print(joe.person_name, " (", joe.age, ") ", joe.social_class, " - job:", joe.job_stability, " - health:", joe.health, " - social:", joe.social_circle)
		var event_type = randi_range(1,4)
		print("Event type=", event_type)
		if event_type == 1:
			if joe.roll_for_age():
				print("another year to live")
			else:
				print("Alas, ", joe.person_name, " died at the merry age of ", joe.age)
				break
		elif event_type == 2:
			if joe.roll_for_health():
				print("Fit and healthy")
				joe.health += randi_range(1, 4)
				joe.health = check_percent_value(joe.health)
			else:
				joe.health -= randi_range(0,10)
				joe.health = check_percent_value(joe.health)
				if joe.health < 0:
					if !joe.roll_for_age():
						print("Too old for this shite")
						break
				print("This virus wasn't as innocuous as expected")
		elif event_type == 3 and !joe.retired:
			if joe.roll_for_job():
				print("Employed and earning")
				joe.job_stability += randi_range(1, 4)
				joe.job_stability = check_percent_value(joe.job_stability)
				joe.social_class += 1 if randi_range(1,100) < (100-joe.job_stability) else 0
			else:
				joe.social_class -= 1
				if joe.social_class < 0:
					print("Going down")
					joe.health -= randi_range(1,10)
					joe.health = check_percent_value(joe.health)
					joe.social_circle -= randi_range(1,10)
					joe.social_circle = check_percent_value(joe.social_circle)
				print("Damn capitalism")
		elif event_type == 4:
			if joe.roll_for_social():
				print("Family and friends")
				joe.social_circle += randi_range(1, 4)
				joe.social_circle = check_percent_value(joe.social_circle)
				joe.job_stability += randi_range(0,2)
				joe.job_stability = check_percent_value(joe.job_stability)
			else:
				joe.social_circle -= randi_range(1,10)
				joe.social_circle = check_percent_value(joe.social_circle)
				if joe.social_circle < 0:
					print("Going down")
					joe.health -= randi_range(1,10)
					joe.health = check_percent_value(joe.health)
					joe.job_stability -= randi_range(1,10)
					joe.job_stability = check_percent_value(joe.job_stability)
				print("Traitors and false friends!")
		joe.age += 1

		#print("\n - TESTS: age= ", joe.roll_for_age(), " health= ", joe.roll_for_health(), " job= ", joe.roll_for_job(), " social= ", joe.roll_for_social())
