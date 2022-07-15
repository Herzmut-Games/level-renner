extends TextureButton

func _on_MuteButton_pressed():
	var bus = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(bus, !AudioServer.is_bus_mute(bus))
