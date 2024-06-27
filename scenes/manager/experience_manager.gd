extends Node

signal experience_updated(current_exp: float ,target_experience: float)
signal level_up(new_level: int)

const TARGET_EXPERIENCE_GROWTH = 5

var current_exp = 0
var current_level = 1
var target_experience = 5

func _ready():
	GameEvents.experience_vial_collected.connect(on_experience_vial_collected)
	

func increment_experience(number: float):
	current_exp = min(current_exp + number, target_experience)
	experience_updated.emit(current_exp, target_experience)
	if current_exp == target_experience:
		current_level += 1
		target_experience += TARGET_EXPERIENCE_GROWTH
		current_exp = 0
		experience_updated.emit(current_exp, target_experience)
		level_up.emit(current_level)

func on_experience_vial_collected(number: float):
	increment_experience(number)
