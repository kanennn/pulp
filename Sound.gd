extends Node

signal settingChanged

var toggleSound = true

func getSoundSetting():
	return toggleSound

func setSoundSetting(newToggleSound):
	toggleSound = newToggleSound
	settingChanged.emit()
