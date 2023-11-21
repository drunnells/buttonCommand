extends Node2D

var dotsTimer = Timer.new()

func _ready():
	$controlDots.initDots(20)
	startDotsTimer(0.5)

func startDotsTimer(timerSecs):
	add_child(dotsTimer)
	dotsTimer.connect("timeout", self, "_on_Timer_timeout")
	dotsTimer.set_wait_time(timerSecs)
	dotsTimer.set_one_shot(false) # Make sure it loops
	dotsTimer.start()

func _on_Timer_timeout():
	print("Next Dot")
	$controlDots.nextDot()

func _input(ev):
	if Input.is_key_pressed(KEY_SPACE):
		print("SPACE")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
