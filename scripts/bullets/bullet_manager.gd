extends RefCounted

const CHARGE_LASER_DURATION := 0.22

var player_bullets: Array[Dictionary] = []
var enemy_bullets: Array[Dictionary] = []
var charged_lasers: Array[Dictionary] = []


func reset() -> void:
	player_bullets.clear()
	enemy_bullets.clear()
	charged_lasers.clear()


func add_player_shot(shot: Dictionary) -> void:
	player_bullets.append(shot)


func add_enemy_bullet(bullet: Dictionary) -> void:
	enemy_bullets.append(bullet)


func add_charged_laser(laser: Dictionary) -> void:
	charged_lasers.append(laser)


func clear_player_bullets() -> void:
	player_bullets.clear()


func clear_enemy_bullets() -> void:
	enemy_bullets.clear()


func update(delta: float, playfield: Rect2) -> void:
	_update_player_bullets(delta, playfield)
	_update_charged_lasers(delta)
	_update_enemy_bullets(delta, playfield)


func mark_player_bullet_spent(bullet: Dictionary) -> void:
	var bullet_position: Vector2 = bullet["position"]
	bullet["position"] = Vector2(bullet_position.x, -9999.0)


func mark_enemy_bullet_spent(enemy_bullet: Dictionary, playfield: Rect2) -> void:
	var bullet_position: Vector2 = enemy_bullet["position"]
	enemy_bullet["position"] = Vector2(bullet_position.x, playfield.end.y + 999.0)


func prune_player_bullets(playfield: Rect2) -> void:
	player_bullets = player_bullets.filter(func(bullet: Dictionary) -> bool:
		var bullet_position: Vector2 = bullet["position"]
		return bullet_position.y > playfield.position.y - 40.0
	)


func draw(canvas: CanvasItem) -> void:
	for bullet in player_bullets:
		var bullet_position: Vector2 = bullet["position"]
		_draw_player_bullet(canvas, bullet_position)

	for enemy_bullet in enemy_bullets:
		var enemy_bullet_position: Vector2 = enemy_bullet["position"]
		_draw_enemy_bullet(canvas, enemy_bullet_position)

	for laser in charged_lasers:
		_draw_charged_laser(canvas, laser)


func _update_player_bullets(delta: float, playfield: Rect2) -> void:
	for bullet in player_bullets:
		var bullet_position: Vector2 = bullet["position"]
		var bullet_velocity: Vector2 = bullet["velocity"]
		bullet_position += bullet_velocity * delta
		bullet["position"] = bullet_position
	prune_player_bullets(playfield)


func _update_charged_lasers(delta: float) -> void:
	for laser in charged_lasers:
		laser["age"] = float(laser["age"]) + delta
		laser["ttl"] = float(laser["ttl"]) - delta
	charged_lasers = charged_lasers.filter(func(laser: Dictionary) -> bool: return float(laser["ttl"]) > 0.0)


func _update_enemy_bullets(delta: float, playfield: Rect2) -> void:
	for enemy_bullet in enemy_bullets:
		var bullet_position: Vector2 = enemy_bullet["position"]
		var bullet_velocity: Vector2 = enemy_bullet["velocity"]
		bullet_position += bullet_velocity * delta
		enemy_bullet["position"] = bullet_position
	enemy_bullets = enemy_bullets.filter(func(enemy_bullet: Dictionary) -> bool:
		var bullet_position: Vector2 = enemy_bullet["position"]
		return playfield.grow(60.0).has_point(bullet_position)
	)


func _draw_player_bullet(canvas: CanvasItem, pos: Vector2) -> void:
	var snapped := _pixel_snap(pos)
	canvas.draw_rect(Rect2(snapped + Vector2(-6, -20), Vector2(12, 38)), Color(0.0, 0.45, 1.0, 0.22))
	canvas.draw_rect(Rect2(snapped + Vector2(-3, -18), Vector2(6, 34)), Color("#00a5ff"))
	canvas.draw_rect(Rect2(snapped + Vector2(-1, -16), Vector2(2, 30)), Color("#e8f7ff"))


func _draw_enemy_bullet(canvas: CanvasItem, pos: Vector2) -> void:
	var snapped := _pixel_snap(pos)
	canvas.draw_circle(snapped, 10.0, Color("#ff2f80"))
	canvas.draw_circle(snapped, 5.0, Color("#ffd166"))
	canvas.draw_arc(snapped, 15.0, 0.0, TAU, 16, Color(1.0, 0.2, 0.55, 0.65), 3.0)


func _draw_charged_laser(canvas: CanvasItem, laser: Dictionary) -> void:
	var x: float = laser["x"]
	var top_y: float = laser["top_y"]
	var bottom_y: float = laser["bottom_y"]
	var width: float = laser["width"]
	var alpha := clampf(float(laser["ttl"]) / CHARGE_LASER_DURATION, 0.0, 1.0)
	var rect := Rect2(Vector2(x - width * 0.5, top_y), Vector2(width, bottom_y - top_y))
	canvas.draw_rect(rect.grow(14.0), Color(0.1, 0.85, 1.0, 0.16 * alpha))
	canvas.draw_rect(rect, Color(0.65, 0.98, 1.0, 0.55 * alpha))
	canvas.draw_line(Vector2(x, top_y), Vector2(x, bottom_y), Color(1.0, 1.0, 1.0, 0.88 * alpha), 7.0)


func _pixel_snap(pos: Vector2) -> Vector2:
	return Vector2(roundf(pos.x / 2.0) * 2.0, roundf(pos.y / 2.0) * 2.0)
