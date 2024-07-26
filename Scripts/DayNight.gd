extends StaticBody2D

var state = 1
var cycleState = false
var dayLength = 10
var nightLength = 10

func _ready():
	$ColorRect.color.a = 0
	#$".".visible = true

func _on_timer_timeout():
	if state == 1:
		state = 2
		cycleToNight()
	elif state == 2:
		state = 1
		cycleToDay()
	
	cycleState = true

#func _process(delta):
	#if cycleState == true:
		#cycleState = false
		#if state == 1:
			#cycleToNight()
		#elif state == 2:
			#cycleToDay()
	
func cycleToNight():
	$AnimationPlayer.play("DayToNight")
	await $AnimationPlayer.animation_finished
	$Timer.wait_time = nightLength
	$Timer.start()

func cycleToDay():
	$AnimationPlayer.play("NightToDay")
	await $AnimationPlayer.animation_finished
	$Timer.wait_time = dayLength
	$Timer.start()
