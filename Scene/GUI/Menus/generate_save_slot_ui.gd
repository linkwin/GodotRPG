extends VBoxContainer


func _ready():
	update_save_slots()

func update_save_slots():
	# Delete children
	for node in get_children():
		node.queue_free()
	
	# iterate through save files
	var save_file_names = FuncLib.get_files_in_dir("res://Resource/WorldSaves/")
	for file in save_file_names:
		# instance save slot ui element
		var save_slot = load("res://Scene/GUI/Menus/SaveSlot.tscn").instance()
		var world_save = load("res://Resource/WorldSaves/" + file)
		
		# setup save slot preview image
		var image = Image.new()
		var preview_path = world_save.save_slot_preview_path
		image.load(preview_path)
		var texture = ImageTexture.new()
		texture.create_from_image(image)
		save_slot.get_node("SaveSlotInfo/ScenePreview").texture = texture
		
		# set label to name of save file		
		save_slot.get_node("SaveSlotInfo/SaveInfoContainer/SaveName").text = file.get_slice(".", 0)
		
		# set save time label
		var date_time = world_save.date_time
		if !date_time.empty():
			save_slot.get_node("SaveSlotInfo/SaveInfoContainer/SaveDate").text = \
				str(date_time["month"]) + "/" + str(date_time["day"]) + " " + str(date_time["hour"]) + ":" + str(date_time["minute"])
		
		# connect save slot button signal to UI controller function
		save_slot.connect("save_slot_selected", FuncLib.get_ui_canvas(), "_on_save_slot_selected")
		add_child(save_slot)
		
	# Add new game save slot
	var save_slot = load("res://Scene/GUI/Menus/SaveSlot.tscn").instance()
	save_slot.get_node("SaveSlotInfo/ScenePreview").texture = null
	save_slot.get_node("SaveSlotInfo/SaveInfoContainer/SaveName").text = "NEW SAVE GAME"
	var date_time = Time.get_datetime_dict_from_system()
	save_slot.get_node("SaveSlotInfo/SaveInfoContainer/SaveDate").text = str(date_time["month"]) + "/" + str(date_time["day"]) + " " + str(date_time["hour"]) + ":" + str(date_time["minute"])
	save_slot.connect("save_slot_selected", FuncLib.get_ui_canvas(), "_on_save_slot_selected")
	add_child(save_slot)
