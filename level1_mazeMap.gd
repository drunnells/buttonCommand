extends Node2D

var badGuyPathPerc = 0.0
var badGuySpeed = 0.02
var shadowBadGuySprite = null
var gunNode = null
var badGuySprite = null
var itemsMax = 50
var itemsCount = 0
var itemsTrackerArray = {}

func _ready():
	randomize()
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

func dropItems(dropMax):
	for onItem in range(dropMax):
		var randType = ""
		var randTypeId = randi() % 4
		match(randTypeId):
			0:
				randType = "bullets"
			1:
				randType = "faster"
			2:
				randType = "health"
			3:
				randType = "slower"
		var randX = (randi() % int(get_node("..").levelLimit.x * 2)) - get_node("..").levelLimit.x
		var randY = (randi() % int(get_node("..").levelLimit.y * 2)) - get_node("..").levelLimit.y
		print("ADD ITEM AT: " + String(randX) + "," + String(randY))
		addItem(randType,Vector2(randX,randY))

func addItem(itemType,itemLocation):
	print("ADDING ITEM")
	itemsTrackerArray[itemsCount] = itemType
	itemsCount = itemsCount +1
	var newItem = $itemArea.duplicate()
	add_child(newItem)
	newItem.visible = true
	newItem.get_node("itemIcon").play(itemType)
	newItem.get_node("AnimatedSprite").play("glow")
	newItem.global_position = itemLocation
	newItem.connect("body_entered", self, "_on_item_touch", [newItem,itemsCount,itemType])

func _on_item_touch(body,itemNode,itemId,itemType):
	if is_instance_valid(itemNode):
		print("TOUCHED!: " + String(itemId) + " (" + itemType + ")")
		itemNode.queue_free()
		dropItems(1)
