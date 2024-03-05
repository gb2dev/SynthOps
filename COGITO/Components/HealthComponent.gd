extends Node
class_name HealthComponent

signal health_changed(current_value, max_value)
signal damage_taken()
signal death()

@export var max_health : float = 5
@export var start_health : float
@export var no_sanity_damage : float
var current_health : float
var global_position : Vector3 # Used for Audio

@export var sound_on_death : AudioStream
@export var destroy_on_death : Array[NodePath]
@export var spawn_on_death : PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	current_health = start_health
	global_position = get_parent().global_position


func set_to(amount):
	if amount < current_health:
		emit_signal("damage_taken")

	current_health = amount

	if current_health > max_health:
		current_health = max_health
	if current_health <= 0:
		current_health = 0
		emit_signal("death")
		on_death()
	emit_signal("health_changed", current_health, max_health)


func add(amount):
	set_to(current_health + amount)


func subtract(amount):
	set_to(current_health - amount)


func on_death():
	if sound_on_death:
		Audio.play_sound_3d(sound_on_death).global_position = self.global_position

	if spawn_on_death:
		var spawned_object = spawn_on_death.instantiate()
		spawned_object.global_position = global_position
		get_tree().current_scene.add_child(spawned_object)

	for nodepath in destroy_on_death:
		get_node(nodepath).queue_free()
