extends Node3D

@export var base_fighting_scene : PackedScene
@export var fights : Array[PackedScene]
@export var main_camera : Camera3D
@export var path : PathFollow3D
@onready var path_points : Path3D = path.get_parent()
var current_point : int
var next_path_point : Vector3
var fight_scene
var walk_tween : Tween

func _ready():
	Player.reset()
	set_process(false)
	current_point = 0
	move_to_next_point()
	AudioManager.reset()
	AudioManager.music_background.play()
	Player.current_level = self

func _process(delta):
	path.progress += Player.move_speed * delta
	if fight_scene:
		fight_scene.global_rotation = main_camera.global_rotation
	if main_camera.global_position.distance_to(next_path_point) < 3:
		start_fight()

func move_to_next_point():
	current_point += 1
	if (path_points.curve.point_count > current_point):
		next_path_point = path_points.to_global(path_points.curve.get_point_position(current_point))
		get_camera_back_on_track()
		if (fights.size() >= current_point):
			spawn_next_opponent()
		else:
			_start_final_sequence()
		set_process(true)

func start_fight():
	enable_walking_animation(false)
	set_process(false)
	if (fight_scene != null):
		fight_scene.start(main_camera)
	fight_scene = null

func _on_battle_won():
	move_to_next_point()

func spawn_next_opponent():
	fight_scene = base_fighting_scene.instantiate()	
	add_child(fight_scene)	
	fight_scene.global_position = next_path_point
	fight_scene.global_rotation = main_camera.global_rotation
	fight_scene.opponent_is_defeated.connect(_on_battle_won)
	var opponent = fights[current_point - 1]
	fight_scene.spawn_opponent(opponent)

func get_camera_back_on_track():
	var tw = get_tree().create_tween()
	tw.set_parallel(true)
	tw.tween_property(main_camera, "position", Vector3.ZERO, 0.5)
	tw.tween_property(main_camera, "rotation", Vector3.ZERO, 0.5)
	await tw.finished
	enable_walking_animation(true)

func enable_walking_animation(enabled : bool):
	if walk_tween != null:
		walk_tween.kill()
		walk_tween = null	
	if enabled:
		walk_tween = get_tree().create_tween()
		walk_tween.set_loops()
		walk_tween.tween_property(main_camera, "position", Vector3(0, 0.2, 0), 0.5)
		walk_tween.chain().tween_property(main_camera, "position", Vector3.ZERO, 0.5)
		walk_tween.tween_callback(_on_step_callback)
		
func _on_step_callback():
	AudioManager.footsteps.play_step()

func _start_final_sequence():
	await get_tree().create_timer(5).timeout
	if Player.all_bonuses_collected():
		get_tree().change_scene_to_file("res://assets/scenes/UI/hidden_ending.tscn")
	else:
		get_tree().change_scene_to_file("res://assets/scenes/UI/base_ending.tscn")

func _notification(what):
	if what == NOTIFICATION_WM_GO_BACK_REQUEST && not get_tree().paused:
		# For android
		_display_pause_menu()

func _input(_event):
	if Input.is_action_just_pressed("Pause") && not get_tree().paused:
		_display_pause_menu()

func _display_pause_menu():
	var scn = load("res://assets/scenes/UI/pause.tscn")
	var menu = scn.instantiate()
	add_child(menu)
