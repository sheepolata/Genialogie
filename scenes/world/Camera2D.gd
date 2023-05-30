extends Camera2D

@export var follow : Node2D
@export var zoom_in_max : float = 0.5
@export var zoom_out_max : float = 2.0
@export var zoom_step : float = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if follow != null:
		position = follow.team_center_position
		
func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		print(event.button_index)
		if event.button_index == 4: # wheel up
			zoom = Vector2(clamp(zoom.x + zoom_step, zoom_in_max, zoom_out_max),
							 clamp(zoom.y + zoom_step, zoom_in_max, zoom_out_max))
		elif event.button_index == 5: # wheel down
			zoom = Vector2(clamp(zoom.x - zoom_step, zoom_in_max, zoom_out_max),
							 clamp(zoom.y - zoom_step, zoom_in_max, zoom_out_max))
