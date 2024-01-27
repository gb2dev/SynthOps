extends Node3D


@export var default_position : Vector3

@export_group("Audio")
@export var sound_primary_use : AudioStream
@export var sound_secondary_use : AudioStream

# Stores the player interaction component
var player_interaction_component


# This gets called by player interaction compoment when the wieldable is equipped and primary action is pressed
func action_primary(_camera_collision:Vector3, _passed_item_reference : InventoryItemPD):
	print("OmniTool.gd: action_primary called. Self: ", self)


func action_secondary(is_released:bool):
	print("OmniTool.gd: action_secondary called. Self: ", self)
