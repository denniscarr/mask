class_name Door
extends Node2D

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
		var mask := (body as Player).get_mask()
		if mask and mask.modulate == modulate:
			_open()
