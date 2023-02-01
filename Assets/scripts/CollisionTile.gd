"""
The CollisionTile script contains a few functions helpful for determining what tile the player is on. 
For example, if the player is on a grass tile, they should be able to plant something.
"""

extends TileMap

class_name CollisionTile

#Key is the tile id, value is the tile name
const tile_dict := {
	-1: "invalid",
	0: "grass",
	2: "metal",
	3: "lava",
}

const tile_damage_dict := {
	-1: 0,
	0: 0,
	2: 0,
	3: 100,
}

#returns the name of a tile at a given position
func get_tile_name(pos : Vector2) -> String:
	return tile_dict[get_tile_id(pos)]

#Returns id of a tile at a given position
#Returns -1 if no known block is present
func get_tile_id(pos : Vector2) -> int:
	var pos_x = pos.x
	pos = world_to_map(pos)

	#In the event that we are given a coordinate exactly between two blocks,
	#we must decide between the left or right space. This defaults to the left space
	#if there is a block present there. If both spaces are vacant, the id will be -1.
	if fmod(pos_x, 16.0) == 0:
		if get_cellv(Vector2(pos.x-1, pos.y)) != -1:
			return get_cellv(Vector2(pos.x-1, pos.y))
		else:
			return get_cellv(Vector2(pos.x, pos.y))
	return get_cellv(pos)