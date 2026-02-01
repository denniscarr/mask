class_name Player
extends CharacterBody2D

signal died

const BASE_MOVE_SPEED: float = 200
const MASK_OFFSET = Vector2(2, -14)

@export var _default_movement: PlayerMovement

var movement_enabled: bool = true

var _equipped_masks: Array[Mask]
var _is_dead: bool = false

@onready var _col_area: Area2D = $Area2D


func _ready() -> void:
	_default_movement.initialize(self)
	_col_area.area_entered.connect(_on_col_area_entered)


func _physics_process(delta: float) -> void:
	if _is_dead or not movement_enabled:
		return

	var total_speed := BASE_MOVE_SPEED
	_default_movement.physics_step(delta)
	for mask: Mask in _equipped_masks:
		mask.player_movement.physics_step(delta)
		total_speed += mask.player_movement.additional_speed

	velocity *= total_speed
	move_and_slide()

	for mask: Mask in _equipped_masks:
		mask.global_position = global_position + MASK_OFFSET



func has_mask_for_lock(lock_type: Door.LockType) -> bool:
	for mask: Mask in _equipped_masks:
		if mask.lock_type == lock_type:
			return true
	return false


func _equip_mask(mask: Mask):
	_equipped_masks.push_back(mask)
	mask.player_movement.initialize(self)
	mask.is_equipped = true
	mask.get_parent().move_child(mask, mask.get_parent().get_child_count() - 1)


func _die():
	_is_dead = true
	modulate = Color.RED
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.8)
	await tween.finished
	died.emit()


func _on_col_area_entered(area: Area2D):
	if not _is_dead and area.is_in_group("deadly"):
		_die()
		return

	if area.get_parent() is Mask:
		var mask := area.get_parent() as Mask
		if not mask.is_equipped:
			_equip_mask(mask)
