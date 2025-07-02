extends Panel

@export var nameLabel: Label
@export var categoryLabel: Label
@export var energyPercent: Label
@export var beggingPercent: Label
@export var stealingPercent: Label
@export var taglineLabel: Label
@export var instructionLabel: Label


func _ready():
	visible = false

func ConfigLabels(item: InvItem):
	nameLabel.text = item.title
	SetPercent(energyPercent, item.energyMod)
	SetPercent(beggingPercent, item.beggingMod)
	SetPercent(stealingPercent, item.swipingMod)
	taglineLabel.text = "\"" + item.tagline + "\""
	instructionLabel.text = item.description
	SetCategory(item)
	get_minimum_size()

func SetCategory(item):
	match item.item_type:
		0: 
			categoryLabel.text = "Consumable"
			categoryLabel.modulate = item.consumeColor
			instructionLabel.text = "Item has 1 use. " + instructionLabel.text
			energyPercent.text = "+" + str(item.energyMod)
		1: 
			categoryLabel.text = "Reusable"
			categoryLabel.modulate = item.equipColor
		2: 
			categoryLabel.text = "Permanant"
			categoryLabel.modulate = item.permColor
		3:
			categoryLabel.text = "Upgrade"
			categoryLabel.modulate = item.upgradeColor

func SetPercent(label, mod):
	label.text = str(mod) + "%"
	
	if mod > 0:
		label.text = "+" + label.text
		label.modulate = Color.LIME_GREEN
	elif mod < 0:
		label.modulate = Color.ORANGE_RED
	else:
		label.modulate = Color.WHITE
