extends Node

# Traverse the node tree and replace Tiled objects
func post_import(tileset):
	var tile_meta
	if tileset.has_meta("tile_meta"):
		tile_meta=tileset.get_meta("tile_meta")
		for i in tile_meta:
			
			print(tile_meta[i]['transparent'])
		# You must return the modified scene
	return tileset
