extends RigidBody3D


var damage := 50

@onready var blast_radius := $BlastRadius


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	var bodies: Array[Node3D] = blast_radius.get_overlapping_bodies()
	for b in bodies:
		var new_intersection = PhysicsRayQueryParameters3D.create(global_position, b.global_position)
		var collision = get_world_3d().direct_space_state.intersect_ray(new_intersection)
		if collision:
			if collision.collider is HitboxComponent:
				collision.collider.damage(damage)
			elif collision.collider is Player:
				collision.collider.take_damage(damage)
	queue_free()
