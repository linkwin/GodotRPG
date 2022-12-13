extends Button

signal save_slot_selected(save_game_name)

func _on_SaveSlot_button_down():
	emit_signal("save_slot_selected", $SaveSlotInfo/SaveInfoContainer/SaveName.text)
