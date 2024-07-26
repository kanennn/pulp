extends CharacterBody2D

@onready var shadow = $Shadow
@onready var player = $PlayerSprite
@export var speed = 100 # Desired player speed (exported mainly for debug purposes)

var absDet = 1.85 * (16.0 / 16.0)
#var absDet = 15 / 16.0
var time = 0.0
var isDying = false

func _ready():
	print("bro " + str(absDet))
	isDying = false
	$CPUParticles2D.emitting = false
	player.material.set_shader_parameter("deterioration", absDet)
	shadow.material.set_shader_parameter("deterioration", 0.0)
	#player.modulate.a = absDet

func _physics_process(delta):
	if time < 4:
		time += delta
	else:
		time = 0
	
	pulseShader(delta)
	
	if %GameManager.isInteracting == true: # return end and play idle if player is interacting with something else
		player.play("Idle")
		shadow.play("Idle")
		return 
	handleMove()
	move_and_slide() # Activates built in movement handler

func handleMove():
	var dir = Input.get_vector("move_left", "move_right", "move_up", "move_down") # Grap vector from inputs
	velocity = dir * speed # Create velocity vector
	
	print(dir)
	
	if dir.x > 0 and dir.y == 0:
		player.flip_h = true
		shadow.flip_h = true
	else:
		player.flip_h = false
		shadow.flip_h = false
	
	if dir == Vector2(0.0, 0.0):
		player.play("Idle")
		shadow.play("Idle")
	elif dir.y < 0:
		player.play("Up")
		shadow.play("Up")
	elif dir.y > 0:
		player.play("Down")
		shadow.play("Down")
	elif dir.x != 0 and dir.y == 0:
		player.play("Side")
		shadow.play("Side")

func pulseShader(delta):
	if isDying == true: return
	if absDet < 1.85 and absDet > 0: 
		var detOffset = 0.4 * sin((PI) * time)
		#var detOffset = 0.1 * sin((PI/2) * time)
		#print(detOffset)
		
		player.material.set_shader_parameter("deterioration", absDet + detOffset)
		#player.modulate.a = absDet + detOffset

func onDeath():
	%GameManager.isInteracting = true
	isDying = true
	
	Engine.time_scale = .5
	$CPUParticles2D.emitting = true
	
	while absDet < 1.85:
		absDet += .01
		
		#player.material.set_shader_parameter("deterioration", absDet)
		#shadow.material.set_shader_parameter("deterioration", absDet)
		await get_tree().create_timer(.01).timeout
	
	$CPUParticles2D.emitting = false
	
	await get_tree().create_timer(1).timeout
	Engine.time_scale = 1
	get_tree().reload_current_scene()
