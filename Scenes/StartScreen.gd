extends CanvasLayer

const next_scene = preload("res://Scenes/StartScreen.tscn")

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_parent().add_child(next_scene.instance())
		queue_free()
