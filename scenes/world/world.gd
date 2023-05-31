extends Node2D

@onready var UI = $CanvasLayer/UI
@onready var UICards = $CanvasLayer/UI/Cards
@onready var Team = $Team

func _process(delta):
	update_ui()
	
func update_ui():
	pass
