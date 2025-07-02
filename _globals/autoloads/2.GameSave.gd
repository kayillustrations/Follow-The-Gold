extends Node

const SCENE_SAVE_FOLDER:String = "res://saves/"

var game_config:ConfigFile = ConfigFile.new()
var settings_config:ConfigFile = ConfigFile.new()

#------Settings------
var debug_mode:bool = true
var newGame: bool = false
#--------Stats-------
var player_stats: Dictionary
var player_inventory: Inv

func _ready() -> void:
	if !CheckSaveFolder("settings"): #if no settings, make file
		SaveSettings()
	if !CheckSaveFolder("save"): #if no game save(s), disable load
		newGame = true
	LoadSettings()

func SaveGame(): #may be able to add multiple loads/saves in the future
	##SAVE: game_config.set_value("category",variable", variable)
	
	game_config.save(SCENE_SAVE_FOLDER+"save.cfg")
	pass

func LoadGame():
	var err = game_config.load(SCENE_SAVE_FOLDER+"save.cfg")
	if err == OK:
		##LOAD: variable = config.get_value("category","variable")
		pass
	
	ConfigInventory()
	#configure game

func SaveSettings():
	##SAVE: settings_config.set_value("category",variable", variable)
	settings_config.set_value("Settings","debug_mode", debug_mode)
	
	settings_config.save(SCENE_SAVE_FOLDER+"settings.cfg")
	pass

func LoadSettings():
	var err = settings_config.load(SCENE_SAVE_FOLDER+"settings.cfg")
	if err == OK:
		## variable = settings_config.get_value("category", "variable")
		pass

func CheckSaveFolder(file_name:String):
	if FileAccess.file_exists(SCENE_SAVE_FOLDER+file_name+".cfg"):
		return true
	else: return false

func ConfigInventory():
	if newGame:
		player_inventory = Inv.new()
		player_inventory.fill_slots(10)
	print(player_inventory.slots)
	#update inventory ui TODO
