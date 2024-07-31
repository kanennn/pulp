extends Control

func _on_continue_pressed():
	self.visible = false

func _on_exit_pressed():
	get_tree().quit()



func _on_music_toggled(toggled_on):
	pass # Replace with function body.
