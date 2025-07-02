## Reusable functions, data-parsing, etc.
extends Node

var PATH_JSON_DATA = "res://_globals/SoNS_Data.json"
var PATH_RESOURCE_FOLDER = "res://_globals/resources/"
var json_data

func _ready() -> void:
	if PATH_JSON_DATA != null:
		json_data = load_json_data_from_path(PATH_JSON_DATA)

func load_json_data_from_path(path:String):
	var item_string = FileAccess.get_file_as_string(path)
	
	if item_string == null:
		printerr("failed to get file: ", path)
		return
	
	var data = JSON.parse_string(item_string)
	
	if data == null:
		printerr("failed to parse JSON data: ", path)
		return
	
	return data

func load_data_into_dict(sheet_name:String):
	var data = json_data.get(sheet_name)
	if data == null:
		printerr("unable to get sheet info: ",sheet_name)
	return data

func create_resource_dir(folder_name:String):
	var dir = DirAccess.open(PATH_RESOURCE_FOLDER)
	if !dir.dir_exists(folder_name):
		dir.make_dir(folder_name)
	else: printerr("Dir Exists")

func dir_contents(folder_name:String):
	var dir = DirAccess.open(PATH_RESOURCE_FOLDER + folder_name)
	if dir:
		dir.list_dir_begin()
		var item_name = dir.get_next()
		while item_name != "":
			if dir.current_is_dir():
				print("Directory: " + item_name)
			else:
				print("item: " + item_name)
			item_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")

func dir_find(folder_name:String, resource_name: String):
	var dir = DirAccess.open(PATH_RESOURCE_FOLDER + folder_name)
	if dir:
		dir.list_dir_begin()
		var item_name = dir.get_next()
		while item_name != "":
			if item_name.get_basename() == resource_name:
				return item_name
			item_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	pass

func create_item_array(data:Dictionary, criteria_key: String, criteria_value):
	var array: Array
	var current_data
	for i in data.size()-1:
		current_data = data[str(i)]
		if criteria_key != "":
			if current_data[criteria_key] != criteria_value:
				break
		var item:InvItem = InvItem.new()
		item.Config(current_data,i)
		array.append(item)
	return array

func GetChildrenType(parent:Node, type_name:String):
	var children = parent.get_children()
	var children_type = []
	for i in children.size():
		if children[i].is_class(type_name):
			children_type.append(children[i])
	return children_type
