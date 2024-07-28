extends StaticBody2D

signal togglePlayerInLight(isInLight:bool) # Tell gamemanager if the player is in light for purposes of essence

@onready var lightRange = $LightRange

var isInLight = false

func _ready():
	add_to_group("lamps") # Add to each lamp instance to the lamps group

func _on_light_range_body_entered(body): # Detect if player enters the light's range and tells gamemanager
	if body.name == "Player":
		isInLight = true
		togglePlayerInLight.emit(isInLight)

func _on_light_range_body_exited(body):# Detect if player exits the light's range and tells gamemanager
	if body.name == "Player":
		isInLight = false
		togglePlayerInLight.emit(isInLight)
