extends Node2D

var dotsTimer = Timer.new()
var controlDotsNode
var playerNode
var lastPlayerAction = "off"

func _ready():
	playerNode = $playerSprite
	controlDotsNode = playerNode.get_node("controlDots")
	controlDotsNode.initDots(20)
	startDotsTimer(0.5)

func startDotsTimer(timerSecs):
	add_child(dotsTimer)
	dotsTimer.connect("timeout", self, "_on_Timer_timeout")
	dotsTimer.set_wait_time(timerSecs)
	dotsTimer.set_one_shot(false) # Make sure it loops
	dotsTimer.start()

func getDotOn():
	return controlDotsNode.dotOn

func getDotAction():
	return controlDotsNode.dotAction

func _on_Timer_timeout():
	controlDotsNode.nextDot()

func _input(_ev):
	if Input.is_key_pressed(KEY_SPACE):
		print("SPACE")
		var curDotAction = getDotAction()
		print("DOT ACTION: " + curDotAction)
		setPlayerAction(curDotAction)

func setPlayerAction(inAction):
	match inAction:
		"moveLeft":
			playerNode.setMoveDeg(-45)
		"moveRight":
			playerNode.setMoveDeg(45)
		"off":
			pass
		_:
			pass

func _process(_delta):
	pass
