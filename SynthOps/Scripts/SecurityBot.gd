extends HitboxComponent


enum {
	IDLE,
	ALERT,
}

var state := IDLE
var target: Node3D
var move_speed := 2
var turn_speed: int
var pause := false

@onready var raycast := $Body/RayCast3D
@onready var shoot_timer := $ShootTimer
@onready var pause_timer := $PauseTimer
@onready var hit_marker := $Body/RayCast3D/HitMarker
@onready var eyes := $Body/Eyes
@onready var body := $Body
@onready var path_follow: PathFollow3D = get_parent()
@onready var area := $Body/Area3D

@export var shoot_sound: AudioStream

## Prefab of ray
@export var ray_prefab: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		IDLE:
			area.scale.y = 5
			turn_speed = 1
			eyes.look_at(global_position - transform.basis.z * move_speed)

			if pause:
				return

			path_follow.progress += move_speed * delta

			if path_follow.progress_ratio <= 0 or path_follow.progress_ratio >= 1:
				pause = true
				move_speed *= -1
				await get_tree().create_timer(2.0).timeout
				pause = false
		ALERT:
			area.scale.y = 6
			turn_speed = 8
			eyes.look_at(target.global_position)

	body.rotate_y(deg_to_rad(eyes.rotation.y * turn_speed))


func _on_area_3d_body_entered(body) -> void:
	if body is Player:
		pause_timer.stop()
		state = ALERT
		target = body
		shoot_timer.start()
		pause = true


func _on_area_3d_body_exited(body) -> void:
	if body is Player:
		shoot_timer.stop()
		pause_timer.start()


func _on_shoot_timer_timeout() -> void:
	Audio.play_sound_3d(shoot_sound).global_position = global_position

	var radius := 0.06
	var r := sqrt(randf_range(0.0, 1.0)) * radius
	var t := randf_range(0.0, 1.0) * TAU
	raycast.rotation.x = r * cos(t)
	raycast.rotation.y = r * sin(t)

	var player := raycast.get_collider() as Player
	if player:
		player.take_damage(10)

	# Spawning a ray
	var instantiated_ray = ray_prefab.instantiate()
	instantiated_ray.draw_ray(raycast.global_position, hit_marker.global_position)
	get_tree().current_scene.add_child(instantiated_ray)


func _on_pause_timer_timeout() -> void:
	pause = false
	state = IDLE
