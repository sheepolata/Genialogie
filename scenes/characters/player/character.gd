extends CharacterBody2D

@export var leader : bool = false
@export var speed : float = 400.0

@onready var _animated_sprite = $AnimatedSprite2D
@onready var _stats = $stats

var goal : Vector2 = Vector2.ZERO : set = set_goal
var goal_reached = false

enum STATE {
	goto,
	idle
}

var state = STATE.idle

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	act()
	set_animation()
	move_and_slide()

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * _stats.get_walking_speed()

func act():
	if !goal_reached:
		state = STATE.goto
		go_to_position()
	else:
		state = STATE.idle

func go_to_position():
	var dist = goal.distance_to(position)
	if dist <= 25:
		velocity = Vector2.ZERO
		goal_reached = true
	else:
		var direction = (goal - position).normalized()
		velocity = direction * _stats.get_walking_speed()

func set_animation():
	var diff = goal - position
	var vec
	if abs(diff.x) > abs(diff.y):
		vec = Vector2(sign(diff.x), 0)
	else:
		vec = Vector2(0, sign(diff.y))
	
	var dir = "up"
	var is_left = false
	match (vec):
		Vector2.UP:
			dir = "up"
		Vector2.DOWN:
			dir = "down"
		Vector2.RIGHT:
			dir = "side"
		Vector2.LEFT:
			is_left = true
			dir = "side"
	_animated_sprite.flip_h = is_left
	match (state):
		STATE.goto:
			_animated_sprite.play(dir+"_run")
		STATE.idle:
			_animated_sprite.play(dir+"_idle")

func set_goal(newval):
	goal = newval
	goal_reached = false

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
#		print("Mouse Click/Unclick at: ", get_global_mouse_position())
		goal = get_global_mouse_position()
