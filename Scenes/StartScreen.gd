extends CanvasLayer

onready var first_scene = preload("res://Levels/Level1.gd")

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_parent().add_child(first_scene.instance())
		queue_free()
