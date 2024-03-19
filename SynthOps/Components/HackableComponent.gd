extends Node
class_name HackableComponent

signal hacked()

var hack_text := "Hackable"
var is_hacked: bool


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func hack():
	hacked.emit()
	is_hacked = true
