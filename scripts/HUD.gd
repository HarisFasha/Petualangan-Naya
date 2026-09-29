extends CanvasLayer

func _ready() -> void:
	# WAJIB: supaya HUD tetap "hidup" (bisa proses input/gambar ulang)
	# walaupun get_tree().paused = true (saat kalah/menang).
	process_mode = Node.PROCESS_MODE_ALWAYS

	GameManager.score_changed.connect(_on_score_changed)
	GameManager.lives_changed.connect(_on_lives_changed)
	GameManager.game_won.connect(_on_game_won)

	$TopPanel/HBox/ScoreLabel.text = str(GameManager.score)
	_update_hearts(GameManager.lives)
	$GameOverPanel.visible = false
	$WinPanel.visible = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		GameManager.reset_game()

func _on_score_changed(new_score: int) -> void:
	$TopPanel/HBox/ScoreLabel.text = str(new_score)

func _on_lives_changed(new_lives: int) -> void:
	_update_hearts(new_lives)
	$GameOverPanel.visible = new_lives <= 0

func _update_hearts(lives: int) -> void:
	var hearts := $TopPanel/HeartsBox.get_children()
	for i in hearts.size():
		hearts[i].texture = load("res://assets/ui/heart_full.png") if i < lives else load("res://assets/ui/heart_empty.png")

func _on_game_won() -> void:
	$WinPanel/VBox/ScoreFinalLabel.text = "Skor akhir: " + str(GameManager.score)
	$WinPanel.visible = true

func _on_restart_button_pressed() -> void:
	SFX.play("select")
	GameManager.reset_game()
