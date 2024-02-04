class_name NoteUI
extends Control


@onready var title_label: Label = $VBoxContainer/TitleLabel
@onready var content_label: Label = $VBoxContainer/ContentLabel

## Reference to the Node that has the player.gd script.
@export var player: Node


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		close()


func open(title : String, content : String) -> void:
	title_label.text = title
	content_label.text = content
	visible = true
	player._on_pause_movement()


func close() -> void:
	visible = false
	player._on_resume_movement()
