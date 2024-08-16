extends CanvasLayer

@export var melting_screen : MeltingScreen
@export var main_menu : PackedScene
@export var texts : Array[Label]

func _ready():	
	_hide_all_messages() 
	melting_screen.generate_offsets()
	melting_screen.transition()
	await get_tree().create_timer(1.5).timeout
	for text in texts:
		await _display_message(text, 4)
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_packed(main_menu)

func _hide_all_messages():
	for text in texts:
		text.visible = false
		text.modulate.a = 0.0

func _display_message(text, time):
	text.visible = true
	var tw = get_tree().create_tween()
	tw.tween_property(text, "modulate:a", 1.0, 2)
	tw.chain().tween_interval(time)
	tw.chain().tween_property(text, "modulate:a", 0.0, 2)
	await tw.finished
	text.visible = false
