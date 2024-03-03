class_name CaptionUI
extends Control


@onready var vbox: VBoxContainer = $MarginContainer/VBoxContainer


func show_caption(text: String, speaker: String = "") -> void:
	var label := Label.new()
	vbox.add_child(label)

	label.text = speaker

	if not speaker.is_empty():
		label.text += ": "

	label.text += text

	if vbox.get_child_count() == 1:
		show()

	await get_tree().create_timer(2.0).timeout

	if vbox.get_child_count() == 1:
		hide()

	label.queue_free()
