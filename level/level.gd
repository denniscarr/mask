class_name Level
extends Node2D

signal win
signal request_restart

enum State {
	START, GAMEPLAY, DEATH, WIN
}

@export var _player: Player
@export var _goal: Goal

var _state: State = State.START


func _ready() -> void:
	_goal.collected.connect(_on_goal_collected)
	_player.died.connect(_on_player_died)


func start():
	_state = State.GAMEPLAY


func _on_goal_collected():
	if _state != State.WIN:
		win.emit()
		_state = State.WIN


func _on_player_died():
	request_restart.emit()
