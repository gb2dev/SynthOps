extends Node3D


@export var player: CharacterBody3D
@export var cone_material_default: StandardMaterial3D
@export var cone_material_detected: StandardMaterial3D

@onready var raycast: RayCast3D = $RotationPoint/RayCast3D
@onready var rotation_point: Node3D = $RotationPoint
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var currently_detecting: bool = false

signal threat_detected()
signal threat_lost()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var body := raycast.get_collider() as CharacterBody3D
	if body and body.is_in_group("Player"):
		if not currently_detecting:
			threat_detected.emit()
			currently_detecting = true
			animation_player.pause()
			$RotationPoint/CSGCylinder3D2.material = cone_material_detected
	else:
		$RotationPoint/CSGCylinder3D2.height = raycast.get_collision_point().distance_to(rotation_point.global_position)
		$RotationPoint/CSGCylinder3D2.position.z = -$RotationPoint/CSGCylinder3D2.height / 2 - 0.5

		if currently_detecting:
			threat_lost.emit()
			currently_detecting = false
			animation_player.play()
			$RotationPoint/CSGCylinder3D2.material = cone_material_default
