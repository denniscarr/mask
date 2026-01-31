class_name WinScreen
extends Control

@export var _money_label: Label


func _ready() -> void:
	modulate.a = 0.0
	scale = Vector2.ONE * 0.1


func do_animation(money: int):
	visible = true

	_money_label.text = "$%s" % money

	var tween := create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, 0.8)
	tween.parallel().tween_property(self, "modulate:a", 1.0, 0.8)

	await tween.finished
