extends Node
class_name InteractPlayer

var interaction: InteractObject
var secondary_interaction: InteractObject

var player_interact
var interact_class

var isRaycasting: bool
var mouse_position:Vector2

func _ready() -> void:
	player_interact = get_child(0)
	interact_class = player_interact.get_class()
	
	if interact_class.begins_with("Area"):
		ConfigureArea()
		return
	if interact_class.begins_with("RayCast"):
		ConfigureRaycast()
		
		return

func _process(delta: float) -> void:
	mouse_position = get_viewport().get_mouse_position()
	
	if Input.is_action_just_pressed("interact") && interaction != null:
		interaction.interacted.emit()
	
	if isRaycasting:
		Raycasting()

func Raycasting():
	player_interact.target_position = get_parent().project_local_ray_normal(mouse_position) * 100
	
	player_interact.force_raycast_update()
	if player_interact.is_colliding():
		var temp_area: Area3D = player_interact.get_collider()
		if temp_area.get_parent() != interaction:
			_on_area_entered(temp_area)
	else: 
		if secondary_interaction != null:
			_on_area_exited(secondary_interaction.get_child(0))
		if interaction != null:
			_on_area_exited(interaction.get_child(0))

func ConfigureRaycast():
	isRaycasting = true
	player_interact.set_collision_mask_value(1,false)
	player_interact.set_collision_mask_value(3,true)
	player_interact.collide_with_areas = true
	player_interact.collide_with_bodies = false

func ConfigureArea():
	isRaycasting = false
	if !player_interact.is_connected("area_entered",_on_area_entered):
		player_interact.connect("area_entered",_on_area_entered)
		player_interact.connect("area_exited",_on_area_exited)
	
	player_interact.set_collision_layer_value(1,false)
	player_interact.set_collision_layer_value(2,true)
	player_interact.set_collision_mask_value(1,false)
	player_interact.set_collision_mask_value(3,true)

func _on_area_entered(area)->void:
	var temp_area: InteractObject = area.get_parent()
	if interaction == null: #if no active interaction
		interaction = temp_area #set active
		interaction.InRange(player_interact, true)
	else: #if active interaction
		secondary_interaction = interaction #shift previous to secondary
		interaction.InRange(player_interact, false) #deactivate previous
		interaction = temp_area #set this area to active
		interaction.InRange(player_interact, true)

func _on_area_exited(area)->void:
	var temp_area: InteractObject = area.get_parent()
	if interaction == temp_area: #if active interaction exited
		interaction.InRange(player_interact, false)
		interaction = secondary_interaction #set secondary to active
		secondary_interaction = null
		if interaction != null: #if not null
			interaction.InRange(player_interact, true) #activate active
	elif secondary_interaction == temp_area: #if secondary interaction exited
		secondary_interaction = null #delete secondary
	if interaction == null && secondary_interaction == null && !isRaycasting: #if all emptly
		var areas = player_interact.get_overlapping_areas() #double-check area
		if areas.is_empty(): #if empty then exit
			return
		if areas[0] != null: #else set areas to interactions
			interaction = areas[0].get_parent()
			interaction.InRange(player_interact, true)
