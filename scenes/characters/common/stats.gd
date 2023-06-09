extends Node2D

@export_category("Stats")
@export_group("Main stats")
var stat_baseline : int = 20
var stat_range = [0, 40]
var LEVEL : int = 1
var MAX_HP : int = 1
var STRENGTH : int = stat_baseline : set = set_STRENGTH
var DEXTERITY : int = stat_baseline : set = set_DEXTERITY
var CONSTITUTION : int = stat_baseline : set = set_CONSTITUTION
var SPEED : int = stat_baseline : set = set_SPEED
@export var BASE_WALKING_SPEED : int = 300

@export_group("Growth stats")
@export_range(0, 1) var STRENGTH_GROWTH : float = 0.3
@export_range(0, 1) var DEXTERITY_GROWTH : float = 0.3
@export_range(0, 1) var CONSTITUTION_GROWTH : float = 0.3
@export_range(0, 1) var SPEED_GROWTH : float = 0.3

var abilities = {
	MyGlobals.ABILITY.STRENGTH : STRENGTH,
	MyGlobals.ABILITY.DEXTERITY : DEXTERITY,
	MyGlobals.ABILITY.CONSTITUTION : CONSTITUTION,
	MyGlobals.ABILITY.SPEED : SPEED
}

func update_abilities():
	abilities = {
		MyGlobals.ABILITY.STRENGTH : STRENGTH,
		MyGlobals.ABILITY.DEXTERITY : DEXTERITY,
		MyGlobals.ABILITY.CONSTITUTION : CONSTITUTION,
		MyGlobals.ABILITY.SPEED : SPEED
	}

func ability_score(ab):
	return (abilities[ab] - stat_baseline) / 2

func walking_speed():
	var spdmod = ability_score(MyGlobals.ABILITY.SPEED)
	if spdmod == 0:
		return BASE_WALKING_SPEED
	return BASE_WALKING_SPEED + ((25*(log(abs(spdmod))+1))*sign(spdmod))

# Called when the node enters the scene tree for the first time.
func _ready():
	stats_ready()

func stats_ready():
	update_abilities()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_STRENGTH(newval):
	STRENGTH = clamp(newval, stat_range[0], stat_range[1])
	update_abilities()
	
func set_DEXTERITY(newval):
	DEXTERITY = clamp(newval, stat_range[0], stat_range[1])
	update_abilities()
	
func set_CONSTITUTION(newval):
	CONSTITUTION = clamp(newval, stat_range[0], stat_range[1])
	update_abilities()
	
func set_SPEED(newval):
	SPEED = clamp(newval, stat_range[0], stat_range[1])
	update_abilities()
