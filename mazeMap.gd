extends Node2D

var mapSize = scale
var mapGridSize = Vector2(80,80)
var mapCellSize = Vector2( mapSize.x/mapGridSize.x, mapSize.y/mapGridSize.y )

func _ready():
	addWallSprite(40,40,Color8(200,100,200))
	addWallSprite(41,40,Color8(100,200,200))
	addWallSprite(41,41,Color8(0,200,200))
	print(String(mapCellSize))

func addWallSprite(inX,inY,color):
	var newWallSprite = $wallSprite.duplicate()
	newWallSprite.modulate = color
	#newWallSprite.scale = mapCellSize
	newWallSprite.position = Vector2(inX/mapGridSize.x,inY/mapGridSize.y)
	add_child(newWallSprite)
#	$wallSprite.position = Vector2(0.5,0.5)

#func load():
#  var file = FileAccess.open("user://save_game.dat", FileAccess.READ)
#  var content = file.get_as_text()
#  return content
