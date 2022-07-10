tool
extends TileMap

export var mirror = true

func set_cell(x: int, y: int, tile: int, flip_x: bool = false, flip_y: bool = false, transpose: bool = false, autotile_coord: Vector2 = Vector2()) -> void:
	.set_cell(x, y, tile, flip_x, flip_y, transpose, autotile_coord)
	.set_cell(x, (y + 1) * -1, tile, flip_x, true, transpose, autotile_coord)

	pass

