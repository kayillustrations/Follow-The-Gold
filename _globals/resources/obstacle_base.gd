extends StaticBody2D
class_name ObstacleObject

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var area_2d: Area2D = $Area2D
@onready var particles_2d: CPUParticles2D = $CPUParticles2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func _physics_process(delta: float) -> void:
	if GameManager.isPaused:
		return
	position.y += GameManager.b_movement*delta

#func CheckIfActive():
	#if effect_timer.is_stopped():
		#return false
	#else: return true
