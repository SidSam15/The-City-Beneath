extends CharacterBody2D

@export var health = 5
@export var speed = 100
@export var gravity = 980
@export var gem_scene : PackedScene

func _physics_process(delta):

	if !is_on_floor():
		velocity.y += gravity * delta

	var player = get_tree().get_first_node_in_group("player")

	if player:

		var distance = player.global_position.x - global_position.x

		if abs(distance) > 40:
			velocity.x = sign(distance) * speed
		else:
			velocity.x = 0

		$AnimatedSprite2D.flip_h = distance < 0

	move_and_slide()


func take_damage(amount):

	health -= amount

	if health <= 0:
		die()


func die():

	drop_gem()
	queue_free()


func drop_gem():

	var gem = gem_scene.instantiate()
	get_parent().add_child(gem)
	gem.global_position = global_position
