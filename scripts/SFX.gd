extends Node

## Pool sederhana AudioStreamPlayer supaya beberapa SFX bisa tumpang tindih
## tanpa saling memotong satu sama lain.

const POOL_SIZE = 8

var sounds := {
	"jump": preload("res://assets/sounds/sfx_jump.ogg"),
	"jump_high": preload("res://assets/sounds/sfx_jump-high.ogg"),
	"coin": preload("res://assets/sounds/sfx_coin.ogg"),
	"hurt": preload("res://assets/sounds/sfx_hurt.ogg"),
	"gem": preload("res://assets/sounds/sfx_gem.ogg"),
	"magic": preload("res://assets/sounds/sfx_magic.ogg"),
	"select": preload("res://assets/sounds/sfx_select.ogg"),
	"bump": preload("res://assets/sounds/sfx_bump.ogg"),
	"disappear": preload("res://assets/sounds/sfx_disappear.ogg"),
	"throw": preload("res://assets/sounds/sfx_throw.ogg"),
}

var players: Array[AudioStreamPlayer] = []

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	for i in POOL_SIZE:
		var p := AudioStreamPlayer.new()
		add_child(p)
		players.append(p)

func play(sound_name: String) -> void:
	if not sounds.has(sound_name):
		push_warning("SFX tidak dikenal: " + sound_name)
		return
	for p in players:
		if not p.playing:
			p.stream = sounds[sound_name]
			p.play()
			return
	# semua player sedang sibuk, timpa yang pertama
	players[0].stream = sounds[sound_name]
	players[0].play()
