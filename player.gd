extends KinematicBody2D

const SPEED = 200
const FLOOR = Vector2(0, -1)
const GRAVITY = 970

var is_dead = false
var velocity = Vector2()

var treasures = 0

func add_treasure():
	treasures += 1

func die():
	$AnimatedSprite.play("die")
	$CollisionShape2D.set_deferred("disabled", true)
	is_dead = true

func _physics_process(delta):
	if is_dead:
		return
	if Input.is_action_pressed("ui_right"):
		velocity.x = SPEED
		$AnimatedSprite.flip_h = false
		$Position2D.position.x = abs($Position2D.position.x)
		if is_on_floor():
			$AnimatedSprite.play("run")
		else:
			$AnimatedSprite.play("fall")
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -SPEED
		$AnimatedSprite.flip_h = true
		$Position2D.position.x = abs($Position2D.position.x) * -1
		if is_on_floor():
			$AnimatedSprite.play("run")
		else:
			$AnimatedSprite.play("fall")
	else:
		velocity.x = 0
		if is_on_floor():
			$AnimatedSprite.play("idle")
		else:
			$AnimatedSprite.play("fall")

	if Input.is_action_just_pressed("ui_accept"):
		$AnimatedSprite.play("attack")

	velocity.y += (GRAVITY * delta)
	velocity = move_and_slide(velocity, FLOOR)
