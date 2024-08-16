class_name BossMusic
extends AudioStreamPlayer

@export var intro : AudioStream
@export var main_loop : AudioStream

func _ready():
	AudioManager.boss_music = self

func start():
	stream = intro
	play()
	finished.connect(_on_intro_finished)
	
func _on_intro_finished():
	stop()
	finished.disconnect(_on_intro_finished)
	stream = main_loop
	play()
