extends MarginContainer

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().root.get_node("Root/Player")

func _on_player_stats_changed(var player):
	$HBoxContainer/VBoxContainer/Health/HealthBar.value = player.health / player.max_health * 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
