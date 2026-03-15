extends CharacterBody2D

@export var speed = 100
@export var jump_velocity = -200
@export var gravity = 980
@export var max_jumps = 2
@export var break_force = 750
@export var max_health = 3


var health
var jumps_left
var breaking_down = false
var facing_direction = 1

var can_take_damage = true
var damage_cooldown = 1.0


func _ready():
	health = max_health
	jumps_left = max_jumps


func _physics_process(delta):

	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		jumps_left = max_jumps
		breaking_down = false

	# Movement
	var direction = Input.get_axis("move_left", "move_right")
	velocity.x = direction * speed

	if direction != 0:
		facing_direction = direction
		$AnimatedSprite2D.flip_h = facing_direction < 0

	# Jump + Double Jump
	if Input.is_action_just_pressed("jump") and jumps_left > 0:
		velocity.y = jump_velocity
		jumps_left -= 1

	# Downward smash
	if Input.is_action_just_pressed("break_down") and not is_on_floor():
		velocity.y = break_force
		breaking_down = true

	move_and_slide()


func _input(event):

	if Input.is_action_just_pressed("attack"):

		if facing_direction == 1:
			$AttackArea.position.x = 20
		else:
			$AttackArea.position.x = -20

		$AttackArea.monitoring = true
		await get_tree().create_timer(0.2).timeout
		$AttackArea.monitoring = false


func _on_roof_detector_body_entered(body):

	if breaking_down and body.is_in_group("breakable_roof"):
		body.break_roof()


func take_damage(amount):

	if !can_take_damage:
		return

	health -= amount
	can_take_damage = false

	# knockback
	velocity.y = -250

	if facing_direction == 1:
		velocity.x = -200
	else:
		velocity.x = 200

	if health <= 0:
		die()
		return   # IMPORTANT: stops the timer from running

	var timer = get_tree().create_timer(damage_cooldown)
	await timer.timeout

	can_take_damage = true

func die():
	call_deferred("_reload_scene")

func _reload_scene():
	get_tree().reload_current_scene()
