extends CharacterBody2D

@export var speed = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	handleMove()

func handleMove():
	var dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	velocity = dir * speed
