extends CanvasLayer

@export var melting_screen : MeltingScreen
@export var main_menu : PackedScene
@export var text : Control

func _ready():
	text.modulate.a = 0.0 
	melting_screen.generate_offsets()
	melting_screen.transition()
	await get_tree().create_timer(1.5).timeout
	var tw = get_tree().create_tween()
	tw.tween_property(text, "modulate:a", 1.0, 2)
	tw.chain().tween_interval(4)
	tw.chain().tween_property(text, "modulate:a", 0.0, 2)
	await tw.finished
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_packed(main_menu)
