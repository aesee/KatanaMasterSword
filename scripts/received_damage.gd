class_name ReceivedDamage
extends Line2D

static func create(origin : Vector2, wound_direction : Vector2) -> ReceivedDamage:
	var scn = preload("res://assets/scenes/received_damage.tscn")
	var instance = scn.instantiate()
	instance.add_point(origin)	
	instance.add_point(origin + wound_direction)
	return instance

func animate_colding():
	var tw = get_tree().create_tween()
	tw.tween_property(self, "modulate:a", randf_range(0.2, 0.5), 1)

func destroy():
	var tw = get_tree().create_tween()
	tw.tween_property(self, "modulate:a", 0.0, 0.1)
	await tw.finished
	queue_free()
