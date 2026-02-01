@abstract
class_name PlayerMovement
extends Resource


@export var _additional_speed: float = 0

var additional_speed: float:
	get: return _additional_speed

var _player: Player

func initialize(player: Player):
	_player = player


func physics_step(_delta: float):
	pass