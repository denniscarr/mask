@tool
class_name Level
extends Node2D

signal win(money_earned: int)
signal request_restart

enum State { START, GAMEPLAY, DEATH, WIN }

const SCREEN_SIZE: Vector2 = Vector2(800, 600)

@export_category("Level Size")
@export var _size_x: float = 800.0
@export var _size_y: float = 600.0
@export_tool_button("Update Size", "Callable") var _update_action = _update_size

@export_category("Node Refs (Don't change)")
@export var _player: Player
@export var _goal: Goal
@export var _win_screen: WinScreen
@export var _bg_tex: TextureRect
@export var _cam: Camera2D
@export var _wall_n: Wall
@export var _wall_s: Wall
@export var _wall_w: Wall
@export var _wall_e: Wall

var _state: State = State.START


func _ready() -> void:
	_update_size()

	if Engine.is_editor_hint():
		return

	_goal.collected.connect(_on_goal_collected)
	_player.died.connect(_on_player_died)

	_cam.limit_right = int(_bg_tex.size.x - SCREEN_SIZE.x)
	_cam.limit_bottom = int(_bg_tex.size.y - SCREEN_SIZE.y)
	_state = State.GAMEPLAY


func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return

	if _state == State.GAMEPLAY:
		if _player and not _player.is_queued_for_deletion():
			_cam.global_position.x = _player.global_position.x - SCREEN_SIZE.x / 2
			_cam.global_position.y = _player.global_position.y - SCREEN_SIZE.y / 2


func _update_size():
	_bg_tex.size.x = _size_x
	_bg_tex.size.y = _size_y

	_wall_n.position.x = _size_x * 0.5
	_wall_n.position.y = 0
	_wall_n.set_length(_size_x, true)

	_wall_s.position.x = _size_x * 0.5
	_wall_s.position.y = _size_y
	_wall_s.set_length(_size_x, true)

	_wall_e.position.x = _size_x
	_wall_e.position.y = _size_y * 0.5
	_wall_e.set_length(_size_y)

	_wall_w.position.x = 0
	_wall_w.position.y = _size_y * 0.5
	_wall_w.set_length(_size_y)


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
