@tool
class_name Wall
extends Node2D

const _THICKNESS: float = 64.0

@onready var _collision_shape: CollisionShape2D = $CollisionShape2D
@onready var _sprite: Sprite2D = $Sprite2D


func set_length(length: float, is_horizontal: bool = false):
    var col_shape := _collision_shape.shape as RectangleShape2D
    if is_horizontal:
        _sprite.scale.x = length / _THICKNESS
        _sprite.scale.y = 1.0
        col_shape.size.x = length
        col_shape.size.y = _THICKNESS
    else:
        _sprite.scale.x = 1.0
        _sprite.scale.y = length / _THICKNESS
        col_shape.size.x = _THICKNESS
        col_shape.size.y = length