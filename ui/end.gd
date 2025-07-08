extends Control

@onready var time: Label = %Time
@onready var coins: Label = %Coins
@onready var obstacles: Label = %Obstacles
@onready var score: Label = %Score
@onready var highscore: Label = %Highscore

func Config():
	time.text = SceneLoader.ui.min.text + ":" + SceneLoader.ui.sec.text + ":" + SceneLoader.ui.millisec.text
	coins.text = str(GameManager.coins_collected) + "/" + str(GameManager.coins_spawned)
	obstacles.text = str(GameManager.obstacles_hit)



func _on_restart_pressed() -> void:
	SceneLoader.DeleteAllTemp()
	GameManager.ResetGame()
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	SceneLoader.load_scene(SceneLoader.menu_path)
	pass # Replace with function body.
