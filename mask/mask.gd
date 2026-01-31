class_name Mask
extends Node2D

@export var _player_movement: PlayerMovement

var player_movement: PlayerMovement:
	get: return _player_movement

@onready var _sprite: Sprite2D = $Sprite2D
@onready var _area: Area2D = $Area2D

var is_equipped: bool