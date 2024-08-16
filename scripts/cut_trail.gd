class_name CutTrail
extends Line2D

const MAX_POINTS: int = 60
@onready var curve : Curve2D = Curve2D.new()
var time : float = 0

func _process(delta: float):
	time += delta;
	if time > 0.025:
		if curve.get_baked_points().size() > 0:
			curve.remove_point(0)
			points = curve.get_baked_points()

func add_next_point(point : Vector2):
	curve.add_point(point)
	if curve.get_baked_points().size() > MAX_POINTS:
		curve.remove_point(0)
	points = curve.get_baked_points()
	time = 0

func stop():
	set_process(false)
	var tw = get_tree().create_tween()
	tw.tween_property(self, "modulate:a", 0.0, 0.1)
	await tw.finished
	queue_free()

static func create() -> CutTrail:
	var scn = preload("res://assets/scenes/cut_trail.tscn") # TODO better way?
	return scn.instantiate()
