extends State
class_name EnemyRush

signal dealDamage(damage)

@export var enemy : CharacterBody2D
@export var speed = 100

var gameManager : Node2D
var player : CharacterBody2D
var hasDealtDamage = false

func applyDamage():
	var damage = randf_range(.1, .5)
	dealDamage.emit(damage)
	hasDealtDamage = true
	print("hit")

func enter():
	player = get_tree().get_first_node_in_group("Player")
	gameManager = get_tree().get_first_node_in_group("GameManager")
	if !dealDamage.is_connected(gameManager.dealEnemyDamage):
		dealDamage.connect(gameManager.dealEnemyDamage)
	
	hasDealtDamage = false

func exit():
	pass

func update(_delta: float):
	pass

func physicsUpdate(_delta: float):
	
	var dir = enemy.global_position - player.global_position
	if dir.length() > 20:
		enemy.velocity = -dir.normalized() * speed
	elif dir.length() <= 20 and !hasDealtDamage:
		applyDamage()
	elif hasDealtDamage:
		transitioned.emit(self, "EnemyFollow")
