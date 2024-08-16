extends Node

var music_background : AudioStreamPlayer3D
var blades_audio_manager : AudioRandomPlayer
var footsteps : FootstepsAudioManager
var boss_music : BossMusic
var screams_manager : ScreamsManager

func reset():
	AudioServer.set_bus_effect_enabled(1, 0, true)
	AudioServer.set_bus_volume_db(1, 0)
