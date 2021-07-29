extends KinematicBody2D

const SPEED = 10
const FLOOR = Vector2(0, -1)
const GRAVITY = 970

var is_dead = false
var velocity = Vector2()

var treasures = 0
var on_ladder = false

var tile_size_x = 60
var tile_size_y = 44


func add_treasure():
	treasures += 1

func die():
	$AnimatedSprite.play("die")
	$CollisionShape2D.set_deferred("disabled", true)
	is_dead = true

func _physics_process(delta):
	var tilemap = get_parent().get_node("TileMap")
	if is_dead:
		return
	if not tilemap == null:
		var map_pos = tilemap.world_to_map(position)
		var id = tilemap.get_cellv(map_pos)
		if id > -1:
			print(tilemap.get_tileset().tile_get_name(id))
			if tilemap.get_tileset().tile_get_name(id) == "ladder":
				on_ladder = true
			else:
				on_ladder = false
			if tilemap.get_tileset().tile_get_name(id) == "water_top":
				die()
				return
		else:
			on_ladder = false
	if Input.is_action_pressed("ui_right"):
		velocity.x = SPEED * tile_size_x / 2 
		$AnimatedSprite.flip_h = false
		#$Position2D.position.x = abs($Position2D.position.x)
		if on_ladder:
			$AnimatedSprite.play("climb")
		elif is_on_floor():
			$AnimatedSprite.play("run")
		else:
			velocity.x = 0
			$AnimatedSprite.play("fall")
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -SPEED  * tile_size_x / 2
		$AnimatedSprite.flip_h = true
		#$Position2D.position.x = abs($Position2D.position.x) * -1
		if on_ladder:
			$AnimatedSprite.play("climb")
		elif is_on_floor():
			$AnimatedSprite.play("run")
		else:
			velocity.x = 0
			$AnimatedSprite.play("fall")
	elif Input.is_action_pressed("ui_up"):
		if on_ladder:
			velocity.y = -SPEED  * tile_size_y / 2
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.play("climb")
			#$Position2D.position.x = abs($Position2D.position.x) * -1
		elif is_on_floor():
			$AnimatedSprite.play("idle")
		else:
			$AnimatedSprite.play("fall")
	elif Input.is_action_pressed("ui_down"):
		if on_ladder:
			velocity.y = SPEED * tile_size_y / 2
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.play("climb")
			#$Position2D.position.x = abs($Position2D.position.x) * -1
		elif is_on_floor():
			$AnimatedSprite.play("idle")
		else:
			$AnimatedSprite.play("fall")
	else:
		velocity.x = 0
		if on_ladder:
			velocity.y = 0
		if is_on_floor():
			$AnimatedSprite.play("idle")
		else:
			$AnimatedSprite.play("fall")

	if Input.is_action_pressed("shoot_left"):
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.play("attack")
	elif Input.is_action_pressed("shoot_right"):
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("attack")

	if Input.is_action_pressed("test_die"):
		die()

	if not on_ladder:
		velocity.y += (GRAVITY * delta)
		velocity = move_and_slide(velocity, FLOOR)
	else:
		velocity = move_and_slide(velocity)
