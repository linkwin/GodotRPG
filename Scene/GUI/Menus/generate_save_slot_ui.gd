extends VBoxContainer


func _ready():
	update_save_slots()

func update_save_slots():
	for node in get_children():
		node.queue_free()
	var save_file_names = FuncLib.get_files_in_dir("res://Resource/WorldSaves/")
	for file in save_file_names:
		# instance save slot ui element
		var save_slot = load("res://Scene/GUI/Menus/SaveSlot.tscn").instance()
		var world_save = load("res://Resource/WorldSaves/" + file)
		
		var image = Image.new()
		var preview_path = world_save.save_slot_preview_path
#		var stream_texture = load(preview_path)
#		image = stream_texture.get_data()
		image.load(preview_path)
		
		var texture = ImageTexture.new()
		texture.create_from_image(image)
		
		save_slot.get_node("SaveSlotInfo/ScenePreview").texture = texture
		
		# set label to name of save file		
		save_slot.get_node("SaveSlotInfo/SaveInfoContainer/SaveName").text = file.get_slice(".", 0)
		save_slot.connect("save_slot_selected", FuncLib.world.get_node("UI"), "_on_save_slot_selected")
		add_child(save_slot)
		
	# Add new game save slot
	var save_slot = load("res://Scene/GUI/Menus/SaveSlot.tscn").instance()
	save_slot.get_node("SaveSlotInfo/ScenePreview").texture = null
	save_slot.get_node("SaveSlotInfo/SaveInfoContainer/SaveName").text = "NEW SAVE GAME"
	var date_time = OS.get_datetime()
	save_slot.get_node("SaveSlotInfo/SaveInfoContainer/SaveDate").text = str(date_time["month"]) + "/" + str(date_time["day"]) + " " + str(date_time["hour"]) + ":" + str(date_time["minute"])
	add_child(save_slot)
