extends TextureButton

func _ready():
	var bus = AudioServer.get_bus_index("Master")
	pressed = AudioServer.is_bus_mute(bus)

func _on_MuteButton_pressed():
	var bus = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(bus, !AudioServer.is_bus_mute(bus))
