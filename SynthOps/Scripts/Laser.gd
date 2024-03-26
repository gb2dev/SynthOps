extends Node3D


signal triggered

@onready var raycast := $RayCast3D

var is_triggered := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if raycast.get_collider() is Player:
		if not is_triggered:
			is_triggered = true
			triggered.emit()
	else:
		is_triggered = false
