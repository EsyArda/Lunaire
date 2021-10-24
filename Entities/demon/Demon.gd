extends KinematicBody2D

const ShowHitZone = true

const S_ATTACK = 1
const S_IDLE = 0


var velocity = Vector2()
var floatTimer = 0.0
const floatRad = 20
var state = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Attack.visible = false
	$Idle.visible = true
	$AttackZone.disabled = true
	$Body.disabled = false
	$Body/Area.visible = ShowHitZone
	$AttackZone/Area.visible = false
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	floatTimer += delta * 2
	var floating = Vector2(cos(floatTimer) * floatRad, sin(floatTimer) * floatRad)
	if (floatTimer >= 6.2830):
		floatTimer = 0
	get_parent().position += (velocity + floating) / 100


	if state == S_ATTACK and $Attack.frame == 7:
		SetAttackHitBox()
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += delta * 10
	
	if Input.is_action_pressed("ui_left"):
		velocity.x -= delta * 10
		
	if velocity.x < -0.1:
		get_owner().scale = Vector2(1, 1)
		
	if velocity.x > 0.1:
		get_owner().scale = Vector2(-1, 1)			
		
	if Input.is_action_just_pressed("ui_accept"):
		Attack()
		
func Attack():
	state = S_ATTACK
	SetAnimAttack()
	
func SetAttackHitBox():
	$AttackZone.disabled = false
	$AttackZone/Area.visible = ShowHitZone

func SetAnimAttack():
	$Attack.visible = true
	$Idle.visible = false
	$Attack.frame = 0
	
func SetAnimIdle():
	$Attack.visible = false
	$Idle.visible = true
	$Idle.frame = 0


func _on_TimeAttack_timeout():
	Attack()
	$TimeAttack.wait_time = rand_range(3, 8)
	

func _on_Attack_animation_finished():
	SetAnimIdle()
	state = S_IDLE
	$AttackZone.disabled = true
	$AttackZone/Area.visible = false

