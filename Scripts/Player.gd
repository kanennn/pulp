extends CharacterBody2D

@onready var shadow = $Shadow
@onready var player = $PlayerSprite
@onready var particles = $CPUParticles2D
@export var speed = 90 # Desired player speed (exported mainly for debug purposes)

#var absDet = 1.85 * (16.0 / 16.0)
var absDet = 0.0 / 16.0 # absolute deterioration (opaqueness) of the sprite
var time = 0.0 # For pulse effect of sprite
var isDying = false


func _ready():
	add_to_group("Player")
	isDying = false
	particles.emitting = false
	#player.material.set_shader_parameter("deterioration", absDet)
	#shadow.material.set_shader_parameter("deterioration", 0.0)
	player.modulate.a = absDet

func _physics_process(delta):
	if time < 4: # Reset time after 4 seconds as to not let it go to infinity
		time += delta
	else:
		time = 0
	
	pulseShader()
	
	if %GameManager.isInteracting == true: # return end and play idle if player is interacting with something else
		player.play("Idle")
		shadow.play("Idle")
		return 
	handleMove()
	move_and_slide() # Activates built in movement handler

func handleMove():
	var dir = Input.get_vector("move_left", "move_right", "move_up", "move_down") # Grap vector from inputs
	velocity = dir * speed # Create velocity vector
	
	#print(dir)
	
	if dir.x > 0 and dir.y == 0: # If moving right and only right, flip sprite over the y-axis
		player.flip_h = true
		shadow.flip_h = true
	else:
		player.flip_h = false
		shadow.flip_h = false
	
	if dir == Vector2(0.0, 0.0): # If not moving, play the idle animation
		player.play("Idle")
		shadow.play("Idle")
	elif dir.y < 0: # If moving up (inculding diagonals), play the up animation
		player.play("Up")
		shadow.play("Up")
	elif dir.y > 0: # If moving down (including diagonals), play the down animation
		player.play("Down")
		shadow.play("Down")
	elif dir.x != 0 and dir.y == 0: # if moving to either side (excluding diagonals), play the side animation
		player.play("Side")
		shadow.play("Side")

func pulseShader(): # Pulse the opacity of the char when inbetween 1 and 0
	if isDying == true: return
	if absDet < 1 and absDet > 0: 
		#var detOffset = 0.4 * sin((PI) * time)
		var detOffset = 0.2 * sin((2 * PI) * time)
		#print(detOffset)
		
		#player.material.set_shader_parameter("deterioration", absDet + detOffset)
		player.modulate.a = absDet + detOffset

func onDeath():
	isDying = true
	
	#var dist = player.modulate.a - absDet
	#var count = 0
	#while player.modulate.a != absDet:
		#if count != 50:
			#player.modulate.a += dist / 50
		#elif count == 50:
			#player.modulate.a = absDet
		#await get_tree().create_timer(.01).timeout
	
	Engine.time_scale = .75 # Make the engine run slower
	particles.emitting = true # emit death particles
	
	while shadow.modulate.a > 0: # fade out body then shadow
		if absDet > 0:
			absDet -= .01
			player.modulate.a = absDet
		else:
			shadow.modulate.a -= 0.2
		
		#player.material.set_shader_parameter("deterioration", absDet)
		#shadow.material.set_shader_parameter("deterioration", absDet)
		await get_tree().create_timer(.02).timeout
	
	particles.emitting = false # stop emitting death particles
	
	await get_tree().create_timer(1).timeout # wait a sec
	Engine.time_scale = 1 # reset time scale
	print("deth... bleh")

func onMemoryObtained(): # increase opacity on memory obtained
	absDet += 1.0 / 16.0
