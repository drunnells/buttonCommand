extends Node2D

var dotsTimer = Timer.new()
var controlDotsNode
var playerNode
var lastPlayerAction = "off"
export(Vector2) var levelLimit = Vector2(100,100)


func _ready():
	$bullet.visible = false
	$Camera2D.limit_left = levelLimit.x * -1
	$Camera2D.limit_right = levelLimit.x
	$Camera2D.limit_top = levelLimit.y * -1
	$Camera2D.limit_bottom = levelLimit.y
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
		var curDotAction = getDotAction()
		print("DOT ACTION: " + curDotAction)
		setPlayerAction(curDotAction)

func setPlayerAction(inAction):
	match inAction:
		"moveLeft":
			playerNode.setMoveDeg(-45)
		"moveRight":
			playerNode.setMoveDeg(45)
		"fire":
			playerNode.fireGun()
		"off":
			pass
		_:
			pass

func addPlayerBullet(startPos,rotDeg):
	print(startPos)
	var newBullet = $bullet.duplicate()
	add_child(newBullet)
	newBullet.global_position = startPos
	newBullet.rotation_degrees = rotDeg
	newBullet.visible = true
	newBullet.get_node("Area2D").connect("body_entered", self, "_on_player_bullet_contact", [newBullet])
	var bulletDirection = Vector2(cos(deg2rad(rotDeg)),sin(deg2rad(rotDeg)))
	newBullet.apply_impulse(Vector2(),bulletDirection.normalized() * 400)

func _process(_delta):
	pass

func _on_player_bullet_contact(body,bullet):
	print("GOT HERE")
	bullet.queue_free()
