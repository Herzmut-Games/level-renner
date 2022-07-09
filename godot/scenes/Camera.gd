extends Camera2D

export var player_path: NodePath
export var follow_player: bool = true

onready var player = get_node(player_path)

func _process(_delta):
	if follow_player:
		position.x = player.position.x
