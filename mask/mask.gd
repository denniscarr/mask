class_name Mask
extends Node2D

@export var _player_movement: PlayerMovement
@export var _lock_type: Door.LockType

var is_equipped: bool

var player_movement: PlayerMovement:
	get:
		return _player_movement

var lock_type: Door.LockType:
	get:
		return _lock_type

@onready var _sprite: Sprite2D = $Sprite2D
@onready var _area: Area2D = $Area2D
