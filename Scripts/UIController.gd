extends Control

signal turnPage # Signal that emits when the "TurnDiaPage" action is pressed

@onready var gameManager = %GameManager
@onready var diaBox = $DialogueBox
@onready var diaText = $DialogueBox/Dialogue
@onready var essenceBar = $EssenceBar

func _ready():
	diaBox.visible = false # Make the dialoguebox invisible on start 
	essenceBar.visible = false # Make the essencebar invisible on start 
	essenceBar.scale.x = 0 # Scale the essencebar to 0 on start

func _input(event):
	if event is InputEventKey and event.pressed: # Test dialogue activated when "t" is pressed
		if event.keycode == KEY_T:
			var exDialogue = ["Knock Knock", "Who's there?", "Cow says", "Cow says who?", "No silly, a cow says moooo!"]
			handleDialogue(exDialogue)

func _process(_delta):
	if Input.is_action_just_pressed("Interact"): # Emit the turnPage signal when "TurnDiaPage" action is pressed
		turnPage.emit()

func handleDialogue(diaBlock): # Handles all dialogue. "diaBlock" is an array with each element as a page of the dialogue
	if gameManager.isInteracting == true: return # If already interacting with something else, end
	if diaBlock != null:
		gameManager.isInteracting = true # Tell the game that the player is now interacting with something
		
		diaText.text = diaBlock[0] # Make the dialogue text the first page of the dialogue block
		
		diaBox.visible = true 
		diaBox.position.y = 900 # Make sure the dialogue box is where it's supposed to be
		while diaBox.position.y > 660: # Move the box onto the screen
			diaBox.position.y -= 20
			await get_tree().create_timer(0.01).timeout # Coroutine: Create and wait for timer to finish
		
		for i in diaBlock.size(): # Cycle through each page of dialogue on "TurnDiaPage" action press
			diaText.text = diaBlock[i]
			await turnPage # Wait for the "turnPage" signal to emit
		
		while diaBox.position.y < 900: # Move the box off the screen
			diaBox.position.y += 20
			await get_tree().create_timer(0.01).timeout
		diaBox.visible = false
		
		gameManager.isInteracting = false # Tell the game that the player is no longer interacting with anything

func expandEssenceBar(maxEss, curEss):
	essenceBar.visible = true # Make sure the bar is visible (it is invisible at 0 essence)
	essenceBar.max_value = maxEss # Set new max essence
	essenceBar.value = curEss # Set new current essence as that mey be different from max essence at time of collection
	essenceBar.scale.x += .375 # .375 = 6 *scale of bar at full length* / 16 *maximum number of memories*

func updateEssenceBar(curEss):
	essenceBar.value = curEss
