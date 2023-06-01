extends CharacterBody2D

class_name Character

var growth_range = [-1 , 1]

@export var character_name : String = "John Doe"

@export var leader : bool = false
@export var team : MyGlobals.TEAM

@onready var _animated_sprite = $AnimatedSprite2D
@onready var _stats = $stats
@onready var _class = $class

@onready var _avoid_timer = $Timers/AvoidTimer
var no_avoid_forced = false

var goal : Vector2 = Vector2.ZERO : set = set_goal
var goal_reached = true

var current_hp : float = 0

var my_ui = preload("res://scenes/world/UI/character_card.tscn")
var rng = RandomNumberGenerator.new()

var avoid_direction : Vector2 = Vector2.ZERO

enum STATE {
	goto,
	avoid_only,
	idle
}

var STATE_STR = {
	STATE.goto : "GOTO",
	STATE.avoid_only : "AVOID_ONLY",
	STATE.idle : "IDLE"
}

var state = STATE.idle

var b_call_once = false

# Called when the node enters the scene tree for the first time.
func _ready():
	_stats.MAX_HP = _class.BASE_HP + ability_score(MyGlobals.ABILITY.CONSTITUTION)
	current_hp = max_hp()
	
	$Timers/ResetAvoidTimer.start()

func call_once():
	var world_ui_cards = get_parent().get_parent().UICards
	var my_ui_instance = my_ui.instantiate()
	my_ui_instance.name = character_name
	my_ui_instance.AssociatedCharacter = self
	world_ui_cards.add_child(my_ui_instance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$UIDebug/Debug.text = ""
	$UIDebug/StateLabel.text = STATE_STR[state]
	
	if !b_call_once:
		call_once()
		b_call_once = true
	
#	$UIDebug/Debug.text += str(avoid_direction) + "\n"
#	$UIDebug/Debug.text += str(global_position) + "\n"
	$UIDebug/Debug.text += str(no_avoid_forced) + "\n"
	
	act()
	avoid()
	set_animation()
	move_and_slide()
	queue_redraw()

func level_up():
	_stats.LEVEL += 1
	
	if strength_growth() > 0:
		if rng.randf() < strength_growth():
			_stats.STRENGTH += 1
	else:
		if rng.randf() < (strength_growth()*-1):
			_stats.STRENGTH -= 1
	
	if dexterity_growth() > 0:
		if rng.randf() < dexterity_growth():
			_stats.DEXTERITY += 1
	else:
		if rng.randf() < (dexterity_growth()*-1):
			_stats.DEXTERITY -= 1
	
	if constitution_growth() > 0:
		if rng.randf() < constitution_growth():
			_stats.CONSTITUTION += 1
	else:
		if rng.randf() < (constitution_growth()*-1):
			_stats.CONSTITUTION -= 1
	
	if speed_growth() > 0:
		if rng.randf() < speed_growth():
			_stats.SPEED += 1
	else:
		if rng.randf() < (speed_growth()*-1):
			_stats.SPEED -= 1
	
	_stats.MAX_HP = max(1, 
						_stats.MAX_HP 
						+ rng.randi_range(1, _class.BASE_HP)
						+ ability_score(MyGlobals.ABILITY.CONSTITUTION))
	current_hp = max_hp()

func max_hp():
	return _stats.MAX_HP

func attack_score():
	var ability = MyGlobals.ABILITY.STRENGTH # Will be defined by weapon 
	return floor(
		(_class.FLAT_ATTACK_BONUS_PER_LEVEL * _stats.LEVEL)
		+  ability_score(ability)
	)

func damage_score():
	var ability = MyGlobals.ABILITY.STRENGTH # Will be defined by weapon 
	return max(0, floor(
		(_class.FLAT_DAMAGE_BONUS_PER_LEVEL * _stats.LEVEL)
		+  ability_score(ability)
	))
	
func defence_score():
	var dex = ability_score(MyGlobals.ABILITY.DEXTERITY)
	var spd = ability_score(MyGlobals.ABILITY.SPEED)
	return max(0, floor(10 + (_class.FLAT_DEFENCE_BONUS_PER_LEVEL * _stats.LEVEL) + floor(dex + (spd / 2))))

func strength():
	return _stats.abilities[MyGlobals.ABILITY.STRENGTH]

func dexterity():
	return _stats.abilities[MyGlobals.ABILITY.DEXTERITY]
	
func constitution():
	return _stats.abilities[MyGlobals.ABILITY.CONSTITUTION]
	
func speed():
	return _stats.abilities[MyGlobals.ABILITY.SPEED]

func ability_score(ab):
	return _stats.ability_score(ab)

func growth_diminishing_return():
	return max(0, ((_stats.LEVEL - 20)) * 0.01)

func strength_growth():
	return clamp(
		_stats.STRENGTH_GROWTH
		+ _class.STRENGTH_GROWTH
		- growth_diminishing_return()
		, growth_range[0], growth_range[1]
	)

func dexterity_growth():
	return clamp(
		_stats.DEXTERITY_GROWTH
		+ _class.DEXTERITY_GROWTH
		- growth_diminishing_return()
		, growth_range[0], growth_range[1]
	)

func constitution_growth():
	return clamp(
		_stats.CONSTITUTION_GROWTH
		+ _class.CONSTITUTION_GROWTH
		- growth_diminishing_return()
		, growth_range[0], growth_range[1]
	)

func speed_growth():
	return clamp(
		_stats.SPEED_GROWTH
		+ _class.SPEED_GROWTH
		- growth_diminishing_return()
		, growth_range[0], growth_range[1]
	)

func act():
	if !goal_reached:
		state = STATE.goto
		go_to_position()
	else:
		state = STATE.idle

func go_to_position():
	var dist = goal.distance_to(position)
	if dist <= $AvoidArea/CollisionShape2D.shape.radius * scale.x:
		velocity = Vector2.ZERO
		goal_reached = true
	else:
		var direction = (goal - position).normalized()
		velocity = (direction + avoid_direction).normalized() * _stats.walking_speed()

func avoid():
#	velocity = avoid_direction * _stats.walking_speed()
	if state == STATE.goto:
		return
	if no_avoid_forced:
		velocity = Vector2.ZERO
		return
	
	if avoid_direction != Vector2.ZERO:
#		print(avoid_direction)
		velocity = avoid_direction * _stats.walking_speed()
		state = STATE.avoid_only
		if _avoid_timer.is_stopped():
			_avoid_timer.start()
			no_avoid_forced = false
	else:
		if not _avoid_timer.is_stopped():
			_avoid_timer.stop()
		velocity = Vector2.ZERO
		state = STATE.idle

func set_animation():
#	var diff = goal - position
	var diff = velocity
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
		STATE.avoid_only:
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
		if event.button_index == 2: # rmb
#			goal = get_global_mouse_position()
			goal = get_goal_from_mouse_clic()
	elif event is InputEventKey:
		if event.is_pressed() and event.key_label == KEY_U:
			level_up()

func get_goal_from_mouse_clic():
	var mp = get_global_mouse_position()
	var relative_pos = position - get_parent().team_center_position
	
	return (mp + relative_pos*.75)

func _on_avoid_timer_timeout():
	no_avoid_forced = true
	
func _on_reset_avoid_timer_timeout():
	no_avoid_forced = false
	
func _draw():
	var goal_size = Vector2(50.0, 50.0)
	draw_rect(Rect2(to_local(goal - (goal_size*scale/2)), goal_size), Color.RED)
	draw_line(to_local(position), to_local(goal), Color.RED)
