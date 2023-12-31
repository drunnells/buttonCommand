extends KinematicBody2D

var speed = 100  # Speed of the sprite
var moveToDeg = 0
var rotationSpeed = 500
var tween = Tween.new()
var shadowSprite

func _ready():
	add_child(tween)
	shadowSprite = $AnimatedSprite.duplicate()
	add_child(shadowSprite)
	shadowSprite.visible = true
	shadowSprite.z_index = $AnimatedSprite.z_index -1
	shadowSprite.play("shadow")
	$AnimatedSprite.play("default")

func fireGun():
	get_node("..").addPlayerBullet(global_position,moveToDeg)

func setMoveDeg(inDeg):
	var newDeg = moveToDeg + inDeg
	# Normalize the new target degree
	newDeg = fmod(newDeg, 360)
	if newDeg < 0:
		newDeg += 360
	moveToDeg = newDeg

	var current_rotation_degrees = rad2deg(rotation)
	var target_rotation_degrees = moveToDeg

	# Normalize current rotation to 0-360 range
	current_rotation_degrees = fmod(current_rotation_degrees, 360)
	if current_rotation_degrees < 0:
		current_rotation_degrees += 360

	# Calculate shortest rotation path
	var delta = target_rotation_degrees - current_rotation_degrees
	if delta > 180:
		delta -= 360
	elif delta < -180:
		delta += 360

	var shortest_target_rotation_degrees = current_rotation_degrees + delta

	# Interpolate using the shortest path
	tween.stop_all()
	tween.interpolate_property(self, "rotation", deg2rad(current_rotation_degrees), deg2rad(shortest_target_rotation_degrees), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func moveForward(degrees):
	var radians = deg2rad(degrees)  # Convert degrees to radians
	var direction = Vector2(1, 0).rotated(radians)  # Get direction vector
	var origPos = global_position
	var _velocity = move_and_slide(direction * speed)  # Move the sprite
	for i in range(get_slide_count()):
		var collision = get_slide_collision(i)
		#print("COLLIDED WITH: ", collision.collider.name)
	#if (abs(global_position.x) > get_node("..").levelLimit.x):
	#	global_position.x = origPos.x
	#if (abs(global_position.y) > get_node("..").levelLimit.y):
	#	global_position.y = origPos.y

func _process(_delta):
	moveForward(moveToDeg)
	shadowSprite.global_position.x = global_position.x + 7
	shadowSprite.global_position.y = global_position.y + 7
