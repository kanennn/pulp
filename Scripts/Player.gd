extends CharacterBody2D

@export var speed = 100

func _physics_process(delta):
	handleMove()
	move_and_slide()

func handleMove():
	var dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	velocity = dir * speed
