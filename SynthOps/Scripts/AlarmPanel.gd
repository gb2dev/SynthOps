extends Node3D


const ALARM_SOUND = preload("res://COGITO/Assets/Audio/Kenney/UiAudio/error_008.ogg")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func activate():
	Audio.play_sound_3d(ALARM_SOUND).global_position = global_position
