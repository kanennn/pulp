extends Control

@onready var musicButton = $Panel/VBoxContainer/Music

func _ready():
	if !Sound.getSoundSetting():
		musicButton.modulate.a = .5

func _on_continue_pressed():
	self.visible = false

func _on_exit_pressed():
	get_tree().quit()

func _on_music_toggled(toggled_on):
	if Sound.getSoundSetting():
		Sound.setSoundSetting(false)
		musicButton.modulate.a = .5
	else:
		Sound.setSoundSetting(true)
		musicButton.modulate.a = 1
