extends Area2D

var players_inside = []

@onready var character = self.get_parent()
@onready var CollisionShape = $CollisionShape2D

func _on_area_entered(area):
	var other = area.get_parent()
	if other is Character:
		if other.team == MyGlobals.TEAM.PLAYER:
			if not (other in players_inside):
				players_inside.append(other)

func _on_area_exited(area):
	var other = area.get_parent()
	var i = players_inside.find(other)
	if i >= 0:
		players_inside.remove_at(i)

func _process(delta):
	var d = Vector2.ZERO
	for o in players_inside:
		var base = character.position - o.position
		var dist = character.position.distance_to(o.position)
		var radius = CollisionShape.shape.radius * character.scale.x
		var dist_factor = ((radius - dist) / radius)
		var val = base * dist_factor
		d += Vector2(snappedf(val.x, 0.1), snappedf(val.y, 0.1))
	character.avoid_direction = -d.normalized() * .25
	
