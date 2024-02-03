extends Node3D

@export var label: Label3D
@export var audio_stream_player: AudioStreamPlayer3D
@export var sound_wrong_code: AudioStream
@export var sound_correct_code: AudioStream
@export var correct_code: String

var current_index: int

signal correct_code_entered()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func interact(interactor: Node3D, data: Dictionary):
	if label.text == correct_code:
		return

	var number : int = data.number
	print("Entered keypad number ", number)
	label.text = label.text.rstrip("-") + str(number)
	for i in range(current_index, 3):
		label.text += "-"
	if current_index == 3:
		current_index = 0
		if label.text == correct_code:
			audio_stream_player.stream = sound_correct_code
			correct_code_entered.emit()
		else:
			label.text = "----"
			audio_stream_player.stream = sound_wrong_code
		audio_stream_player.play()
	else:
		current_index += 1


func autofill_correct_code():
	if label.text != correct_code:
		label.text = correct_code
		correct_code_entered.emit()
