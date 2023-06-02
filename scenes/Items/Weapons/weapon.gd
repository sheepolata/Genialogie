extends "res://scenes/Items/item_stats.gd"

@export_category("Weapon")
@export var ATTACK_BONUS : int = 0
@export var DAMAGE_BONUS : int = 0
@export var ATTACK_STAT : MyGlobals.ABILITY
@export var DAMAGE_STAT : MyGlobals.ABILITY

func attack_bonus():
	return ATTACK_BONUS * item_stat_modifier()

func damage_bonus():
	return DAMAGE_BONUS * item_stat_modifier()
