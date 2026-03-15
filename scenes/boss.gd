extends CharacterBody2D

@export var health = 5
@export var speed = 100

func _physics_process(delta):

	var player = get_tree().get_first_node_in_group("player")

	if player:
		var direction = sign(player.global_position.x - global_position.x)
		velocity.x = direction * speed

	move_and_slide()

func take_damage(amount):

	health -= amount

	if health <= 0:
		die()

func die():
	drop_gem()
	queue_free()

@export var gem_scene : PackedScene

func drop_gem():

	var gem = gem_scene.instantiate()
	get_parent().add_child(gem)
	gem.global_position = global_position
