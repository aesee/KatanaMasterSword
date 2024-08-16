extends Node

# Settings
const _max_health : float = 100
const move_speed : float = 4.0

# Parameters
var health : float
var _scars : Array[ReceivedDamage] = []
var current_level : Node3D

# Collectables
var bonuses : Array[Bonus]

func _ready():
	reset()

func reset():
	bonuses.clear()
	heal()

func damage(amount : float):
	if GameSettings.one_hit_mode:
		amount = 99999
	health -= amount
	AudioManager.blades_audio_manager.play_fail_sound()
	if health <= 0:
		var scn = preload("res://assets/scenes/UI/dead_end_canvas.tscn")
		var menu = scn.instantiate()
		current_level.add_child(menu)

func add_scar(camera : Camera3D, position : Vector3):
	var origin = camera.unproject_position(position)
	var wound_direction = Vector2(
		_get_random_sign() * randf_range(100, 500),
		_get_random_sign() * randf_range(100, 500)
		)	
	animate_damage_receiving(camera, wound_direction);
	var scar = ReceivedDamage.create(origin, wound_direction)
	camera.add_child(scar)
	_scars.append(scar)
	scar.animate_colding()

func heal():
	health = _max_health
	for scar in _scars:
		if scar != null:
			scar.destroy()
	_scars.clear()
	
func animate_damage_receiving(camera : Camera3D, direction : Vector2):
	var normalizedDirection = direction.normalized()
	var direction3d = Vector3(normalizedDirection.x / 3, -normalizedDirection.y / 3, 0.1)
	var tw = get_tree().create_tween()
	var position_to_return = camera.position
	tw.tween_property(camera, "position", camera.position + direction3d, 0.1)
	tw.chain().tween_property(camera, "position", position_to_return, 0.4)
	await tw.finished

func _get_random_sign():
	return randi_range(0, 2) * 2 - 1

func all_bonuses_collected():
	return bonuses.size() == 6
