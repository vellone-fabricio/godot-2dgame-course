extends CanvasLayer

var options_scene = preload("res://scenes/ui/options_menu.tscn")

func _ready():
	%PlayButton.pressed.connect(on_play_button)
	%OptionsButton.pressed.connect(on_options_button)
	%QuitButton.pressed.connect(on_quit_button)
	%UpgradesButton.pressed.connect(on_upgrades_button)

func on_play_button():
	await ScreenTransition.transition()
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")


func on_options_button():
	await ScreenTransition.transition()
	var options_instance = options_scene.instantiate()
	add_child(options_instance)
	options_instance.back_pressed.connect(on_back_pressed.bind(options_instance))


func on_quit_button():
	get_tree().quit()


func on_back_pressed(options_instance: Node):
	options_instance.queue_free()

func on_upgrades_button():
	ScreenTransition.transition_to_scene("res://scenes/ui/meta_menu.tscn")
