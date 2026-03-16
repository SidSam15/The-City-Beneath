extends StaticBody2D

@onready var trigger = $FallTrigger

func break_roof():
	queue_free()

	# remove collision so player falls through
	$CollisionShape2D.disabled = true

	# enable fall trigger
	trigger.monitoring = true

	# hide the roof
	$Sprite2D.visible = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_fall_trigger_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
