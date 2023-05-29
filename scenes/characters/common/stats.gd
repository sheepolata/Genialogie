extends Node2D

@export_category("Stats")
@export_group("Main stats")
@export var STRENGTH : int = 10
@export var DEXTERITY : int = 10
@export var CONSTITUTION : int = 10
@export var SPEED : int = 10
@export var BASE_WALKING_SPEED : int = 300

var abilities = {
	MyGlobals.ABILITY.STRENGTH : STRENGTH,
	MyGlobals.ABILITY.DEXTERITY : DEXTERITY,
	MyGlobals.ABILITY.CONSTITUTION : CONSTITUTION,
	MyGlobals.ABILITY.SPEED : SPEED
}

@export_group("Growth stats")
@export_range(0, 1) var STRENGTH_GROWTH : float = 0.3 : set = set_STRENGTH_GROWTH
@export_range(0, 1) var DEXTERITY_GROWTH : float = 0.3 : set = set_DEXTERITY_GROWTH
@export_range(0, 1) var CONSTITUTION_GROWTH : float = 0.3 : set = set_CONSTITUTION_GROWTH
@export_range(0, 1) var SPEED_GROWTH : float = 0.3 : set = set_SPEED_GROWTH


func update_abilities():
	abilities = {
		MyGlobals.ABILITY.STRENGTH : STRENGTH,
		MyGlobals.ABILITY.DEXTERITY : DEXTERITY,
		MyGlobals.ABILITY.CONSTITUTION : CONSTITUTION,
		MyGlobals.ABILITY.SPEED : SPEED
	}

func set_STRENGTH_GROWTH(newval):
	STRENGTH_GROWTH = clamp(newval, 0, 1)
	update_abilities()
	
func set_DEXTERITY_GROWTH(newval):
	DEXTERITY_GROWTH = clamp(newval, 0, 1)
	update_abilities()
	
func set_CONSTITUTION_GROWTH(newval):
	CONSTITUTION_GROWTH = clamp(newval, 0, 1)
	update_abilities()
	
func set_SPEED_GROWTH(newval):
	SPEED_GROWTH = clamp(newval, 0, 1)
	update_abilities()

func get_ability_score(ab):
	return (abilities[ab] - 10) / 2
	
func get_walking_speed():
	var spdmod = get_ability_score(MyGlobals.ABILITY.SPEED)
	if spdmod == 0:
		return BASE_WALKING_SPEED
	return BASE_WALKING_SPEED + ((25*(log(abs(spdmod))+1))*sign(spdmod))

# Called when the node enters the scene tree for the first time.
func _ready():
	update_abilities()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
