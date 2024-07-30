extends AnimatedSprite2D

signal memoryObtained # Tells gamemanager when a memory is collected

@onready var interactCollider = $InteractBox/CollisionShape2D 
@onready var prompt = $Prompt
@onready var UI = %GameManager/CanvasLayer/UI
@export var interactRadius = 50 # Desired interaction collider radius in px's 
@export var dialogueScript : Script # Desired dialogue from the dialogue folder

var isInRange = false
var isCollected = false

func _ready():
	add_to_group("memories")
	interactCollider.shape.radius = interactRadius # Set Interaction collider's radius to desired radius on start
	prompt.visible = false # Make prompt invisible on start 
	prompt.scale = Vector2(.05, .05) # Make prompt expected size at start

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if %GameManager.isInteracting == true: return # return end if player is interacting with something else
	if Input.is_action_just_pressed("Interact") and isInRange == true and isCollected == false: # Detect and interact
		##UI.handleDialogue(dialogueScript.dialogue) # Send dialogue to dialogue handler
		memoryObtained.emit() # Signal that a memory was obtained to the gamemanager
		isCollected = true
		
		while self.scale > Vector2(.1, .1): # Make the memory pop out
			if prompt.scale > Vector2(.05, .05): # Prompt will finish popping out before everything else so detect that
				prompt.scale -= Vector2(.1, .1)
			elif prompt.visible == true:
				prompt.visible = false
			self.scale -= Vector2(.1, .1)
			await get_tree().create_timer(0.01).timeout # Wait for a hot sec so this actually happens over time
		self.visible = false

func _on_interact_box_body_entered(body): # Detect when the player enters the interact area of the memory
	if body.name == "Player" and isCollected == false:
		isInRange = true
		
		prompt.visible = true # prompt visibility doubles as condition for interaction
		while prompt.scale < Vector2(.75, .75) and isInRange == true: # Make the prompt pop in 
			prompt.scale += Vector2(.1, .1)
			await get_tree().create_timer(0.01).timeout

func _on_interact_box_body_exited(body): # Detect when the player exits the interact area of the memory
	if body.name == "Player" and isCollected == false:
		isInRange = false
		
		while prompt.scale > Vector2(.05, .05) and isInRange == false: # Make the prompt pop out
			prompt.scale -= Vector2(.1, .1)
			await get_tree().create_timer(0.01).timeout
		prompt.visible = false
