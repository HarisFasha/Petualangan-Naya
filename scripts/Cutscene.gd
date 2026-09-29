extends CanvasLayer

## Baris-baris dialog yang muncul satu per satu
@export var lines: Array[String] = ["..."]
## Scene berikutnya setelah cutscene selesai. Kosongkan ("") untuk memicu layar menang.
@export var next_scene_path: String = ""
## Kecepatan ketik, detik per huruf
@export var typewriter_speed: float = 0.03

@onready var label: Label = $DialogBox/Label
@onready var type_timer: Timer = $TypeTimer

var index := 0
var target_text := ""
var displayed_text := ""
var char_index := 0
var is_typing := false

func _ready() -> void:
	get_tree().paused = false
	show_line()

func show_line() -> void:
	target_text = lines[index]
	displayed_text = ""
	char_index = 0
	label.text = ""
	is_typing = true
	type_timer.start(typewriter_speed)

func _on_type_timer_timeout() -> void:
	if char_index < target_text.length():
		displayed_text += target_text[char_index]
		label.text = displayed_text
		char_index += 1
	else:
		is_typing = false
		type_timer.stop()

func _unhandled_input(event: InputEvent) -> void:
	var tapped: bool = event is InputEventScreenTouch and event.is_pressed()
	if event.is_action_pressed("ui_accept") or tapped:
		if is_typing:
			# Tombol ditekan saat teks masih mengetik -> langsung tampilkan penuh
			is_typing = false
			type_timer.stop()
			label.text = target_text
		else:
			advance()
	elif event.is_action_pressed("ui_cancel"):
		GameManager.reset_game()

func advance() -> void:
	SFX.play("select")
	index += 1
	if index >= lines.size():
		finish()
	else:
		show_line()

func finish() -> void:
	if next_scene_path == "":
		GameManager.win_game()
	else:
		get_tree().call_deferred("change_scene_to_file", next_scene_path)
