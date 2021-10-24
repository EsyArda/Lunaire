extends KinematicBody2D


export var move_speed := 50
export var gravity := 1000
export var jump_speed := 250

export var max_health := 20
var health = max_health

var attack_cooldown_time = 500
var next_attack_time = 0
var attack_damage = 5
var attack_playing = false

var velocity := Vector2.ZERO

signal player_stats_changed

# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("player_stats_changed", self)


func _physics_process(delta):
	velocity.x = 0
	
	if Input.is_action_pressed("move_right"):
		velocity.x += move_speed
	if Input.is_action_pressed("move_left"):
		velocity.x -= move_speed
	
	velocity.y += gravity*delta
	
	if Input.is_action_pressed("jump"):
		if is_on_floor():
			velocity.y = -jump_speed
	
	if velocity.x > 0:
		$RayCast2D.cast_to = Vector2.RIGHT
	elif velocity.x < 0:
		$RayCast2D.cast_to = Vector2.LEFT
	
	velocity = move_and_slide(velocity, Vector2.UP)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	change_animation()

func change_animation():
	if $AnimatedSprite.animation == "attack" && $AnimatedSprite.frame == $AnimatedSprite.frames.get_frame_count("attack"):
		attack_playing = false
	# face left or right
	if velocity.x > 0:
		$AnimatedSprite.flip_h = false
	elif velocity.x < 0:
		$AnimatedSprite.flip_h = true
	if velocity.y < 0 and not attack_playing: # negative Y is up
		$AnimatedSprite.play("jump")
	else:
		if velocity.x != 0 and not attack_playing:
			$AnimatedSprite.play("run")
		elif not attack_playing:
			$AnimatedSprite.play("idle")

func _input(event):
	if event.is_action_pressed("attack"):
		# Check if player can attack
		var now = OS.get_ticks_msec()
		if now >= next_attack_time:
			# What's the target ?
			$AnimatedSprite.play("attack")
			var target = $RayCast2D.get_collider()
			if target != null:
				# if target.name.find("monster") >= 0:
				target.hit(attack_damage)
			attack_playing = true
			# Add cooldown time to current time
			next_attack_time = now + attack_cooldown_time

func _on_Sprite_animation_finished():
	attack_playing = false
