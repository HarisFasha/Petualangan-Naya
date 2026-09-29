extends Node

signal score_changed(new_score: int)
signal lives_changed(new_lives: int)
signal game_won

const MAX_LIVES = 3

var score: int = 0
var lives: int = MAX_LIVES
var checkpoint_position: Vector2 = Vector2(150, 440)

func add_score(amount: int) -> void:
	score += amount
	score_changed.emit(score)

func lose_life() -> void:
	lives -= 1
	lives_changed.emit(lives)
	if lives <= 0:
		game_over()

func respawn_player(player: Node) -> void:
	player.global_position = checkpoint_position
	player.velocity = Vector2.ZERO

func set_checkpoint(pos: Vector2) -> void:
	checkpoint_position = pos

func game_over() -> void:
	print("Game Over!")
	get_tree().paused = true

func start_new_game() -> void:
	score = 0
	lives = MAX_LIVES
	score_changed.emit(score)
	lives_changed.emit(lives)
	checkpoint_position = Vector2(150, 440)
	get_tree().paused = false
	get_tree().call_deferred("change_scene_to_file", "res://scenes/CutsceneIntro.tscn")

func complete_level(next_level_path: String) -> void:
	if next_level_path == "":
		win_game()
	else:
		lives = MAX_LIVES
		lives_changed.emit(lives)
		checkpoint_position = Vector2(150, 440)
		get_tree().call_deferred("change_scene_to_file", next_level_path)

func win_game() -> void:
	game_won.emit()
	get_tree().paused = true

func reset_game() -> void:
	score = 0
	lives = MAX_LIVES
	score_changed.emit(score)
	lives_changed.emit(lives)
	checkpoint_position = Vector2(150, 440)
	get_tree().paused = false
	get_tree().reload_current_scene()
