extends Node
class_name HackableComponent

signal hacked()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func hack():
	hacked.emit()
