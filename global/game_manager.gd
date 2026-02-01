extends Node

@export var _levels: Array[PackedScene]

@export_category("Node References")
@export var _money_label: Label
@export var _game_finish_screen: WinScreen

var _current_level: Level
var _current_level_index: int = 0
var _player_money: int = 0
var _game_finished: bool = false


func _ready() -> void:
	_load_level(0)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		if _game_finished:
			get_tree().reload_current_scene()
		# else:
		# 	_current_level_index += 1
		# 	_current_level_index = mini(_current_level_index, _levels.size() - 1)

		# 	if _current_level_index > _levels.size() - 1:
		# 		_do_game_finish()
		# 	else:
		# 		_load_level(_current_level_index)


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


func _do_game_finish():
	await _game_finish_screen.do_animation(_player_money)
	await get_tree().create_timer(1.0).timeout
	_game_finished = true


func _on_level_request_restart():
	_load_level(_current_level_index)


func _on_level_win(money_earned: int):
	_player_money += money_earned
	_money_label.text = "You have $%s" % _player_money

	_current_level_index += 1
	_current_level_index = mini(_current_level_index, _levels.size() - 1)

	if _current_level_index > _levels.size() - 1:
		_do_game_finish()
	else:
		_load_level(_current_level_index)
