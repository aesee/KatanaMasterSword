class_name AudioRandomPlayer
extends AudioStreamPlayer

@export var sounds: Array[AudioStream] = []
@export var failed_sounds: Array[AudioStream] = []
@export var finish_sound : AudioStream

func _ready():
	AudioManager.blades_audio_manager = self

func play_random_sound():
	var sound_to_play = sounds[randi() % sounds.size()]
	stream = sound_to_play
	play()

func play_finish_sound():
	stream = finish_sound
	play()

func play_fail_sound():
	var sound_to_play = failed_sounds[randi() % failed_sounds.size()]
	stream = sound_to_play
	play()
