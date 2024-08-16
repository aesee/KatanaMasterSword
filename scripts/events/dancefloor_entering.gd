extends GameScriptEvent

func execute():
	AudioServer.set_bus_effect_enabled(1, 0, false)
	AudioServer.set_bus_volume_db(1, 1)
