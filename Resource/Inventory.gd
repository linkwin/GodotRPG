extends Resource

signal items_changed(indexes)

class_name item

onready var item_set = AllItems.data


var cols = 9
var rows = 3
var slots = cols * rows
var items = []

func _ready():
	for i in range(slots):
		items.append({})

func set_item(index, item):
	var previous_item = items[index]
	items[index] = item
	emit_signal("items_changed", [index])
	return previous_item

func remove_item(index):
	var previous_item = items[index].duplicate()
	items[index].clear()
	emit_signal("items_changed", [index])
	return previous_item

func set_item_quantity(index, amount):
	items[index].quantity += amount
	if items[index].quantity <= 0:
		remove_item(index)
	else:
		emit_signal("items_changed", [index])
		
func on_save():
	pass
