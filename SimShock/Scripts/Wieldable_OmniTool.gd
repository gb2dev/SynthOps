extends Node3D


@export var default_position : Vector3

@export_group("OmniTool Settings")
## Range in which the OmniTool can hack
@export var hack_range : float = 5

@export_group("Audio")
@export var sound_hack : AudioStream
@export var sound_no_hack : AudioStream

# Stores the player interaction component
var player_interaction_component


# This gets called by player interaction compoment when the wieldable is equipped and primary action is pressed
func action_primary(_camera_collision:Vector3, _passed_item_reference : InventoryItemPD):
	hack(_passed_item_reference)
	print("OmniTool.gd: action_primary called. Self: ", self)


func hack(_passed_item_reference : InventoryItemPD):
	var space = get_world_3d().direct_space_state
	var camera = get_viewport().get_camera_3d()
	var query = PhysicsRayQueryParameters3D.create(camera.global_position,
			camera.global_position - camera.global_transform.basis.z * hack_range)
	var result = space.intersect_ray(query)
	if result:
		var body = result.collider
		if body is HackableComponent:
			body.hack()
			Audio.play_sound(sound_hack)
			return
	Audio.play_sound(sound_no_hack)
	_passed_item_reference.subtract(-1)


func action_secondary(is_released:bool):
	print("OmniTool.gd: action_secondary called. Self: ", self)
