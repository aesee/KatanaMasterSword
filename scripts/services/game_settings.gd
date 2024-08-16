extends Node

var difficulty : int = 2
var sound_volume : int = 10
var vibration : bool = true
var one_hit_mode : bool = false

const config_path = "user://settings.dat"

func _ready():
	_load()

func set_difficulty(value):
	if (difficulty != value):
		difficulty = value
		_save()

func set_sound_volume(value):
	if (sound_volume != value):
		sound_volume = value
		_save()

func set_vibration(value):
	if (vibration != value):
		vibration = value
		_save()

func _save():
	var settings = FileAccess.open(config_path, FileAccess.WRITE)
	settings.store_var(difficulty)
	settings.store_var(sound_volume)
	settings.store_var(vibration)

func _load():
	if not FileAccess.file_exists(config_path):		
		return false
	#var content = FileAccess.get_file_as_bytes(config_path)
	#var settings = bytes_to_var_with_objects(content)
	var file = FileAccess.open(config_path, FileAccess.READ)
	difficulty = file.get_var()
	sound_volume = file.get_var()
	vibration = file.get_var()
	return true
