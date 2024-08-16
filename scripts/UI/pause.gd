extends CanvasLayer

@export var main_menu : PackedScene
@export var quit_button : Button

func _ready():
	get_tree().paused = true
	var pc_version = OS.get_name() == "Windows"
	quit_button.visible = pc_version

func _on_back_button_down():
	await get_tree().create_timer(0.25).timeout
	get_tree().paused = false
	queue_free()

func _on_restart_button_down():
	get_tree().paused = false
	get_tree().reload_current_scene()
	queue_free()

func _on_back_to_menu_button_down():
	await get_tree().create_timer(0.25).timeout
	get_tree().paused = false
	get_tree().change_scene_to_packed(main_menu)

func _on_quit_button_down():
	get_tree().quit()
	
func _input(event):
	if Input.is_action_just_pressed("Pause"):
		_on_back_button_down()
