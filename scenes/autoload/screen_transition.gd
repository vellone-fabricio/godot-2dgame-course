extends CanvasLayer


func transition():
	$AnimationPlayer.play("default")
	await $AnimationPlayer.animation_finished

	$AnimationPlayer.play_backwards("default")

func transition_to_scene(scene_path: ):
	await transition()
	get_tree().change_scene_to_file(scene_path)
