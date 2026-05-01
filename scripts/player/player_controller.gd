extends RefCounted

const PLAYER_SPEED := 420.0
const FOCUS_SPEED := 230.0
const FIRE_INTERVAL := 0.11
const CHARGE_TIME := 1.2

var position := Vector2.ZERO
var lives := 3
var shields := 1
var bombs := 3
var invuln_timer := 0.0
var charge_timer := 0.0
var fire_timer := 0.0
var was_fire_pressed := false


func reset(playfield: Rect2) -> void:
	position = _spawn_position(playfield)
	lives = 3
	shields = 1
	bombs = 3
	invuln_timer = 0.0
	charge_timer = 0.0
	fire_timer = 0.0
	was_fire_pressed = false


func update(delta: float, playfield: Rect2, player_radius: float, game_active: bool) -> Dictionary:
	invuln_timer = maxf(invuln_timer - delta, 0.0)
	if not game_active:
		return {"shots": [], "charge_released": false, "bomb_requested": false}

	_update_movement(delta, playfield, player_radius)
	return _update_actions(delta)


func damage(playfield: Rect2) -> Dictionary:
	invuln_timer = 2.0
	if shields > 0:
		shields -= 1
		return {"dead": false, "respawned": false, "game_over": false}

	lives -= 1
	if lives <= 0:
		return {"dead": true, "respawned": false, "game_over": true}

	shields = 1
	position = _spawn_position(playfield)
	return {"dead": true, "respawned": true, "game_over": false}


func consume_bomb() -> bool:
	if bombs <= 0:
		return false
	bombs -= 1
	return true


func charge_percent() -> int:
	return int((charge_timer / CHARGE_TIME) * 100.0)


func _update_movement(delta: float, playfield: Rect2, player_radius: float) -> void:
	var input_vector: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var speed: float = FOCUS_SPEED if Input.is_action_pressed("focus") else PLAYER_SPEED
	position += input_vector * speed * delta
	position.x = clampf(position.x, playfield.position.x + player_radius, playfield.end.x - player_radius)
	position.y = clampf(position.y, playfield.position.y + player_radius, playfield.end.y - player_radius)


func _update_actions(delta: float) -> Dictionary:
	var shots: Array[Dictionary] = []
	var charge_released := false
	var fire_pressed: bool = Input.is_action_pressed("fire")

	fire_timer -= delta
	if fire_pressed:
		charge_timer = minf(charge_timer + delta, CHARGE_TIME)
	else:
		if was_fire_pressed and charge_timer >= CHARGE_TIME:
			charge_released = true
		charge_timer = 0.0

	if fire_pressed and fire_timer <= 0.0:
		fire_timer = FIRE_INTERVAL
		shots.append({"position": position + Vector2(-10, -24), "velocity": Vector2(0, -900), "damage": 1})
		shots.append({"position": position + Vector2(10, -24), "velocity": Vector2(0, -900), "damage": 1})

	was_fire_pressed = fire_pressed
	return {
		"shots": shots,
		"charge_released": charge_released,
		"bomb_requested": Input.is_action_just_pressed("bomb")
	}


func _spawn_position(playfield: Rect2) -> Vector2:
	return playfield.position + Vector2(playfield.size.x * 0.5, playfield.size.y - 92.0)
