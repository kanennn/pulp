extends AnimatedSprite2D

@onready var interactCollider = $InteractBox/CollisionShape2D 
@onready var prompt = $Prompt
@onready var UI = %GameManager/CanvasLayer/UI
@export var interactRadius = 50 # Desired interaction collider radius in px's 
@export var dialogueScript : Script # Desired dialogue from the dialogue folder

func _ready():
	interactCollider.shape.radius = interactRadius # Set Interaction collider's radius to desired radius on start
	prompt.visible = false # Make prompt invisible on start 
	prompt.scale = Vector2(.05, .05) # Make prompt expected size at start

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("Interact") and prompt.visible == true: # Detect and interaction
		UI.handleDialogue(dialogueScript.dialogue) # Send dialogue to dialogue handler
		
		## Add essence to player here

func _on_interact_box_body_entered(body): # Detect when the player enters the interact area of the memory
	if body.name == "Player":
		prompt.visible = true # prompt visibility doubles as condition for interaction
		while prompt.scale < Vector2(.75, .75): # Make the prompt pop in 
			prompt.scale += Vector2(.1, .1)
			await get_tree().create_timer(0.01).timeout

func _on_interact_box_body_exited(body): # Detect when the player exits the interact area of the memory
	if body.name == "Player":
		while prompt.scale > Vector2(.05, .05): # Make the prompt pop out
			prompt.scale -= Vector2(.1, .1)
			await get_tree().create_timer(0.01).timeout
		prompt.visible = false