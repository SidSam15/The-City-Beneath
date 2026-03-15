extends Node

var gems = 0

func collect_gem():
	gems += 1

	if gems >= 5:
		pass
var lives = 3

func lose_life():

	lives -= 1

	if lives <= 0:
		pass


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
