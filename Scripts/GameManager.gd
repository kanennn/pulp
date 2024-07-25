extends Node2D

var isInteracting = false # Notifies any process that shouldn't activate when the player is interacting
var maxEssence = 0 # Increases when memories are collected 
var curEssence = 0 # Semi-healthbar for time able to survive at night

var time = 0 ## TESTING

func _ready():
	for i in get_tree().get_nodes_in_group("memories"): # Get and loop through all memories, connecting their memoryobtained signals to the onmemoryobtained function
		i.memoryObtained.connect(onMemoryObtained)

func _process(delta):
	time += delta ## TESTING
	
	updateEssence()

func onMemoryObtained(): 
	maxEssence = 1
	curEssence += 1
	
	$CanvasLayer/UI.expandEssenceBar(maxEssence, curEssence)

func updateEssence():
	curEssence = (abs(sin(time)) + .01) * maxEssence ## TESTING
	
	$CanvasLayer/UI.updateEssenceBar(curEssence)
