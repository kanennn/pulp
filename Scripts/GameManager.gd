extends Node2D

signal deth

@onready var ui = $CanvasLayer/UI
@onready var dayNight = $DayNightModulate
@onready var player = $Player

var isInteracting = false # Notifies any process that shouldn't activate when the player is interacting
var maxEssence = 0 # Increases when memories are collected 
var curEssence = 0 # Semi-healthbar for time able to survive at night
var isNight = false
var isInLight = false
var dead = false

func _ready():
	dead = false
	
	## Connect to self
	for i in get_tree().get_nodes_in_group("memories"): # Get and loop through all memories
		i.memoryObtained.connect(onMemoryObtained) # Connect the memoryobtained signals to the onmemoryobtained function
		i.memoryObtained.connect(player.onMemoryObtained) # Connect the memoryobtained signals to the player's onmemoryobtained function
	for i in get_tree().get_nodes_in_group("lamps"): # Get and loop through all lamps
		i.togglePlayerInLight.connect(togglePlayerInLight) # Connect the toggleplayerinlight signals to the toggleplayerinlight function
	dayNight.updateDayNight.connect(toggleTimeOfDay)
	
	## Connect to others
	deth.connect(player.onDeath) 

func _process(delta):
	updateEssence(delta)

func onMemoryObtained(): # Increase max essence and current essence then send off to the ui essence bar
	maxEssence += 1
	curEssence += 1
	
	ui.expandEssenceBar(maxEssence, curEssence)

func updateEssence(delta): 
	if isNight == true and isInLight == false: 
		if curEssence > 0: # If essence is greater than 0, decrease it (essence decreases at a rate of 1 per 10 seconds)
			curEssence -= .1 * delta
		elif curEssence <= 0 and dead == false: # If essence is less than 0 and the player is not already dead, initiate death protcol 
			isInteracting = true
			deth.emit()
			dead = true
	
	ui.updateEssenceBar(curEssence)

func toggleTimeOfDay(_isNight): # Get if night from the daynight script
	isNight = _isNight
	print("night"+str(isNight))

func togglePlayerInLight(_isInLight): # Get if in light from the lamp script
	isInLight = _isInLight
