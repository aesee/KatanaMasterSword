extends CanvasLayer

@export var melting_screen : MeltingScreen
@export var main_menu : PackedScene

func _ready():
	get_tree().paused = true
	melting_screen.generate_offsets()
	melting_screen.transition()

func _on_button_button_down():
	get_tree().paused = false
	get_tree().reload_current_scene()
	queue_free()

func _on_back_to_main_menu_up():
	await get_tree().create_timer(0.25).timeout
	get_tree().paused = false
	get_tree().change_scene_to_packed(main_menu)
