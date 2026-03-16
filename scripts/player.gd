extends CharacterBody2D

@export var speed = 100
@export var jump_velocity = -200
@export var gravity = 980
@export var max_jumps = 2
@export var break_force = 750
@export var max_health = 3

@onready var anim = $AnimatedSprite2D

var health
var jumps_left
var breaking_down = false
var facing_direction = 1
var can_take_damage = true
var damage_cooldown = 0.5


func _ready():
	health = max_health
	jumps_left = max_jumps


func _physics_process(delta):

	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta

		if breaking_down:
			anim.play("smash")
		elif velocity.y < 0 and anim.animation != "attack":
			anim.play("jump")

			
	else:
		jumps_left = max_jumps
	
		if breaking_down:
			anim.play("idle")
	
	breaking_down = false

	if velocity.x == 0 and anim.animation != "attack" and anim.animation != "smash":
		anim.play("idle")

	# Movement
	var direction = Input.get_axis("move_left", "move_right")
	velocity.x = direction * speed

	if direction != 0:
		facing_direction = direction
		anim.flip_h = facing_direction < 0

		if is_on_floor() and anim.animation != "attack" and anim.animation != "smash":
			anim.play("run")

	# Jump + Double Jump
	if Input.is_action_just_pressed("jump") and jumps_left > 0:
		velocity.y = jump_velocity
		jumps_left -= 1
		anim.play("jump")

	# Downward Smash
	if Input.is_action_just_pressed("break_down") and not is_on_floor():
		velocity.y = break_force
		breaking_down = true


	move_and_slide()


func _input(event):

	if Input.is_action_just_pressed("attack") and anim.animation != "attack":

		anim.play("attack")

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
	velocity.y = -200

	if facing_direction == 1:
		velocity.x = -200
	else:
		velocity.x = 200

	if health <= 0:
		die()
		return

	var timer = get_tree().create_timer(damage_cooldown)
	await timer.timeout

	can_take_damage = true


func die():
	call_deferred("_reload_scene")


func _reload_scene():
	get_tree().reload_current_scene()


func _on_animated_sprite_2d_animation_finished():

	if anim.animation == "attack":
		anim.play("idle")

	if anim.animation == "smash" and is_on_floor():
		anim.play("idle")
