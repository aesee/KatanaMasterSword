class_name ScreamsManager
extends AudioStreamPlayer

@export var sounds: Array[AudioStream] = []

func _ready():
	AudioManager.screams_manager = self
	
func play_scream():
	if !playing:
		var sound_to_play = sounds[randi() % sounds.size()]
		stream = sound_to_play
		play()

func _on_finished():
	stop()
	stream = null
