extends AnimatedSprite2D

@onready var interactBox = $InteractBox/CollisionShape2D # Grab interaction collider
@export var interactRadius = 20 # Desired interaction collider radius in px's 

func _ready():
	interactBox.shape.radius = interactRadius # Set Interation collider's radius to desired radius on start

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
