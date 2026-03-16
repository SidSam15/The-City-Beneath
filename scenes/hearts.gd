extends HBoxContainer

var player

@onready var hearts = [
	$Heart1,
	$Heart2,
	$Heart3
]

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _process(_delta):

	if player == null:
		return

	for i in range(hearts.size()):
		if i < player.health:
			hearts[i].visible = true
		else:
			hearts[i].visible = false
