extends Resource
class_name InvItem

var name: String = ""
var id: int
var texture: Texture

var info: Dictionary

func Config(item_info:Dictionary, item_id:int):
	id = item_id
	info = item_info
	
	if !info:
		return
	name = info["TITLE"]
