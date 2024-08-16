extends CanvasLayer

@export var nightclub_level : PackedScene
@export var ui_control : Control
@export var music : AudioStreamPlayer
@export var main_menu_layer : Control
@export var credits_layer : Control

@export var difficulty_slider : Slider
@export var sound_volume_slider : Slider
@export var vibration_toggle : CheckButton
@export var one_hit_mode_toggle : CheckButton

@export var quit_button : Button

func _ready():
	difficulty_slider.value = GameSettings.difficulty
	sound_volume_slider.value = GameSettings.sound_volume
	vibration_toggle.button_pressed = GameSettings.vibration
	one_hit_mode_toggle.button_pressed = GameSettings.one_hit_mode
	
	var pc_version = OS.get_name() == "Windows"
	quit_button.visible = pc_version
	vibration_toggle.visible = !pc_version

func _on_nightclub_start_button():
	ui_control.visible = false
	music.playing = false
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_packed(nightclub_level)

func _on_sound_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(0, value)
	var mute = value <= -30
	AudioServer.set_bus_mute(0, mute)
	GameSettings.set_sound_volume(value)

func _on_difficulty_slider_value_changed(value):
	GameSettings.set_difficulty(value)

func _on_credits_button_up():
	main_menu_layer.visible = false
	credits_layer.visible = true

func _on_credits_close_button_up():
	main_menu_layer.visible = true
	credits_layer.visible = false

func _on_vibration_toggle_toggled(toggled_on):
	GameSettings.set_vibration(toggled_on)

func _on_one_hit_toggled(toggled_on):
	GameSettings.one_hit_mode = toggled_on

func _on_quit_button_down():
	get_tree().quit()
