class_name Player
extends CharacterBody2D

signal died

const BASE_MOVE_SPEED: float = 200
const FAST_MOVE_SPEED: float = 1000
const MASK_OFFSET = Vector2(2, -14)

var movement_enabled: bool = true

var _equipped_masks: Array[Mask]
var _is_dead: bool = false
var _has_diag_mask: bool = false
var _has_fast_mask: bool = false
var _has_infinite_mask: bool = false
var _prev_move_dir: Vector2

@onready var _col_area: Area2D = $Area2D


func _ready() -> void:
	_col_area.area_entered.connect(_on_col_area_entered)


func _physics_process(_delta: float) -> void:
	if _is_dead or not movement_enabled:
		return

	# Get move dir
	var move_dir: Vector2
	if _has_diag_mask:
		if Input.is_action_pressed("left"):
			move_dir.x = -1
			move_dir.y = -1
		elif Input.is_action_pressed("right"):
			move_dir.x = 1
			move_dir.y = 1
		elif Input.is_action_pressed("up"):
			move_dir.x = 1
			move_dir.y = -1
		elif Input.is_action_pressed("down"):
			move_dir.x = -1
			move_dir.y = 1
	else:
		if Input.is_action_pressed("left"):
			move_dir.x = -1
		elif Input.is_action_pressed("right"):
			move_dir.x = 1
		elif Input.is_action_pressed("up"):
			move_dir.y = -1
		elif Input.is_action_pressed("down"):
			move_dir.y = 1

	move_dir = move_dir.normalized()

	if _has_infinite_mask and move_dir == Vector2.ZERO:
		if _prev_move_dir == Vector2.ZERO:
			move_dir = Vector2.RIGHT
		else:
			move_dir = _prev_move_dir

	if move_dir != Vector2.ZERO:
		_prev_move_dir = move_dir

	# Get move speed
	var move_speed := FAST_MOVE_SPEED if _has_fast_mask else BASE_MOVE_SPEED

	velocity = move_dir * move_speed
	move_and_slide()

	for mask: Mask in _equipped_masks:
		mask.global_position = global_position + MASK_OFFSET


func has_mask_of_type(lock_type: Mask.MaskType) -> bool:
	for mask: Mask in _equipped_masks:
		if mask.mask_type == lock_type:
			return true
	return false


func _equip_mask(mask: Mask):
	_equipped_masks.push_back(mask)
	mask.is_equipped = true
	mask.get_parent().move_child(mask, mask.get_parent().get_child_count() - 1)

	match mask.mask_type:
		Mask.MaskType.DIAG:
			_has_diag_mask = true
		Mask.MaskType.FAST:
			_has_fast_mask = true
		Mask.MaskType.INFINITE:
			_has_infinite_mask = true


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
