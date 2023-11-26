extends Node2D

func _ready():
	VisualServer.set_default_clear_color(Color(0.0,0.09,0.17,1.0))

func _input(_ev):
	if Input.is_key_pressed(KEY_SPACE):
		print("START")
		get_tree().change_scene("res://level1.tscn")
