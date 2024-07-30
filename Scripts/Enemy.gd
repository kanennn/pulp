extends CharacterBody2D

@onready var light = $PointLight2D
@onready var rayCast = $CanFollowCheck
@onready var collider = $Collider

var player : CharacterBody2D
var dayNight : CanvasModulate

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	dayNight = get_tree().get_first_node_in_group("DayNight")
	dayNight.updateDayNight.connect(enableEnemy)
	
	self.modulate.a = 0
	self.visible = false
	light.energy = 0
	collider.set_deferred("disabled", true)
	
func _physics_process(_delta):
	move_and_slide()
	
	rayCast.set_target_position(self.to_local(player.global_position))

func enableEnemy(isNight):
	if isNight == true and !self.visible:
		self.visible = true
		collider.set_deferred("disabled", false)
		while self.modulate.a < 1:
			if light.energy < .1:
				light.energy += .005
			else:
				self.modulate.a += .05
				
			await get_tree().create_timer(.02).timeout
	
	elif isNight == false and self.visible:
		while light.energy < .1:
			if self.modulate.a < 1:
				self.modulate.a += .05
			else:
				light.energy += .005
			
			await get_tree().create_timer(.02).timeout
		self.visible = false
		collider.set_deferred("disabled", true)
