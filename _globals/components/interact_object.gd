extends Node
class_name InteractObject

signal configured

signal color_change(bool)
signal interacted

@export var popup:Node
@export var isActive: bool = true
@export var isTesting: bool = true

var area:Node
var isInRange:bool

@export_group("Visuals")
@export var hasPopup: bool = false
@export var changesColor: bool = false
@export var interact_color:Color = Color.PINK

func _ready() -> void:
	area = get_child(0)
	if area == null:
		printerr(self.name + " area is not set.")
		return
	
	Configure()
	pass

func Configure()->void:
	area.set_collision_layer_value(1,false)
	area.set_collision_layer_value(3,true)
	area.set_collision_mask_value(1,false)
	area.set_collision_mask_value(2,true)
	
	AreaActivation()
	configured.emit()

func AreaActivation():
	area.set_deferred("monitorable", isActive)

func InRange(player_area, b:bool):
	if !isActive: return
	isInRange = b
	if isTesting:
		print(player_area)
		print("InRange:"+str(isInRange))
	Visuals(isInRange)

func Visuals(activate:bool)->void:
	if hasPopup:popup.visible = activate
	if changesColor:color_change.emit(activate)
