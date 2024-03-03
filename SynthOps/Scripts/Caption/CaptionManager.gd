extends Node

func show_caption(stream: AudioStream):
	if stream:
		var caption := load(stream.resource_path.replace(".ogg", ".tres")) as Caption
		if caption:
			var caption_ui := get_tree().get_current_scene().get_node("CaptionUI") as CaptionUI
			caption_ui.show_caption(caption.text, caption.speaker)
