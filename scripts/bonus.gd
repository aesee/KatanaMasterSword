class_name Bonus
extends StaticBody3D

var meshes : Array[MeshInstance3D]

func _ready():
	visible = GameSettings.difficulty == 3
	if visible:
		input_event.connect(_on_input_event)
		for child in get_children(true):
			if child is MeshInstance3D:
				meshes.append(child)
	
func _on_input_event(_camera, _event, _position, _normal, _shape_idx):
	input_event.disconnect(_on_input_event)
	Player.bonuses.append(self)
	if GameSettings.vibration:
		Input.vibrate_handheld(200)
	await animate_death()
	visible = false
	
func animate_death():
	var tw = get_tree().create_tween()
	tw.tween_method(set_shader_value, 0.0, 1.0, 2.0)
	return tw.finished
	
func set_shader_value(value: float):
	for mesh in meshes:
		mesh.get_active_material(0).set_shader_parameter("dissolve_amount", value);
		#mesh.material.set_shader_parameter("dissolve_amount", value);
