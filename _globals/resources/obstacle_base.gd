extends StaticBody2D
class_name ObstacleObject

@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var area_2d: Area2D = %Area2D
@onready var particles_2d: CPUParticles2D = %CPUParticles2D

@export var random_sprite: bool
@export var sprites: Array[Texture2D]

func _physics_process(delta: float) -> void:
	if GameManager.isPaused:
		return
	position.y += GameManager.b_movement*delta

func Config():
	if !sprites.is_empty():
		ChooseSprite()

func ChooseSprite():
	if random_sprite: 
		sprite_2d.texture = sprites.pick_random()
		sprite_2d.flip_h = bool([0,1].pick_random())
		return
	#otherwise is sewer
	if global_position.x == 0: #middle
		sprite_2d.texture = sprites[0]
		return
	sprite_2d.scale.x = .3
	if global_position.x > 0: #right
		sprite_2d.texture = sprites[1]
	else: #left
		sprite_2d.texture = sprites[1]
		sprite_2d.flip_h = true

#func CheckIfActive():
	#if effect_timer.is_stopped():
		#return false
	#else: return true
