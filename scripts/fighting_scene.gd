class_name FightingScene
extends Node3D

@export var camera : Camera3D
@onready var cut_processor: PlayerCutProcessor = PlayerCutProcessor.new()

var opponent: Opponent
var current_trail: CutTrail
const RAY_LENGTH = 10
var player_loses_hp_in_process : bool = false

signal opponent_is_defeated

func _ready():
	cut_processor.cut_happened.connect(_on_cut_happened)
	set_process_input(false)

func spawn_opponent(packed_opponent : PackedScene):
	opponent = packed_opponent.instantiate()
	add_child(opponent)
	opponent.defeated.connect(_on_battle_won)

func start(active_camera : Camera3D):
	var tw = get_tree().create_tween()
	tw.set_parallel(true)
	tw.tween_property(active_camera, "global_position", camera.global_position, 1)
	tw.tween_property(active_camera, "global_rotation", camera.global_rotation, 1)
	await tw.finished
	camera = active_camera
	for cursor in opponent.cursors:
		cursor.input_event.connect(_on_cursor_input_event)
	opponent.start()
	set_process_input(true)
	
func _input(event):
	if event is InputEventScreenTouch:
		if !event.pressed:
			if current_trail:
				current_trail.stop()
				current_trail = null
			cut_processor.clear()
			
	if event is InputEventScreenDrag:
		if current_trail == null:
			make_trail()		
		var current_touch = event.get_position()
		current_trail.add_next_point(current_touch)
		cut_processor.add_next_point(current_touch)

func make_trail():
	if current_trail:
		current_trail.stop()
	current_trail = CutTrail.create()
	add_child(current_trail)

func _on_cursor_input_event(_camera, event, _position, _normal, _shape_idx):
	if event is InputEventScreenDrag && !player_loses_hp_in_process:
		player_loses_hp_in_process = true		
		Player.damage(opponent.power)
		Player.add_scar(_camera, _position)
		set_process_input(false)
		if GameSettings.vibration:
			Input.vibrate_handheld(400)
		var time_to_wait = 1.0
		for cursor in opponent.cursors:
			cursor.change_state(time_to_wait)
		await get_tree().create_timer(time_to_wait).timeout
		set_process_input(true)
		await get_tree().create_timer(0.25).timeout
		player_loses_hp_in_process = false

func _on_cut_happened(cut_begin : Vector2, cut_end : Vector2):
	var space_state = get_world_3d().direct_space_state
	
	var points_to_check = [cut_begin, cut_end]
	var cut_line = cut_end - cut_begin
	var third_of_line = cut_line / 5
	points_to_check.append(cut_begin + third_of_line)
	points_to_check.append(cut_begin + third_of_line * 2)
	points_to_check.append(cut_begin + third_of_line * 3)
	points_to_check.append(cut_begin + third_of_line * 4)

	var success = false
	for point in points_to_check:
		var origin = camera.project_ray_origin(point)
		var end = origin + camera.project_ray_normal(point) * RAY_LENGTH
		var query = PhysicsRayQueryParameters3D.create(origin, end)
		var result = space_state.intersect_ray(query)
		if (result && result["collider"] == opponent):
			success = true
			break
	
	if success:
		AudioManager.blades_audio_manager.play_random_sound()
		AudioManager.screams_manager.play_scream()
		opponent.damage(5)
		if GameSettings.vibration:
			Input.vibrate_handheld(100)

func _on_battle_won():
	AudioManager.blades_audio_manager.play_finish_sound()
	set_process_input(false)
	set_process(false)
	await opponent.animate_death()
	opponent_is_defeated.emit()
	visible = false
	queue_free()
