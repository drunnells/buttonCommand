extends Node2D

var itemsMax = 50
var itemsCount = 0
var itemsTrackerArray = []

func dropItems(dropMax):
	for onItem in range(dropMax):
		addItem("bullets",Vector2(-800,120))

func addItem(itemType,itemLocation):
	itemsTrackerArray[itemsCount] = itemType
	itemsCount = itemsCount +1
	var newItem = $itemArea.duplicate()
	newItem.global_position = itemLocation
	newItem.visible = true
#func load():
#  var file = FileAccess.open("user://save_game.dat", FileAccess.READ)
#  var content = file.get_as_text()
#  return content
