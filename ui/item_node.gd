extends Panel

@export var isShop: bool = false
var shop_parent

@onready var sprite_texture: Sprite2D = %sprite_texture
@onready var tooltip: Panel = %Tooltip
@onready var number_label: Label = $Label
@onready var mouse_timer: Timer = $MouseTimer
@onready var drag_drop: Button = $DragDrop


var current_slot: InvSlot
var current_item: InvItem
var tooltipActive: bool = false
var mouseEntered: bool

func _ready() -> void:
	SceneLoader.UISceneActivate(SceneLoader.ui) #TEMP
	tooltip.position = global_position
	if isShop:
		shop_parent = find_parent("ShopSlot")
		#drag_drop.disabled = true
		#drag_drop.visible = false

func update(slot: InvSlot)->void:
	if !slot.item:
		sprite_texture.visible = false
		number_label.visible = false
		current_item = null
	else:
		sprite_texture.visible = true
		#sprite_texture.texture = slot.item.texture
		if current_slot.amount > 1:
			number_label.visible = true
			number_label.text = str(current_slot.amount)
		else: 
			number_label.visible = false
		current_item = slot.item

func ConfigItem(item:InvItem):
	if item == null: #if no item, send empty slot
		update(InvSlot.new())
		return
	
	if current_slot == null: #if no slot, create empty slot
		current_slot = InvSlot.new()
		current_slot.item = item
		current_slot.amount = 1
	
	update(current_slot)
	tooltip.ConfigLabels(current_slot.item)

func _on_item_button_mouse_entered():
	if current_slot != null && !tooltipActive:
		mouse_timer.start()
		tooltipActive = true

		await(mouse_timer.timeout)
		#if still exists, activate
		if tooltipActive:
			tooltip.visible = true

func _on_mouse_exited():
		# Not hovering over area.
	if current_slot != null && tooltipActive:
		if not Rect2(Vector2(), size).has_point(get_local_mouse_position()):
			tooltipActive = false
			tooltip.visible = false
