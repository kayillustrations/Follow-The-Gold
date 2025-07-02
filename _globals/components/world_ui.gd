@tool
extends Node
class_name WorldUI

var popup: Node
@export var isActive: bool = true

@onready var viewport: SubViewport = $SubViewport
var ui_visual: Control

func _ready() -> void:
	popup = get_parent()
	Configure3DPopup()
	pass

func Configure3DPopup()->void:
	popup.texture = viewport.get_texture()
	popup.visible = isActive
	#print(popup.texture)
