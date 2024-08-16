class_name FootstepsAudioManager
extends AudioStreamPlayer

func _ready():
	AudioManager.footsteps = self
	play()
	stream_paused = true

func play_step():
	stream_paused = false
	await get_tree().create_timer(0.35).timeout
	stream_paused = true
