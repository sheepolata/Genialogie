extends Node

@export_category("CLASS")
@export var class_name_ : String = "Class"
@export var BASE_HP : int = 1

@export_range(-1, 1) var STRENGTH_GROWTH : float = 0.0
@export_range(-1, 1) var DEXTERITY_GROWTH : float = 0.0
@export_range(-1, 1) var CONSTITUTION_GROWTH : float = 0.0
@export_range(-1, 1) var SPEED_GROWTH : float = 0.0

@export var FLAT_ATTACK_BONUS_PER_LEVEL : float = 0
@export var FLAT_DAMAGE_BONUS_PER_LEVEL : float = 0
@export var FLAT_DEFENCE_BONUS_PER_LEVEL : float = 0
