func load_json(path):
	# Returns a dict from a JSON file on your file system.
	# Args:
	#   - path : string --> the path of the JSON file.
	var file = File.new()
	file.open(path, file.READ)
	
	var tmp_text = file.get_as_text()
	file.close()
	
	var data = parse_json(tmp_text)
	
	return data

func write_json(path, data):
	# Write a GDSCript dictionary to a JSON file on your file system.
	# Args:
	#   - path : string --> the path of the JSON file.
	#   - dict: dict --> your dictionnary
	var file = File.new()
	file.open(path, file.WRITE)
	
	file.store_string(data)
	file.close()
