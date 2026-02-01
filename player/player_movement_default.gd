class_name PlayerMovementDefault
extends PlayerMovement


func physics_step(_delta: float):
	_player.velocity = Vector2.ZERO

	if Input.is_action_pressed("left"):
		_player.velocity.x = -1
	elif Input.is_action_pressed("right"):
		_player.velocity.x = 1
	elif Input.is_action_pressed("up"):
		_player.velocity.y = -1
	elif Input.is_action_pressed("down"):
		_player.velocity.y = 1
