extends Node2D

var numDots = 0
var controlDotsArray = []
var controlDotMode = "start"
var dotOn = 0
var dotAction = "off"
var controlDotDict = {}
var controlDotActionColors = {
	"off": Color8(0,0,255),
	"moveLeft": Color8(255,0,0),
	"moveRight": Color8(0,255,0),
}

# Called when the node enters the scene tree for the first time.
func _ready():
	$controlDotTemplate.visible = false
	controlDotDict = getControlDotDict()

# Circle of dots that control the navigation of the main character sprite
func initDots(inNumDots):
	numDots = inNumDots
	for dotOn in numDots:
		controlDotsArray.push_back($controlDotTemplate.duplicate())
		controlDotsArray[dotOn].visible = true
		add_child(controlDotsArray[dotOn])
		var rotateInc = 360/numDots
		var rotateTo = rotateInc * dotOn
		controlDotsArray[dotOn].rotation_degrees = rotateTo
		setDotColor(dotOn,false)

# Set the color of a dot in the navigation circle
func setDotColor(inDotNum,isSelected):
	var setToColor = controlDotActionColors[ controlDotDict[controlDotMode][inDotNum] ]
	if (isSelected):
		setToColor = Color8(255,0,0)
	controlDotsArray[inDotNum].get_node("offsetADot").get_node("aDot").color = setToColor

# Called on a timer from the main scene to advance the dots circle
func nextDot():
	setDotColor(dotOn,false)
	dotOn = dotOn + 1
	if (dotOn >= numDots):
		dotOn = 0
	dotAction = controlDotDict[controlDotMode][dotOn]
	setDotColor(dotOn,true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Dictionary of player control dots for each mode
func getControlDotDict():
	var toReturn = {
		"start": {
			0: "off", 1: "moveRight", 2: "moveRight", 3: "moveRight", 4: "moveRight", 5: "moveRight", 6: "moveRight", 7: "moveRight", 8: "moveRight", 9: "moveRight",
			10: "off", 11: "moveLeft", 12: "moveLeft", 13: "moveLeft", 14: "moveLeft", 15: "moveLeft", 16: "moveLeft", 17: "moveLeft", 18: "moveLeft", 19: "moveLeft",
		}
	}
	return toReturn
