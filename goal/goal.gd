class_name Goal
extends Area2D


signal collected


var _is_collected: bool = false


func _ready() -> void:
    area_entered.connect(_on_area_entered)


func _collect():
    visible = false
    collected.emit()
    _is_collected = true


func _on_area_entered(area: Area2D):
    if not _is_collected and area.get_parent() is Player:
        _collect()