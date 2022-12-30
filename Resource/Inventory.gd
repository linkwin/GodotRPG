extends Node2D

signal items_changed(indexes)
signal insufficient_items(indexes, difference)
signal inventory_full(indexes, difference)

onready var item_set = AllItems.data


var cols = 1
var rows = 1
var slots = cols * rows
var items = {}
var full_items = []
var max_items_per_spot = 4
var item_total_data = {}		# item name : totalnumber in inventory dict

func _get_property_list():
	# But in game, Godot will see this
	return [
		{
			"name": "items",
			"usage": PROPERTY_USAGE_STORAGE,
			"type": TYPE_ARRAY,
		}
	]
func _ready():
	for i in range(slots):
		items[str(i)] = {null:null} 

func found_item(item_name, count):
	
	if count != 0:
		emit_signal("items_changed", item_name)
	
	var relev_item_slots = [] 		#has same name as item_name
	var current_item_names = [] 	#what item names are in grid?
	var empty_item_slots = [] 		#unused item slot locations
	
	for i in items:
		current_item_names += items[i].keys()
		for j in current_item_names:
			if j == null:
				current_item_names.erase(j)
		if item_name in items[i].keys():
			relev_item_slots.append(i)
		if items[i].keys() == [null]:
			empty_item_slots.append(i)
		
	var item_total = 0
	if not item_name in full_items:
		full_items.append(item_name)
	for i in relev_item_slots:
		item_total += items[i][item_name]
		if items[i][item_name] < max_items_per_spot:
			full_items.erase(item_name)
			break
	if len(empty_item_slots) > 0:
		full_items.erase(item_name)
	
	item_total_data[item_name] = item_total
	
	
	
	if (item_total + count >= 0) and ( count>0 and (not item_name in full_items)):
		if item_name in current_item_names:
			
			while count > 0:
				for i in relev_item_slots:
					var avail_item_in_slot = max_items_per_spot - items[i][item_name]
					if count > 0 and avail_item_in_slot >= count:
						items[i][item_name] += count
						count = 0
					if count > 0 and avail_item_in_slot < count:
						items[i][item_name] = max_items_per_spot
						count -= avail_item_in_slot
				break
			
			while count < 0:
				for i in relev_item_slots:
					var avail_item_in_slot = max_items_per_spot - items[i][item_name]
					if count < 0 and items[i][item_name] >= (-1*count):
						items[i][item_name] += count
						count = 0
					if count < 0 and items[i][item_name] < (-1*count):
						items[i][item_name] = 0
						count -= avail_item_in_slot
				break
		
		if count > 0 or (not item_name in current_item_names):
			print("NEW ITEM")
			while count > 0:
				for i in empty_item_slots:
					if count> 0 and count > max_items_per_spot:
						items[i] = {item_name : max_items_per_spot}
						count -= max_items_per_spot
					if count> 0 and count <= max_items_per_spot:
						items[i] = {item_name : count}
						count = 0
				break
	else:
		if count < 0:
			print("ERROR: INSUFICIENT ITEMS IN INVENTORY")
			emit_signal("insufficient_items", item_name, (-1)*count)
			
		if count > 0:
			print("ERROR: INSUFICIENT ROOM FOR ITEMS IN INVENTORY")
			emit_signal("inventory_full", item_name, count)
			
		
	for i in relev_item_slots:
		if items[i][item_name] == 0:
			items[i] = {null:null}

