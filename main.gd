extends Node2D

var playerHealth = 100
var badGuyHealth = 100
var bulletDamage = 10
var itemHealthValue = 20
var itemSpeedUpValue = 20
var itemSpeedDownValue = 20

var dotsTimer = Timer.new()
var controlDotsNode
var playerNode
var lastPlayerAction = "off"
var bulletSpeed = 500
var lastBadGuyShot = 0
var badGuyCoolDown = 1
export(Vector2) var levelLimit = Vector2(200,200)
export(Vector2) var playerStartLocation = Vector2(0,0)
export(int) var dropItems = 0

func _ready():
	$bullet.visible = false
	$Camera2D.limit_left = levelLimit.x * -1
	$Camera2D.limit_right = levelLimit.x
	$Camera2D.limit_top = levelLimit.y * -1
	$Camera2D.limit_bottom = levelLimit.y
	$mazeMap.get_node("itemArea").visible = false
	var rectShape = RectangleShape2D.new()
	rectShape.extents = Vector2(levelLimit.x, levelLimit.y)
	$mazeMap/mapArea/mapCollisionShape.shape = rectShape
	$mazeMap/mapArea.connect("area_exited", self, "_on_map_exit", [])
	$mazeMap/mapArea.connect("body_exited", self, "_on_map_exit", [])

	playerNode = $playerSprite
	playerNode.global_position.x = playerStartLocation.x
	playerNode.global_position.y = playerStartLocation.y
	controlDotsNode = playerNode.get_node("controlDots")
	controlDotsNode.initDots(20)
	startDotsTimer(0.5)

	$mazeMap.dropItems(dropItems)

func _on_map_exit(body):
	print("AREA EXIT")
	print(body.name)
	if (body.name == "bulletArea"):
		body.queue_free()
	if (body.name == "playerCenterArea"):
		var playerCenterPos = playerNode.get_node("playerCenterArea").global_position
		if playerCenterPos.x > levelLimit.x:
			playerNode.global_position.x = levelLimit.x
		if playerCenterPos.x < (levelLimit.x * -1):
			playerNode.global_position.x = (levelLimit.x * -1)
		if playerCenterPos.y > levelLimit.y:
			playerNode.global_position.y = levelLimit.y
		if playerCenterPos.y < (levelLimit.y * -1):
			playerNode.global_position.y = (levelLimit.y * -1)

func startDotsTimer(timerSecs):
	add_child(dotsTimer)
	dotsTimer.connect("timeout", self, "_on_Timer_timeout")
	dotsTimer.set_wait_time(timerSecs)
	dotsTimer.set_one_shot(false)
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

func addBullet(startPos,rotDeg,bulletType):
	print(startPos)
	var newBullet = $bullet.duplicate()
	add_child(newBullet)
	newBullet.global_position = startPos
	newBullet.rotation_degrees = rotDeg
	newBullet.visible = true
	newBullet.get_node("bulletAnimatedSprite").play("default")
	newBullet.get_node("bulletArea").connect("body_entered", self, "_on_bullet_contact", [newBullet,bulletType])
	var bulletDirection = Vector2(cos(deg2rad(rotDeg)),sin(deg2rad(rotDeg)))
	newBullet.apply_impulse(Vector2(),bulletDirection.normalized() * bulletSpeed)

func addPlayerBullet(startPos,rotDeg):
	addBullet(startPos,rotDeg,"player")

func addBadGuyBullet(startPos,rotDeg):
	addBullet(startPos,rotDeg,"badGuy")

func get_direction_in_degrees(from_position, to_position):
  var direction = to_position - from_position
  var angle_radians = atan2(direction.y, direction.x)
  var angle_degrees = rad2deg(angle_radians)
  return angle_degrees

func _process(delta):
	badGuyShoot(delta)
	updateHud()

func badGuyShoot(delta):
	if lastBadGuyShot < (OS.get_unix_time() - badGuyCoolDown):
		lastBadGuyShot = OS.get_unix_time()
		print("FIRE")
		var badGuyPos = get_node("mazeMap/badGuyPath/badGuyPathFollow/badGuyBody").global_position
		var goodGuyPos = get_node("playerSprite").global_position
		var bulletDeg = get_direction_in_degrees(badGuyPos,goodGuyPos)
		addBadGuyBullet(badGuyPos,bulletDeg)


func _on_bullet_contact(body,bullet,bulletType):
	if bulletType == "player" && body.name == "playerSprite":
		return
	if bulletType == "badGuy" && body.name == "badGuyBody":
		return
	print("OBJECT HIT: " + String(body.name))
	bullet.linear_velocity = Vector2.ZERO
	bullet.angular_velocity = 0
	bullet.get_node("bulletAnimatedSprite").play("hit")

	if bulletType == "player" && body.name == "badGuyBody":
		badGuyHealth = badGuyHealth - bulletDamage

	if bulletType == "badGuy" && body.name == "playerSprite":
		playerHealth = playerHealth - bulletDamage

	var timer = Timer.new()
	timer.wait_time = 3
	timer.one_shot = true
	timer.connect("timeout", self, "_bullet_queue_free", [bullet, timer])
	add_child(timer)
	timer.start()

func _bullet_queue_free(node, timer):
	timer.queue_free()
	if is_instance_valid(node):
		node.queue_free()
		print("KILLED BULLET")
	else:
		print("INVALID BULLET NODE")

func updateHud():
	$HUD.get_node("hudContainer/hudInfo").text = "Player Health: " + String(playerHealth) + "\nBad Guy Health: " + String(badGuyHealth)

func applyItem(itemType):
	match(itemType):
		"bullets":
			pass
		"faster":
			pass
		"health":
			playerHealth = playerHealth + itemHealthValue
			if (playerHealth > 100):
				playerHealth = 100
		"slower":
			pass
