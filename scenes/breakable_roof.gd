extends StaticBody2D

@export var house_scene : PackedScene

func break_roof():
	queue_free()

	# teleport to house scene
	get_tree().change_scene_to_packed(house_scene)
	
