extends Node

@export_category("Item")
@export_group("General")
@export var _name = "Item"
@export var level : int = 1
@export_range(0, 1) var rarity : float = 0
@export_group("Main stats per item level")
@export var MAX_HP : int = 0
@export var STRENGTH : int = 0
@export var DEXTERITY : int = 0
@export var CONSTITUTION : int = 0
@export var SPEED : int = 0
@export_group("Main stats growth")
@export_range(0, 1) var STRENGTH_GROWTH : float = 0
@export_range(0, 1) var DEXTERITY_GROWTH : float = 0
@export_range(0, 1) var CONSTITUTION_GROWTH : float = 0
@export_range(0, 1) var SPEED_GROWTH : float = 0

func item_stat_modifier():
	return level * (1.0 + rarity)
	
func item_growth_modifier():
	return 1.0 + rarity

func max_hp():
	return MAX_HP * item_stat_modifier()

func strength():
	return STRENGTH * item_stat_modifier()
	
func dexterity():
	return DEXTERITY * item_stat_modifier()
	
func constitution():
	return CONSTITUTION * item_stat_modifier()
	
func speed():
	return SPEED * item_stat_modifier()
	
func strength_growth():
	return STRENGTH_GROWTH * item_growth_modifier()

func dexterity_growth():
	return DEXTERITY_GROWTH * item_growth_modifier()
	
func constitution_growth():
	return CONSTITUTION_GROWTH * item_growth_modifier()
	
func speed_growth():
	return SPEED_GROWTH * item_growth_modifier()
