## This Autoload is a Scene that we can instantiate different UIs and Temp Scenes into the parents as needed

## I do this so that UI settings do not need to be reloaded every time we switch Gameplay Scenes.
	## Either you Disable and turn off Visibility of that UI, or you simply queue_free to delete it

extends Control

@onready var pause_menu: PackedScene = preload("res://ui/pause_menu.tscn")

@onready var ui_parent: CanvasLayer = $"UI Scenes"
@onready var temp_parent: CanvasLayer = $"Temp Scenes"
@onready var debug_menu: Control = $"UI Scenes/Debug"

var level_path: String = ""
var menu_path: String = ""

var inTempScene: bool
var inMenu: bool
var currentTemp: Node
var current_scene_path: String
var new_scene_path: String

func _ready() -> void:
	debug_menu.visible = false
	print(current_scene_path)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug") && GameSave.debug_mode:
		UISceneActivate(debug_menu)
	if Input.is_action_just_pressed("exit"):
		if currentTemp != null:
			DeleteTempScene(currentTemp)
		else: AddTempScene(pause_menu)

func load_scene(path_name: String):
	if FileAccess.file_exists(path_name):
		new_scene_path = path_name
	else:
		printerr("scene not found")
		return 1
	#transition fade in
	#await transition_ended
	get_tree().change_scene_to_file(new_scene_path)
	current_scene_path = new_scene_path
	#transition fade out
	#await transition_ended
	#transition idle/reset
	pass

func LoadGame():
	if GameSave.newGame:
		GameSave.SaveGame()
		pass
	else: GameSave.LoadGame()
	load_scene(level_path)
	GameManager.ResetDailyStats()
	#SceneLoader.UISceneActivate(SceneLoader.ui)
	pass

func UISceneActivate(scene_node: Control):
	var active = !scene_node.visible
	scene_node.visible = active
	if active:
		scene_node.mouse_filter = MOUSE_FILTER_STOP
	else:
		scene_node.mouse_filter = MOUSE_FILTER_IGNORE

func AddTempScene(scene:PackedScene):
	var scene_instance = scene.instantiate()
	temp_parent.add_child(scene_instance)
	
	GameManager.PauseGame(true)
	
	inTempScene = true
	currentTemp = scene_instance
	temp_parent.layer = 2
	return scene_instance

func DeleteTempScene(scene_self:Node):
	if scene_self != null:
		scene_self.queue_free()
	if temp_parent.get_child_count(true) > 1:
		currentTemp = temp_parent.get_child(temp_parent.get_child_count()-1)
	else: 
		inTempScene = false
		temp_parent.layer = 1
		currentTemp = null
		
		GameManager.PauseGame(false)

func DeleteAllTemp():
	var scenes = temp_parent.get_children()
	for i in scenes.size():
		scenes[i].queue_free()
	inTempScene = false
	temp_parent.layer = 1
	currentTemp = null
	
	GameManager.PauseGame(false)
