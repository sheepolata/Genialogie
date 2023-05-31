extends "res://scenes/characters/common/stats.gd"

@export_group("Growth stats")
@export_range(0, 1) var STRENGTH_GROWTH : float = 0.3
@export_range(0, 1) var DEXTERITY_GROWTH : float = 0.3
@export_range(0, 1) var CONSTITUTION_GROWTH : float = 0.3
@export_range(0, 1) var SPEED_GROWTH : float = 0.3

# Called when the node enters the scene tree for the first time.
func _ready():
	stats_ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
