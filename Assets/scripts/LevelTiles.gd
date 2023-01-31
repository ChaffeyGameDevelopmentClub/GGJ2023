"""
The LevelTiles script contains a few functions helpful for determining what tile the player is on. 
For example, if the player is on a grass tile, they should be able to plant something.
"""

extends TileMap

const tile_dict := {
	0: "grass",
	2: "metal"
}

#returns id of a tile at a given position
func get_tile_id(pos : Vector2) -> int:
	pos = world_to_map(pos)
	return get_cellv(pos)

#returns the name of a tile at a given position
func get_tile_name(pos : Vector2) -> String:
	pos = world_to_map(pos)
	return tile_dict[get_cellv(pos)]
