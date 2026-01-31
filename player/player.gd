class_name Player
extends CharacterBody2D

const MASK_OFFSET = Vector2(2, -14)

@export var _default_movement: PlayerMovement

var _equipped_mask: Mask
var _movement: PlayerMovement

@onready var _col_area: Area2D = $Area2D


func _ready() -> void:
	_set_movement(_default_movement)
	_col_area.area_entered.connect(_on_col_area_entered)


func _physics_process(delta: float) -> void:
	_movement.physics_step(delta)
	move_and_slide()

	if _equipped_mask:
		_equipped_mask.global_position = global_position + MASK_OFFSET


func _equip_mask(mask: Mask):
	_equipped_mask = mask
	_set_movement(_equipped_mask.player_movement)
	mask.is_equipped = true


func _set_movement(new_movement: PlayerMovement):
	_movement = new_movement
	_movement.initialize(self)


func _on_col_area_entered(area: Area2D):
	if area.is_in_group("deadly"):
		queue_free()
		return
		
	if area.get_parent() is Mask:
		var mask := area.get_parent() as Mask
		if not mask.is_equipped:
			_equip_mask(mask)
