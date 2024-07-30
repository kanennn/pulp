extends CanvasModulate

const gameToRealMinDur = (2 * PI) / 720 # The game will by defult run 720 (12 mins) sec per ingame day

signal updateDayNight(dayNight:bool) # Tell the gamemanager that its just night or just day

@export var gradient : GradientTexture1D # For ambient color at different times of day
@export var timeSpeed = 1 # Game's speed (1 = defult)
@export var initTime : int # Initial time of day when the game runs

var time = 0
var dayNight = false # false = day, true = night
var gradValue = null

func _ready():
	add_to_group("DayNight")

func _process(delta):
	if time == 0:
		time = initTime * gameToRealMinDur * timeSpeed # Set initial time 
		
	time += delta * gameToRealMinDur * timeSpeed # Each second (delta) * real-time to game-time conversion * game speed multiplier
	var lastGradValue = gradValue 
	
	gradValue = (sin(time) + 1) / 2 # Scroll throught the ambiant color gradient with a sin function with a period of 720 seconds
	self.color = gradient.gradient.sample(gradValue) # Set the modulate to that color value
	
	if lastGradValue == null: return
	elif gradValue < .33 and lastGradValue > .33: # If the gradient is less than .33 through (nighttime) and it didn't used to be, tell the gamemanager it's night
		dayNight = true
		updateDayNight.emit(dayNight)
	elif gradValue > .33 and lastGradValue < .33: # If the gradient is more than .33 through (daytime) and it didn't used to be, tell the gamemanager it's day
		dayNight = false
		updateDayNight.emit(dayNight)
