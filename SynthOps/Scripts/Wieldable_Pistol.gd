extends Node3D


@export_group("Pistol Settings")
## Node for the ray origin
@onready var bullet_point: Node3D = $Bullet_Point
## Prefab of ray
@export var ray_prefab: PackedScene
## How long rays linger in the air
@export var ray_lifespan: float = 5.0
## The Field Of View change when aiming down sight. In degrees.
@export var ads_fov = 65
## Default position for tweening from ADS
@export var default_position: Vector3

@export_group("Audio")
@export var sound_primary_use: AudioStream
@export var sound_secondary_use: AudioStream
@export var sound_reload: AudioStream

var player_interaction_component: PlayerInteractionComponent # Stores the player interaction component


# This gets called by player interaction compoment when the wieldable is equipped and primary action is pressed
func action_primary(_camera_collision: Vector3, _passed_item_reference: InventoryItemPD):
	hit_scan_collision(_camera_collision, _passed_item_reference) # Do the hitscan
	Audio.play_sound_3d(sound_primary_use).global_position = self.global_position
	print("Pistol.gd: action_primary called. Self: ", self)


func action_secondary(is_released:bool):
	var camera = get_viewport().get_camera_3d()
	if is_released:
		# ADS Camera Zoom OUT
		var tween_cam = get_tree().create_tween()
		tween_cam.tween_property(camera,"fov", 75, .2)
		var tween_pistol = get_tree().create_tween()
		tween_pistol.tween_property(self,"position", default_position, .2)
	else:
		# ADS Camera Zoom IN
		var tween_cam = get_tree().create_tween()
		tween_cam.tween_property(camera,"fov", ads_fov, .2)
		var tween_pistol = get_tree().create_tween()
		tween_pistol.tween_property(self,"position", Vector3(0,default_position.y,default_position.z), .2)


func hit_scan_collision(collision_point, _passed_item_reference: InventoryItemPD):
	var bullet_direction = (collision_point - bullet_point.get_global_transform().origin).normalized()
	var new_intersection = PhysicsRayQueryParameters3D.create(bullet_point.get_global_transform().origin, collision_point + bullet_direction * 2)

	var bullet_collision = get_world_3d().direct_space_state.intersect_ray(new_intersection)

	# Spawning a ray
	var instantiated_ray = ray_prefab.instantiate()
	instantiated_ray.draw_ray(bullet_point.get_global_transform().origin, collision_point + bullet_direction)
	bullet_point.add_child(instantiated_ray)

	if bullet_collision:
		hit_scan_damage(bullet_collision.collider, _passed_item_reference)


func hit_scan_damage(collider, _passed_item_reference: InventoryItemPD):
	if collider is HitboxComponent:
		collider.damage(_passed_item_reference.wieldable_damage)
