extends KinematicBody2D

var speed = 50  # Speed of the sprite
var moveToDeg = 0

func setMoveDeg(inDeg):
	moveToDeg = inDeg
	set_rotation_degrees(inDeg)

func move_forward(degrees):
	var radians = deg2rad(degrees)  # Convert degrees to radians
	var direction = Vector2(1, 0).rotated(radians)  # Get direction vector
	move_and_slide(direction * speed)  # Move the sprite

func _process(delta):
	move_forward(moveToDeg)
