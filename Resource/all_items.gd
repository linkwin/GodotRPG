
extends Node

var data ={}
var names = []
var path = "res://db/items.json"
func _ready():
	var jsonfile = File.new()
	jsonfile.open(path, File.READ)
	data = parse_json(jsonfile.get_as_text())  
	
	for key in data.keys():
		data[key]["key"] = key
		data[key].icon = "res://Assets/ItemIcons/"+data[key].icon
		
	for i in data:
		names.append(data[i]["name"])
		
