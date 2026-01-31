class_name Level
extends Node2D

signal win(money_earned: int)
signal request_restart

enum State { START, GAMEPLAY, DEATH, WIN }

const SCREEN_SIZE: Vector2 = Vector2(800, 600)

@export var _player: Player
@export var _goal: Goal
@export var _win_screen: WinScreen
@export var _bg_tex: TextureRect
@export var _cam: Camera2D

var _state: State = State.START


func _ready() -> void:
	_goal.collected.connect(_on_goal_collected)
	_player.died.connect(_on_player_died)


func _physics_process(_delta: float) -> void:
	if _state == State.GAMEPLAY:
		if _player and not _player.is_queued_for_deletion():
			_cam.global_position.x = _player.global_position.x - SCREEN_SIZE.x / 2
			_cam.global_position.y = _player.global_position.y - SCREEN_SIZE.y / 2


func start():
	_cam.limit_right = int(_bg_tex.size.x - SCREEN_SIZE.x)
	_cam.limit_bottom = int(_bg_tex.size.y - SCREEN_SIZE.y)
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
