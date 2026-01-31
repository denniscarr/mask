class_name Goal
extends Area2D

signal collected(money: int)


@export var _total_lifetime = 30.0
@export var _grace_period = 8.0
@export var _max_value = 100
@export var _min_value = 1
@export var _min_scale = 0.1
@export var _value_label: Label


var _is_collected: bool = false
var _value: int = 100
var _timer: float


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	_timer = _total_lifetime
	_value = _max_value
	_value_label.text = "$%s" % _value


func _process(delta: float) -> void:
	_timer -= delta
	_timer = max(0, _timer)
	if _timer < _total_lifetime - _grace_period:
		var t := inverse_lerp(0, _total_lifetime - _grace_period, _timer)
		_value = ceili(lerp(_min_value, _max_value, t))
		_value_label.text = "$%s" % _value
		scale = Vector2.ONE * lerp(_min_scale, 1.0, t)


func _collect():
	visible = false
	collected.emit()
	_is_collected = true


func _on_area_entered(area: Area2D):
	if not _is_collected and area.get_parent() is Player:
		_collect()
