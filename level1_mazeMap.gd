extends Node2D

var badGuyPathPerc = 0.0
var badGuySpeed = 0.01
var shadowBadGuySprite = null

func _ready():
	shadowBadGuySprite = $badGuyPath/badGuyPathFollow/badGuyBody/AnimatedSprite.duplicate()
	$badGuyPath/badGuyPathFollow/badGuyBody/AnimatedSprite.play("default")
	shadowBadGuySprite.visible = 1
	shadowBadGuySprite.z_as_relative = false
	shadowBadGuySprite.z_index = -1
	$badGuyPath/badGuyPathFollow/badGuyBody.add_child(shadowBadGuySprite)
	shadowBadGuySprite.play("shadow")

func _process(delta):
	badGuyPathPerc += delta * badGuySpeed
	$badGuyPath/badGuyPathFollow/badGuyBody/bgGunAnimatedSprite.look_at(get_node("..").playerNode.global_position)
	$badGuyPath/badGuyPathFollow.unit_offset = badGuyPathPerc
	shadowBadGuySprite.global_position.x = $badGuyPath/badGuyPathFollow/badGuyBody/AnimatedSprite.global_position.x + 7
	shadowBadGuySprite.global_position.y = $badGuyPath/badGuyPathFollow/badGuyBody/AnimatedSprite.global_position.y + 7
