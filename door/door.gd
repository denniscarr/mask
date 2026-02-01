class_name Door
extends Node2D

enum LockType { NONE, DIAGONAL }

@export var _lock_type: LockType

@onready var _body_shape: CollisionShape2D = $StaticBody2D/CollisionShape2D
@onready var _sprite: Sprite2D = $Sprite2D
@onready var _area: Area2D = $Area2D


func _ready():
	_area.body_entered.connect(_on_area_body_entered)


func _open():
	_body_shape.set_deferred("disabled", true)
	_sprite.visible = false


func _on_area_body_entered(body: Node2D):
	if body is Player:
		if (body as Player).has_mask_for_lock(_lock_type):
			_open()
