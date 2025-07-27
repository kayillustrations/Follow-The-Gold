extends Control

@onready var time: Label = %Time
@onready var coins: Label = %Coins
@onready var obstacles: Label = %Obstacles
@onready var score: Label = %Score
@onready var highscore: Label = %Highscore

var calculated_score

func _ready():
	null
	

func Config():
	time.text = SceneLoader.ui.min.text + ":" + SceneLoader.ui.sec.text + ":" + SceneLoader.ui.millisec.text
	coins.text = str(GameManager.coins_collected) + "/" + str(GameManager.coins_spawned)
	obstacles.text = str(GameManager.obstacles_hit)
	Score()
	Highscore()
	
func Score():
	calculated_score = GameManager.total_time_milli
	calculated_score += GameManager.coins_collected * 10
	calculated_score -= GameManager.obstacles_hit
	score.text = str(calculated_score)
	pass

func Highscore():
	if calculated_score > GameSave.highscore:
		GameSave.highscore = calculated_score
		GameSave.SaveGame()
	else: GameSave.LoadGame()
	highscore.text = str(GameSave.highscore)
	pass

func _on_restart_pressed() -> void:
	SceneLoader.DeleteAllTemp()
	GameManager.ResetGame()
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	SceneLoader.load_scene(SceneLoader.menu_path)
	pass # Replace with function body.
