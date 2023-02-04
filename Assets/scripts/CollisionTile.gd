"""
The CollisionTile script contains a few functions helpful for determining what tile the player is on. 
For example, if the player is on a grass tile, they should be able to plant something.
"""

extends TileMap

class_name CollisionTile

const tile_scale = 16.0 #pixels

#Key is the tile id, value is the tile name
const tile_dict := {
	-1: "invalid",
	0: "grass",
	2: "metal",
	3: "lava",
}

const plantable_dict := {
	-1: 0,
	0: 1,
	2: 0,
	3: 0,
	
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
	pos.y /= 2
	pos.x /= 2
	var pos_x = pos.x
	pos = world_to_map(pos)
	
	#In the event that we are given a coordinate exactly between two blocks,
	#we must decide between the left or right space. This defaults to the left space
	#if there is a block present there. If both spaces are vacant, the id will be -1.
	if fmod(pos_x, tile_scale) == 0:
		pos = Vector2(pos.x-1, pos.y) if get_cellv(Vector2(pos.x-1, pos.y)) != -1 else Vector2(pos.x, pos.y)

	Player.update_tile_snap(map_to_world(pos))

	return get_cellv(pos)
