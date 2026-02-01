class_name Mask
extends Node2D

enum MaskType { DIAG, FAST, INFINITE }

@export var _mask_type: MaskType

var is_equipped: bool

var mask_type: MaskType:
	get:
		return _mask_type

@onready var _sprite: Sprite2D = $Sprite2D
@onready var _area: Area2D = $Area2D
