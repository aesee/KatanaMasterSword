class_name MeshesCollector
extends Node3D

var meshes : Array[MeshInstance3D]
var eyes : Array[MeshInstance3D]

func _ready():
	for child in get_children(true):
		if child is MeshInstance3D:
			meshes.append(child)
			if child.mesh is SphereMesh:
				eyes.append(child)
			
	var initial_position = position
	var animation_tween = create_tween()
	animation_tween.set_ease(Tween.EASE_IN)
	animation_tween.set_loops()	
	animation_tween.tween_property(self, "position", initial_position + Vector3(0, 0.025, 0), randf_range(1, 1.5))
	animation_tween.chain().tween_interval(randf_range(1, 1.5))
	animation_tween.chain().tween_property(self, "position", initial_position, randf_range(1, 1.5))
	
	_animate_eyes()
	
func _animate_eyes():
	if eyes.size() == 0:
		return
	var tween = create_tween()
	tween.set_loops()	
	tween.tween_method(_change_eyes, 1.0, 0.0, randf_range(0.05, 0.15))
	tween.chain().tween_interval(randf_range(0.01, 0.1))
	tween.chain().tween_method(_change_eyes, 0.0, 1.0, randf_range(0.05, 0.15))
	tween.chain().tween_interval(randf_range(1, 6))

func _change_eyes(height):
	for eye in eyes:
		var eye_transform = eye as Node3D
		eye_transform.scale.y = height
