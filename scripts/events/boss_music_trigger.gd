extends Area3D

func _on_player_entered(body):
	if body is MainHero:
		AudioManager.boss_music.start()
		AudioManager.music_background.stop()
