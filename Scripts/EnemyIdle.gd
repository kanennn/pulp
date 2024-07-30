extends State
class_name EnemyIdle

@export var enemy : CharacterBody2D
@export var rayCast : RayCast2D
@export var speed = 0.0

var player : CharacterBody2D
var moveDir : Vector2
var wanderTime : float
var playerInLight = false

func playerIsInLight(_isInLight):
	if _isInLight == null: return 
	playerInLight = _isInLight

func randomizeDir():
	moveDir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wanderTime = randf_range(1, 3)

func enter():
	player = get_tree().get_first_node_in_group("Player")
	for i in get_tree().get_nodes_in_group("lamps"):
		if !i.togglePlayerInLight.is_connected(playerIsInLight):
			i.togglePlayerInLight.connect(playerIsInLight)
	randomizeDir()

func exit():
	pass

func update(delta: float):
	if !enemy.visible: return
	
	if wanderTime > 0:
		wanderTime -= delta
	else:
		randomizeDir()

func physicsUpdate(_delta: float):
	if !enemy.visible: return
	
	if enemy:
		enemy.velocity = moveDir * speed
	
	var dist = (player.global_position - enemy.global_position).length()
	if dist < 100 and playerInLight ==false:
		if rayCast.get_collider() == null: return
		elif rayCast.get_collider().name == "Player":
			transitioned.emit(self, "EnemyFollow")
