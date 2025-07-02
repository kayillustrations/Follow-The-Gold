extends Button

const DRAGPREVIEW = preload("res://ui/drag_preview_scene_inv.tscn")
@onready var slot:Panel = get_parent()

#dropper
func _get_drag_data(at_position:Vector2):
	if slot.current_item == null:
		print("null")
		return
	var dragPreview:Node2D = DRAGPREVIEW.instantiate()
	dragPreview.texture = slot.sprite_texture.texture
	dragPreview.current_node = self
	dragPreview.connect("dropped",CheckDropped)
	SceneLoader.temp_parent.add_child(dragPreview)
	
	slot.sprite_texture.texture = null
	return slot

func CheckDropped():
	if slot.current_item == null: return
	#if slot.sprite_texture.texture != slot.current_item.texture: #TEMP
		#slot.sprite_texture.texture = slot.current_item.texture
	pass

#drop recipeint
func _can_drop_data(at_position:Vector2, data)-> bool:
	if slot.isShop != data.isShop: return false
	else: return true

func _drop_data(at_position:Vector2, data)-> void:
	var hold_item = slot.current_item
	#SaveLoad.player_inv.switch(slot.current_slot,data.current_slot) #TODO
	slot.mouse_entered.emit()
	button_pressed = false
