extends Node2D

var badGuyPathPerc = 0.0
var badGuySpeed = 0.02
var shadowBadGuySprite = null
var gunNode = null
var badGuySprite = null

func _ready():
	shadowBadGuySprite = $badGuyPath/badGuyPathFollow/badGuyBody/AnimatedSprite.duplicate()
	gunNode = $badGuyPath/badGuyPathFollow/badGuyBody/bgGunAnimatedSprite
	badGuySprite = $badGuyPath/badGuyPathFollow/badGuyBody/AnimatedSprite
	badGuySprite.play("default")
	gunNode.play("default")
	shadowBadGuySprite.visible = 1
	shadowBadGuySprite.z_as_relative = false
	shadowBadGuySprite.z_index = -1
	$badGuyPath/badGuyPathFollow/badGuyBody.add_child(shadowBadGuySprite)
	shadowBadGuySprite.play("shadow")

func _process(delta):
	badGuyPathPerc += delta * badGuySpeed
	#var distanceToPlayer = badGuySprite.global_position.distance_to(playerNode.global_position)
	#iif abs(distanceToPlayer) < 300:
	var playerNode = get_node("..").playerNode
	if playerNode:
		gunNode.look_at(playerNode.global_position)
	$badGuyPath/badGuyPathFollow.unit_offset = badGuyPathPerc
	shadowBadGuySprite.global_position.x = badGuySprite.global_position.x + 7
	shadowBadGuySprite.global_position.y = badGuySprite.global_position.y + 7
