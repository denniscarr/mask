class_name Level
extends Node2D

signal win(money_earned: int)
signal request_restart

enum State { START, GAMEPLAY, DEATH, WIN }

@export var _player: Player
@export var _goal: Goal
@export var _win_screen: WinScreen

var _state: State = State.START


func _ready() -> void:
	_goal.collected.connect(_on_goal_collected)
	_player.died.connect(_on_player_died)


func start():
	_state = State.GAMEPLAY


func _do_win(money: int):
	await _win_screen.do_animation(money)
	await get_tree().create_timer(0.6).timeout
	win.emit(money)


func _on_goal_collected(money: int):
	if _state != State.WIN:
		_player.movement_enabled = false
		_state = State.WIN
		_do_win(money)


func _on_player_died():
	request_restart.emit()
