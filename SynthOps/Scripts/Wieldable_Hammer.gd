extends Node3D


@export var default_position : Vector3

@export_group("Hammer Settings")
## Range in which the hammer can hit
@export var hit_range : float = 2.5
## Damage dealt on hit.
@export var damage_amount : int = 1

@export_group("Audio")
@export var sound_hit : AudioStream
@export var sound_miss : AudioStream

# Stores the player interaction component
var player_interaction_component


# This gets called by player interaction compoment when the wieldable is equipped and primary action is pressed
func action_primary(_camera_collision:Vector3, _passed_item_reference : InventoryItemPD):
	hit()
	print("Hammer.gd: action_primary called. Self: ", self)


func hit():
	var space = get_world_3d().direct_space_state
	var camera = get_viewport().get_camera_3d()
	var query = PhysicsRayQueryParameters3D.create(camera.global_position,
			camera.global_position - camera.global_transform.basis.z * hit_range)
	var result = space.intersect_ray(query)
	if result:
		var body = result.collider
		if body is HitboxComponent:
			body.damage(damage_amount)
			Audio.play_sound(sound_hit)
			return
	Audio.play_sound(sound_miss)


func action_secondary(is_released:bool):
	print("Hammer.gd: action_secondary called. Self: ", self)
