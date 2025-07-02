extends StaticBody2D
class_name ObstacleObject

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var area_2d: Area2D = $Area2D
@onready var effect_timer: Timer = $EffectTimer

func CheckIfActive():
	if effect_timer.is_stopped():
		return false
	else: return true
