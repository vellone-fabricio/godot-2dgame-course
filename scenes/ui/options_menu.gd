extends CanvasLayer

signal back_pressed

@onready var window_button = %WindowButton as Button
@onready var sfx_slider = %SfxSlider as HSlider
@onready var music_slider = %MusicSlider as HSlider
@onready var back_button = %BackButton as Button


func _ready():
	window_button.pressed.connect(on_window_button_pressed)
	back_button.pressed.connect(on_back_button_pressed)
	sfx_slider.value_changed.connect(on_audio_changed.bind("sfx"))
	music_slider.value_changed.connect(on_audio_changed.bind("music"))
	
	update_display()


func update_display():
	window_button.text = "Windowed"
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		window_button.text = "Full Screen"
	
	sfx_slider.value = get_bus_volume_percent("sfx")
	music_slider.value = get_bus_volume_percent("music")


func get_bus_volume_percent(bus_name: String):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = AudioServer.get_bus_volume_db(bus_index)
	return db_to_linear(volume_db)


func set_bus_volume_percent(bus_name: String, percent: float):
	var bus_index = AudioServer.get_bus_index(bus_name)
	var volume_db = linear_to_db(percent)
	AudioServer.set_bus_volume_db(bus_index, volume_db)



func on_audio_changed(value: float, bus_name: String):
	set_bus_volume_percent(bus_name, value)


func on_window_button_pressed():
	var mode = DisplayServer.window_get_mode()
	if mode != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	update_display()


func on_back_button_pressed():
	await ScreenTransition.transition()
	back_pressed.emit()
