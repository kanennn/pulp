extends CharacterBody2D

@export var speed = 100 # Desired player speed (exported mainly for debug purposes)

func _physics_process(delta):
	handleMove()
	move_and_slide() # Activates built in movement handler

func handleMove():
	var dir = Input.get_vector("move_left", "move_right", "move_up", "move_down") # Grap vector from inputs
	velocity = dir * speed # Create velocity vector
