extends HitboxComponent


@export var cone_material_default: StandardMaterial3D
@export var cone_material_detected: StandardMaterial3D

@onready var raycast: RayCast3D = $RotationPoint/RayCast3D
@onready var rotation_point: Node3D = $RotationPoint
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var threat: CharacterBody3D
var is_detecting: bool:
	set(value):
		if is_detecting != value:
			is_detecting = value

			if value:
				threat_detected.emit()
				animation_player.pause()
				$RotationPoint/CSGCylinder3D.material = cone_material_detected
			else:
				threat_lost.emit()
				animation_player.play()
				$RotationPoint/CSGCylinder3D.material = cone_material_default

signal threat_detected()
signal threat_lost()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if threat:
		raycast.look_at(threat.global_position)
		raycast.force_raycast_update()

		if raycast.get_collider() is Player:
			is_detecting = true
		else:
			is_detecting = false
	else:
		is_detecting = false


func shutdown():
	$RotationPoint/CSGCylinder3D.visible = false
	set_script(null)


func _on_area_3d_body_entered(body):
	var player := body as Player
	if player:
		threat = player


func _on_area_3d_body_exited(body):
	var player := body as Player
	if player:
		threat = null
