extends Node

@export var initState : State

var currentState : State
var states : Dictionary = {}

func _ready():
	for i in get_children():
		if i is State:
			states[i.name.to_lower()] = i 
			i.transitioned.connect(onChildTransitioned)
	
	if initState:
		initState.enter()
		currentState = initState

func _process(delta):
	if currentState:
		currentState.update(delta)

func _physics_process(delta):
	if currentState:
		currentState.physicsUpdate(delta)

func onChildTransitioned(state, newStateName):
	if state != currentState: return
	
	var newState = states.get(newStateName.to_lower())
	if !newState: return
	
	if currentState:
		currentState.exit()
	newState.enter()
	currentState = newState
