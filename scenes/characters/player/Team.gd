extends Node2D

var team_center_position = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_center():
	var pos_list = []
	var xmean = 0
	var ymean = 0
	for c in get_children():
		pos_list.append(c.position)
		xmean += c.position[0]
		ymean += c.position[1]
	
	team_center_position = Vector2(xmean / get_child_count(), ymean / get_child_count())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_center()
