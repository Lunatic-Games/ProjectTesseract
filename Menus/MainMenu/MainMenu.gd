extends Control

func _ready():
	_load_last_username()

# attempt to load last-used username
func _load_last_username() -> void:
	var save_file = File.new()
	if not save_file.file_exists("user://last_username.save"):
		return
	
	save_file.open("user://last_username.save", File.READ)
	var line = parse_json(save_file.get_line())
	$Panel/MarginContainer/VerticalBoxes/Username/Field.text = line["username"]
	save_file.close()

# login
func _on_ConnectButton_pressed():
	if $Panel/MarginContainer/VerticalBoxes/Username/Field.text == "":
		return
	_save_last_username()
	UserSettings.user_name = $Panel/MarginContainer/VerticalBoxes/Username/Field.text
	
	# warning-ignore:return_value_discarded
	get_tree().change_scene('res://Menus/LobbySearch/LobbySearch.tscn')

# save last used username
func _save_last_username():
	var save_data = {
		"username" : $Panel/MarginContainer/VerticalBoxes/Username/Field.text,
	}
	var save_file = File.new()
	save_file.open("user://last_username.save", File.WRITE)
	save_file.store_line(to_json(save_data))
	save_file.close()
	
