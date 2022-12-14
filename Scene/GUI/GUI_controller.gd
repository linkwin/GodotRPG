extends CanvasLayer

var is_paused = false

var save_name_selected = "WorldSaveState"

func _input(event):
	if (event.is_action_pressed("pause")):
		do_pause()

func do_pause():
	if is_paused:
		FuncLib.show_one_child(self, $GUI)
	else:
		FuncLib.show_one_child(self, $PauseMenu)
	is_paused = !is_paused

func _on_SaveButton_button_up():
	do_pause()
	FuncLib.save_world()
	get_node("PauseMenu/HBoxContainer/Panel/SaveSlotPanel/SaveSlotContainer").update_save_slots()

func _on_LoadButton_button_up():
	FuncLib.load_world(save_name_selected)

func _on_QuitButton_button_up():
	get_tree().quit()
	
func _on_save_slot_selected(save_name):
	save_name_selected = save_name
