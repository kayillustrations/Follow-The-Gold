extends Control

signal label_finished

@onready var time: Label = %Time
@onready var coins: Label = %Coins
@onready var obstacles: Label = %Obstacles
@onready var score: Label = %Score
@onready var highscore: Label = %Highscore
@onready var label_tick: Timer = $"Label Tick"
@onready var tick_audio: AudioStreamPlayer2D = $"tick audio"

var calculated_score


func Config():
	$New.visible = false
	time.text = SceneLoader.ui.min.text + ":" + SceneLoader.ui.sec.text + ":" + SceneLoader.ui.millisec.text
	coins.text = ""
	obstacles.text = ""
	score.text = ""
	highscore.text = str(GameSave.highscore)
	
	TickUp(coins,GameManager.coins_collected,0)
	await label_finished
	coins.text = coins.text + "/" + str(GameManager.coins_spawned)
	
	TickUp(obstacles,GameManager.obstacles_hit,0)
	await label_finished
	obstacles.text = str(GameManager.obstacles_hit)
	
	Score()
	TickUp(score,calculated_score,1)
	await label_finished
	Highscore()

func TickUp(text:Label, number:int,start:int):
	var i: int = start
	while i <= number:
		if Input.is_action_just_pressed("Boost"):
			break
		if number < 100: 
			label_tick.start(.05)
		else: label_tick.start(.005)
		i += 1
		text.text = str(i)
		tick_audio.play()
		await label_tick.timeout
	text.text = str(number)
	label_finished.emit()

func Score():
	calculated_score = GameManager.total_time_milli
	calculated_score += GameManager.coins_collected * 10
	calculated_score -= GameManager.obstacles_hit
	pass

func Highscore():
	if calculated_score > GameSave.highscore:
		TickUp(highscore,calculated_score,GameSave.highscore)
		$New.visible = true
		GameSave.highscore = calculated_score
		GameSave.SaveGame()
	else: 
		$New.visible = false
		GameSave.LoadGame()
		highscore.text = str(GameSave.highscore)
	pass

func _on_restart_pressed() -> void:
	SceneLoader.DeleteAllTemp()
	GameManager.ResetGame()
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	SceneLoader.load_scene(SceneLoader.menu_path)
	pass # Replace with function body.
