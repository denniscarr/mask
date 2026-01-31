extends Node

@export var _levels: Array[PackedScene]

var _current_level: Level
var _current_level_index: int = 0


func _ready() -> void:
	_load_level(0)


func _restart_level():
	_load_level(_current_level_index)


func _load_level(index: int):
	if _current_level:
		_current_level.queue_free()

	var new_level_scene := _levels[index]
	var new_level := new_level_scene.instantiate() as Level
	add_child(new_level)
	_current_level = new_level

	_current_level.request_restart.connect(_on_level_request_restart)
	_current_level.win.connect(_on_level_win)


func _on_level_request_restart():
	_load_level(_current_level_index)


func _on_level_win():
	_current_level_index += 1
	_current_level_index = mini(_current_level_index, _levels.size() - 1)
	_load_level(_current_level_index)
