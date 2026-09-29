extends Control

func _on_start_button_pressed() -> void:
	SFX.play("select")
	GameManager.start_new_game()

func _on_continue_button_pressed() -> void:
	# TODO: belum ada sistem save/load, sementara sama seperti mulai baru
	SFX.play("select")
	GameManager.start_new_game()

func _on_settings_button_pressed() -> void:
	# TODO: menu pengaturan belum dibuat
	SFX.play("select")

func _on_quit_button_pressed() -> void:
	SFX.play("select")
	get_tree().quit()
