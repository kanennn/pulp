extends CharacterBody2D

##dont worry! the path in you see when you run the scene wont be there later

var movement_speed: float = 30.0 # npc speed
var movement_target_position: Vector2 = Vector2(0,0.0) # initial target position: can be changed later

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D # Navigation agent for navigating
@onready var col_box: CharacterBody2D = $"."
@onready var animation: AnimatedSprite2D = $"AnimatedSprite2D"

func _ready():
	## these values can be adjusted here, or in the inspector. they're her in case we need to change them here
	animation.autoplay = ""
	navigation_agent.debug_enabled = false
	navigation_agent.radius = 30
	navigation_agent.neighbor_distance = 1000
	#navigation_agent.target_desired_distance = 4.0
	call_deferred("actor_setup")

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	# Now that it's ready, set the movement target.
	set_movement_target(movement_target_position)

func set_movement_target(movement_target): # set the target destination
	navigation_agent.target_position = movement_target

func get_new_target(): # get a new random target location -> (x,y)
	var x = randi_range(-500,500)
	var y = randi_range(-500,500)
	return Vector2(x,y)

func _physics_process(delta):
	##amount of time to left to pause:
	var wait = $Timer.time_left
	
	if navigation_agent.is_target_reachable() and wait<=0.1: # if npc can get to location, and it waited long enough: get moving
		animation.play()
		var current_agent_position: Vector2 = global_position
		var next_path_position: Vector2 = navigation_agent.get_next_path_position() #get the next position to move to
		velocity = current_agent_position.direction_to(next_path_position) * movement_speed
		move_and_slide() #move
		
	if navigation_agent.is_navigation_finished(): #check if npc has arrived at target destination
		animation.pause()
		set_movement_target(get_new_target())
		$Timer.start(3.0)# start waiting. we can change this value to a random range
		return #since its done. just get out of the _physics_process func. i think i can remove it but just in case

	if navigation_agent.is_target_reachable()!=true: #if there is no way to get to target location: get a new target location
		#print("target not reachable")
		set_movement_target(get_new_target())
	if col_box.is_on_wall() or col_box.is_on_ceiling() or col_box.is_on_floor():
		set_movement_target(get_new_target())
