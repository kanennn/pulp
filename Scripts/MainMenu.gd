extends Control


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Draft Level/draft_level.tscn")


func _on_sound_button_toggled(toggled_on):
	var soundToggle : bool
	if toggled_on:
		soundToggle = false
		$SoundButton.modulate.a = .5
	else:
		soundToggle = true
		$SoundButton.modulate.a = 1
	print(soundToggle)
	Sound.setSoundSetting(soundToggle)
