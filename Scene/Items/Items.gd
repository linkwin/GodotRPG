extends Node2D



onready var current_items = AllItems.names
onready var current_item_data = AllItems.data
onready var itemname


func _ready():
	if itemname != null:
		if itemname in current_items:
			var address = current_item_data[itemname.to_lower()]["icon"]
			self.get_node("Item/Sprite").texture = load(address)
		else:
			print("ERROR: ITEM NOT FOUND IN JSON")

