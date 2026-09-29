extends CanvasLayer

## Baris dialog
@export var lines: Array[String] = []
## Nama pembicara tiap baris, sejajar index dengan "lines".
## Isi "Naya" atau "Haris". Kosongkan ("") untuk narasi (tidak ada yang disorot).
@export var speakers: Array[String] = []
@export var next_scene_path: String = ""
@export var typewriter_speed: float = 0.03

@onready var label: Label = $DialogBox/Label
@onready var name_label: Label = $DialogBox/NameLabel
@onready var type_timer: Timer = $TypeTimer
@onready var char_naya: TextureRect = $CharacterNaya
@onready var char_haris: TextureRect = $CharacterHaris

var index := 0
var target_text := ""
var char_index := 0
var is_typing := false

const HARIS_GATE_POS := Vector2(605, 460)

var haris_target_pos: Vector2

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = false
	haris_target_pos = char_haris.position
	char_haris.position = HARIS_GATE_POS
	char_haris.scale = Vector2(0.55, 0.55)
	show_line()
	_play_haris_entrance()

func _play_haris_entrance() -> void:
	var tw := create_tween()
	tw.set_parallel(true)
	tw.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tw.tween_property(char_haris, "position", haris_target_pos, 1.4)
	tw.tween_property(char_haris, "scale", Vector2(1, 1), 1.4)

func show_line() -> void:
	target_text = lines[index]
	char_index = 0
	label.text = ""
	is_typing = true
	type_timer.start(typewriter_speed)

	var speaker := ""
	if index < speakers.size():
		speaker = speakers[index]
	name_label.text = "Pangeran Haris" if speaker == "Haris" else speaker

	if speaker == "Naya":
		char_naya.modulate = Color(1, 1, 1, 1)
		char_haris.modulate = Color(0.45, 0.45, 0.5, 1)
	elif speaker == "Haris":
		char_haris.modulate = Color(1, 1, 1, 1)
		char_naya.modulate = Color(0.45, 0.45, 0.5, 1)
	else:
		char_naya.modulate = Color(0.7, 0.7, 0.72, 1)
		char_haris.modulate = Color(0.7, 0.7, 0.72, 1)

func _on_type_timer_timeout() -> void:
	if char_index < target_text.length():
		label.text += target_text[char_index]
		char_index += 1
	else:
		is_typing = false
		type_timer.stop()

func _unhandled_input(event: InputEvent) -> void:
	var tapped: bool = event is InputEventScreenTouch and event.is_pressed()
	if event.is_action_pressed("ui_accept") or tapped:
		if is_typing:
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
