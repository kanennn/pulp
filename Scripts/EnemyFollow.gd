extends State
class_name EnemyFollow

@export var enemy : CharacterBody2D
@export var rayCast : RayCast2D
@export var speed = 95

var targetCircle = Area2D.new()
var player : CharacterBody2D
var playerInLight = false
var randDir : Vector2
var dirTime : float
var targetDelay : float

func playerIsInLight(_isInLight):
	if _isInLight == null: return 
	playerInLight = _isInLight

#func detectInTargetCircle(body):
	#if body == enemy:
		#inTarget = true
	#print(inTarget)
#
#func detectOutTargetCircle(body):
	#if body == enemy:
		#inTarget = false
	#print(inTarget)

func randomizeDir():
	randDir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	dirTime = randf_range(.5, 1)

func getNearestCirclePoint():
	var dist = player.to_local(enemy.global_position) 
	var center = player.global_position
	var radius = 40
	var angle = atan(dist.y / dist.x)
	if dist.x > 0:
		angle += PI
	var x = center.x - (radius * cos(angle))
	var y = center.y - (radius * sin(angle))
	
	return Vector2(x, y)

func isRayStillHitting():
	if rayCast.get_collider() == null: return false
	elif rayCast.get_collider().name == "Player": return true
	else: return false

func enter():
	player = get_tree().get_first_node_in_group("Player")
	for i in get_tree().get_nodes_in_group("lamps"):
		if !i.togglePlayerInLight.is_connected(playerIsInLight):
			i.togglePlayerInLight.connect(playerIsInLight)
	
	targetDelay = 4
	
	#targetCircle.body_entered.connect(detectInTargetCircle)
	#targetCircle.body_exited.connect(detectOutTargetCircle)
	#
	#var areaCollider = CollisionShape2D.new()
	#var colliderShape = CircleShape2D.new()
	#
	#colliderShape.radius = 30
	#areaCollider.shape = colliderShape
	#targetCircle.add_child(areaCollider)
	#player.add_child(targetCircle)

func exit():
	pass
	#targetCircle.get_child(0).queue_free()

func update(delta: float):
	if dirTime > 0:
		dirTime -= delta
	else:
		randomizeDir()
	
	if targetDelay > 0:
		targetDelay -= delta

func physicsUpdate(_delta: float):
	if !enemy.visible: return
	
	var dir = enemy.global_position - getNearestCirclePoint()
	if dir.length() > 10:
		enemy.velocity = -dir.normalized() * speed + randDir * 10
	elif dir.length() <= 10:
		enemy.velocity = -dir.normalized() * dir.length() * (speed / 10.0)
	
	
	if dir.length() <= 10 and targetDelay <= 0:
		transitioned.emit(self, "EnemyRush")
	
	if dir.length() > 100 or isRayStillHitting() == false or playerInLight:
		transitioned.emit(self, "EnemyIdle")
