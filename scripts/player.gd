extends CharacterBody2D

@export var speed = 100
@export var jump_velocity = -250
@export var gravity = 980
@export var max_jumps = 2
@export var break_force = 750
@export var max_health = 3

var jumps_left = max_jumps
var breaking_down = false
var facing_direction = 1


func _physics_process(delta):

	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		jumps_left = max_jumps
		breaking_down = false


	# Horizontal movement
	var direction = Input.get_axis("move_left", "move_right")
	velocity.x = direction * speed


	# Jump + Double Jump
	if Input.is_action_just_pressed("jump") and jumps_left > 0:
		velocity.y = jump_velocity
		jumps_left -= 1


	# Downward roof break attack
	if Input.is_action_just_pressed("break_down") and not is_on_floor():
		velocity.y = break_force
		breaking_down = true

	if direction != 0:
		facing_direction = direction


	move_and_slide()
	
func _on_body_entered(body):

	if breaking_down and body.is_in_group("breakable_roof"):
		body.break_roof()


func _on_roof_detector_body_entered(body: Node2D) -> void:
	if breaking_down and body.is_in_group("breakable_roof"):
		body.break_roof() # Replace with function body.

func _input(event):
	if Input.is_action_just_pressed("attack"):
		$AttackArea.monitoring = true
		await get_tree().create_timer(0.2).timeout
		$AttackArea.monitoring = false

func die():
	get_tree().reload_current_scene()

var health = 3

func take_damage(amount):

	health -= amount

	if health <= 0:
		die()

func _input1(event):

	if Input.is_action_just_pressed("attack"):

		if facing_direction == 1:
			$AttackArea.position.x = 20
		else:
			$AttackArea.position.x = -20

		$AttackArea.monitoring = true

		await get_tree().create_timer(0.2).timeout

		$AttackArea.monitoring = false

		$Sprite2D.flip_h = facing_direction < 0
