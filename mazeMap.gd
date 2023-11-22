extends Node2D

var mapSize = scale
var mapGridSize = Vector2(80,80)
var mapCellSize = Vector2( mapSize.x/mapGridSize.x, mapSize.y/mapGridSize.y )

func _ready():
	addWallSprite(48,40,Color8(200,100,200))
	addWallSprite(49,40,Color8(100,200,200))
	addWallSprite(49,41,Color8(0,200,200))
	print(String(mapCellSize))

func addWallSprite(inX,inY,color):
	var newWallSprite = $wallSprite.duplicate()
	newWallSprite.modulate = color
	newWallSprite.position = Vector2(inX/mapGridSize.x,inY/mapGridSize.y)
	add_child(newWallSprite)

#func load():
#  var file = FileAccess.open("user://save_game.dat", FileAccess.READ)
#  var content = file.get_as_text()
#  return content
