extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var numDots = 0
var controlDotsArray = []
var controlDotPropertiesArray = []
var dotOn = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$controlDotTemplate.visible = false

func initDots(inNumDots):
	numDots = inNumDots
	for dotOn in numDots:
		controlDotsArray.push_back($controlDotTemplate.duplicate())
		controlDotPropertiesArray.push_back({
			"color" : Color8(0,255,0),
			"action" : "move"
		})
		controlDotsArray[dotOn].visible = true
		add_child(controlDotsArray[dotOn])
		var rotateInc = 360/numDots 
		var rotateTo = rotateInc * dotOn
		controlDotsArray[dotOn].rotation_degrees = rotateTo
		setDotColor(dotOn,false)

func setDotColor(inDotNum,isSelected):
	var setToColor = controlDotPropertiesArray[inDotNum]["color"]
	if (isSelected):
		setToColor = Color8(255,0,0)
	controlDotsArray[inDotNum].get_node("offsetADot").get_node("aDot").color = setToColor
	
func nextDot():
	setDotColor(dotOn,false)
	dotOn = dotOn + 1
	if (dotOn >= numDots):
		dotOn = 0
	setDotColor(dotOn,true)
	print("DOT ON: " + String(dotOn))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
