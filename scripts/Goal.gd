extends Area2D

## Kosongkan ("") kalau ini level terakhir (akan memicu layar menang)
@export var next_level_path: String = ""

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		SFX.play("gem")
		GameManager.complete_level(next_level_path)
