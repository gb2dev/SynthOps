extends Node3D


@export var note_title: String = "Title"
@export_multiline var note_content: String = "Content"

## Reference to the note UI.
@export var note_ui: NoteUI

@export_group("Audio")
## AudioStream that gets played when the note is read.
@export var read_sound : AudioStream

var interaction_text: String


func _ready() -> void:
	interaction_text = note_title


func interact(body: Node) -> void:
	if not note_ui.visible:
		Audio.play_sound(read_sound)
		note_ui.open(note_title, note_content)
		print("Read note ", self)


func get_item_type() -> int:
	return -1
