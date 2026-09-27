class_name HealthComponent extends Node

@export var total_health: int = 100
@export var total_sanity: int = 100
@export var total_stamina: int = 20

@onready var current_health: int = total_health
@onready var current_sanity: int = total_sanity
@onready var current_stamina: int = total_stamina

signal death
signal gassed

func heal(heal_amt: int) -> void:
	if current_health < total_health:
		current_health = clampi(current_health + heal_amt, heal_amt, total_health)

func dmg(dmg_amt: int) -> void:
	if current_health > 0:
		current_health = clampi(current_health - dmg_amt, 0, total_health)
		if current_health == 0:
			death.emit()

func calm_down(calming_rate: int) -> void:
	if current_sanity < total_sanity:
		current_sanity = clampi(current_sanity + calming_rate, calming_rate, total_sanity)

func dmg_sanity(craze_rate: int) -> void:
	if current_sanity > 0:
		current_sanity = clampi(current_sanity - craze_rate, 0, total_sanity)

func catch_breath(calming_rate: int) -> void:
	if current_stamina < total_stamina:
		current_stamina = clampi(current_stamina + calming_rate, calming_rate, total_stamina)
		
func sprint(sprint_rate: int) -> void:
	if current_stamina > 0:
		current_stamina = clampi(current_stamina - sprint_rate, 0, total_stamina)
		if current_stamina == 0:
			gassed.emit()
