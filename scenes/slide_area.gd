extends Area2D

func _physics_process(_delta):

	for body in get_overlapping_bodies():

		print("touching:", body.name)
