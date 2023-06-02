extends "res://scenes/Items/item_stats.gd"

@export_category("Armor")
@export var DEFENCE_BONUS : int = 0

func defence_bonus():
	return DEFENCE_BONUS * item_stat_modifier()
