extends Node2D

const PLAYFIELD := Rect2(Vector2(480, 180), Vector2(960, 720))
const PLAYER_RADIUS := 18.0
const ENEMY_RADIUS := 22.0
const BULLET_RADIUS := 6.0
const PLAYER_SPEED := 420.0
const FOCUS_SPEED := 230.0
const FIRE_INTERVAL := 0.11
const ENEMY_SPAWN_INTERVAL := 0.9
const ENEMY_BULLET_INTERVAL := 1.4

var game_state := "title"
var player_pos := Vector2.ZERO
var player_fire_timer := 0.0
var spawn_timer := 0.0
var stage_time := 0.0
var score := 0
var combo := 0
var lives := 3
var shields := 1
var invuln_timer := 0.0
var paused := false
var bullets: Array[Dictionary] = []
var enemies: Array[Dictionary] = []
var enemy_bullets: Array[Dictionary] = []
var rng := RandomNumberGenerator.new()
var hud_layer: CanvasLayer
var title_label: Label
var subtitle_label: Label
var hud_label: Label
var status_label: Label

func _ready() -> void:
	rng.randomize()
	_ensure_input_map()
	_setup_ui()
	_reset_run()
	set_process(true)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause_game") and game_state == "playing":
		paused = not paused
		status_label.text = "PAUSED" if paused else ""

	if Input.is_action_just_pressed("start_game"):
		if game_state == "title" or game_state == "game_over":
			_start_game()
		elif game_state == "level_clear":
			_show_title()

	if game_state != "playing" or paused:
		queue_redraw()
		return

	stage_time += delta
	invuln_timer = maxf(invuln_timer - delta, 0.0)
	_update_player(delta)
	_update_player_fire(delta)
	_update_enemy_spawning(delta)
	_update_bullets(delta)
	_update_enemies(delta)
	_update_enemy_bullets(delta)
	_update_collisions()
	_update_hud()

	if stage_time >= 90.0:
		_level_clear()

	queue_redraw()


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, get_viewport_rect().size), Color("#07101e"))
	_draw_side_panels()
	_draw_playfield()
	_draw_stars()

	for bullet in bullets:
		var bullet_position: Vector2 = bullet["position"]
		draw_circle(bullet_position, BULLET_RADIUS, Color("#8ff6ff"))
		draw_circle(bullet_position + Vector2(0, 8), BULLET_RADIUS * 0.5, Color("#f8f0a8"))

	for enemy_bullet in enemy_bullets:
		var enemy_bullet_position: Vector2 = enemy_bullet["position"]
		draw_circle(enemy_bullet_position, 8.0, Color("#ff5d78"))
		draw_arc(enemy_bullet_position, 13.0, 0.0, TAU, 20, Color("#ffd166"), 2.0)

	for enemy in enemies:
		_draw_enemy(enemy)

	if game_state == "playing" or game_state == "level_clear":
		_draw_player()


func _setup_ui() -> void:
	hud_layer = CanvasLayer.new()
	add_child(hud_layer)

	title_label = _make_label(Vector2(0, 335), Vector2(1920, 86), 64, HORIZONTAL_ALIGNMENT_CENTER)
	subtitle_label = _make_label(Vector2(0, 432), Vector2(1920, 80), 26, HORIZONTAL_ALIGNMENT_CENTER)
	hud_label = _make_label(Vector2(35, 32), Vector2(1850, 48), 24, HORIZONTAL_ALIGNMENT_LEFT)
	status_label = _make_label(Vector2(0, 510), Vector2(1920, 72), 34, HORIZONTAL_ALIGNMENT_CENTER)

	hud_layer.add_child(title_label)
	hud_layer.add_child(subtitle_label)
	hud_layer.add_child(hud_label)
	hud_layer.add_child(status_label)
	_show_title()


func _make_label(pos: Vector2, size: Vector2, font_size: int, align: HorizontalAlignment) -> Label:
	var label := Label.new()
	label.position = pos
	label.size = size
	label.horizontal_alignment = align
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", Color("#e8f7ff"))
	label.add_theme_color_override("font_shadow_color", Color("#08111f"))
	label.add_theme_constant_override("shadow_offset_x", 3)
	label.add_theme_constant_override("shadow_offset_y", 3)
	return label


func _show_title() -> void:
	game_state = "title"
	paused = false
	title_label.text = "ARC FRAME X"
	subtitle_label.text = "Press Enter or Start"
	status_label.text = "WASD/Arrows move  |  Space/A fires  |  Shift or F focuses"
	hud_label.text = ""
	queue_redraw()


func _start_game() -> void:
	_reset_run()
	game_state = "playing"
	title_label.text = ""
	subtitle_label.text = ""
	status_label.text = ""
	_update_hud()


func _reset_run() -> void:
	player_pos = PLAYFIELD.position + Vector2(PLAYFIELD.size.x * 0.5, PLAYFIELD.size.y - 92.0)
	player_fire_timer = 0.0
	spawn_timer = 0.0
	stage_time = 0.0
	score = 0
	combo = 0
	lives = 3
	shields = 1
	invuln_timer = 0.0
	paused = false
	bullets.clear()
	enemies.clear()
	enemy_bullets.clear()


func _update_player(delta: float) -> void:
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var speed := FOCUS_SPEED if Input.is_action_pressed("focus") else PLAYER_SPEED
	player_pos += input_vector * speed * delta
	player_pos.x = clampf(player_pos.x, PLAYFIELD.position.x + PLAYER_RADIUS, PLAYFIELD.end.x - PLAYER_RADIUS)
	player_pos.y = clampf(player_pos.y, PLAYFIELD.position.y + PLAYER_RADIUS, PLAYFIELD.end.y - PLAYER_RADIUS)


func _update_player_fire(delta: float) -> void:
	player_fire_timer -= delta
	if Input.is_action_pressed("fire") and player_fire_timer <= 0.0:
		player_fire_timer = FIRE_INTERVAL
		bullets.append({"position": player_pos + Vector2(-10, -24), "velocity": Vector2(0, -900), "damage": 1})
		bullets.append({"position": player_pos + Vector2(10, -24), "velocity": Vector2(0, -900), "damage": 1})


func _update_enemy_spawning(delta: float) -> void:
	spawn_timer -= delta
	if spawn_timer > 0.0:
		return

	spawn_timer = maxf(0.35, ENEMY_SPAWN_INTERVAL - stage_time * 0.006)
	var lane_x := rng.randf_range(PLAYFIELD.position.x + 80.0, PLAYFIELD.end.x - 80.0)
	var enemy_type := "choir_drone"
	if int(stage_time) % 11 > 7:
		enemy_type = "needle_runner"
	enemies.append({
		"position": Vector2(lane_x, PLAYFIELD.position.y - 35.0),
		"velocity": Vector2(rng.randf_range(-35.0, 35.0), 105.0 + stage_time * 1.5),
		"health": 2 if enemy_type == "needle_runner" else 3,
		"type": enemy_type,
		"fire_timer": rng.randf_range(0.4, ENEMY_BULLET_INTERVAL),
		"wobble": rng.randf_range(0.0, TAU)
	})


func _update_bullets(delta: float) -> void:
	for bullet in bullets:
		var bullet_position: Vector2 = bullet["position"]
		var bullet_velocity: Vector2 = bullet["velocity"]
		bullet_position += bullet_velocity * delta
		bullet["position"] = bullet_position
	bullets = bullets.filter(_is_player_bullet_active)


func _update_enemies(delta: float) -> void:
	for enemy in enemies:
		var wobble: float = enemy["wobble"] + delta * 3.0
		var enemy_position: Vector2 = enemy["position"]
		var enemy_velocity: Vector2 = enemy["velocity"]
		enemy_position += enemy_velocity * delta
		enemy_position.x += sin(wobble) * 32.0 * delta
		enemy["wobble"] = wobble
		enemy["position"] = enemy_position
		enemy["fire_timer"] = float(enemy["fire_timer"]) - delta
		if float(enemy["fire_timer"]) <= 0.0 and PLAYFIELD.has_point(enemy_position):
			enemy["fire_timer"] = ENEMY_BULLET_INTERVAL
			var to_player: Vector2 = (player_pos - enemy_position).normalized()
			enemy_bullets.append({"position": enemy_position + Vector2(0, 20), "velocity": to_player * 260.0})
	enemies = enemies.filter(_is_enemy_active)


func _update_enemy_bullets(delta: float) -> void:
	for enemy_bullet in enemy_bullets:
		var bullet_position: Vector2 = enemy_bullet["position"]
		var bullet_velocity: Vector2 = enemy_bullet["velocity"]
		bullet_position += bullet_velocity * delta
		enemy_bullet["position"] = bullet_position
	enemy_bullets = enemy_bullets.filter(_is_enemy_bullet_active)


func _update_collisions() -> void:
	for enemy in enemies:
		for bullet in bullets:
			var enemy_position: Vector2 = enemy["position"]
			var bullet_position: Vector2 = bullet["position"]
			if enemy_position.distance_to(bullet_position) <= ENEMY_RADIUS + BULLET_RADIUS:
				enemy["health"] = int(enemy["health"]) - int(bullet["damage"])
				bullet["position"] = Vector2(bullet_position.x, -9999.0)
				if int(enemy["health"]) <= 0:
					score += 100 + combo * 10
					combo += 1

	bullets = bullets.filter(_is_player_bullet_active)

	if invuln_timer > 0.0:
		return

	for enemy in enemies:
		var enemy_position: Vector2 = enemy["position"]
		if player_pos.distance_to(enemy_position) <= PLAYER_RADIUS + ENEMY_RADIUS:
			_damage_player()
			enemy["health"] = 0
			return

	for enemy_bullet in enemy_bullets:
		var enemy_bullet_position: Vector2 = enemy_bullet["position"]
		if player_pos.distance_to(enemy_bullet_position) <= PLAYER_RADIUS + 8.0:
			_damage_player()
			enemy_bullet["position"] = Vector2(enemy_bullet_position.x, PLAYFIELD.end.y + 999.0)
			return


func _damage_player() -> void:
	invuln_timer = 2.0
	combo = 0
	if shields > 0:
		shields -= 1
		return

	lives -= 1
	if lives <= 0:
		_game_over()
		return

	shields = 1
	player_pos = PLAYFIELD.position + Vector2(PLAYFIELD.size.x * 0.5, PLAYFIELD.size.y - 92.0)
	enemy_bullets.clear()


func _game_over() -> void:
	game_state = "game_over"
	title_label.text = "GAME OVER"
	subtitle_label.text = "Press Enter or Start to retry"
	status_label.text = "Score: %d" % score


func _level_clear() -> void:
	game_state = "level_clear"
	title_label.text = "SKY ARC BREACH CLEAR"
	subtitle_label.text = "Prototype route complete"
	status_label.text = "Score: %d  |  Press Enter or Start" % score
	enemies.clear()
	enemy_bullets.clear()


func _update_hud() -> void:
	hud_label.text = "LIVES %d   SHIELD %d   SCORE %06d   COMBO x%d   TIME %02d" % [maxi(lives, 0), shields, score, combo, int(stage_time)]


func _is_player_bullet_active(bullet: Dictionary) -> bool:
	var bullet_position: Vector2 = bullet["position"]
	return bullet_position.y > PLAYFIELD.position.y - 40.0


func _is_enemy_active(enemy: Dictionary) -> bool:
	var enemy_position: Vector2 = enemy["position"]
	return enemy_position.y < PLAYFIELD.end.y + 60.0 and int(enemy["health"]) > 0


func _is_enemy_bullet_active(enemy_bullet: Dictionary) -> bool:
	var bullet_position: Vector2 = enemy_bullet["position"]
	return PLAYFIELD.grow(60.0).has_point(bullet_position)


func _ensure_input_map() -> void:
	_add_key_action("move_left", [KEY_A, KEY_LEFT])
	_add_key_action("move_right", [KEY_D, KEY_RIGHT])
	_add_key_action("move_up", [KEY_W, KEY_UP])
	_add_key_action("move_down", [KEY_S, KEY_DOWN])
	_add_key_action("fire", [KEY_SPACE])
	_add_key_action("focus", [KEY_SHIFT, KEY_F])
	_add_key_action("start_game", [KEY_ENTER])
	_add_key_action("pause_game", [KEY_ESCAPE])


func _add_key_action(action_name: StringName, keycodes: Array[int]) -> void:
	if not InputMap.has_action(action_name):
		InputMap.add_action(action_name)
	for keycode in keycodes:
		var has_key := false
		for event in InputMap.action_get_events(action_name):
			if event is InputEventKey and event.keycode == keycode:
				has_key = true
				break
		if not has_key:
			var key_event := InputEventKey.new()
			key_event.keycode = keycode
			InputMap.action_add_event(action_name, key_event)


func _draw_side_panels() -> void:
	draw_rect(Rect2(Vector2(0, 0), Vector2(PLAYFIELD.position.x, 1080)), Color("#111827"))
	draw_rect(Rect2(Vector2(PLAYFIELD.end.x, 0), Vector2(1920 - PLAYFIELD.end.x, 1080)), Color("#111827"))
	draw_line(Vector2(PLAYFIELD.position.x, 0), Vector2(PLAYFIELD.position.x, 1080), Color("#35c7ff"), 2.0)
	draw_line(Vector2(PLAYFIELD.end.x, 0), Vector2(PLAYFIELD.end.x, 1080), Color("#35c7ff"), 2.0)


func _draw_playfield() -> void:
	draw_rect(PLAYFIELD, Color("#0b1730"))
	for i in range(10):
		var y := PLAYFIELD.position.y + fmod(stage_time * 70.0 + i * 90.0, PLAYFIELD.size.y)
		draw_line(Vector2(PLAYFIELD.position.x, y), Vector2(PLAYFIELD.end.x, y), Color(0.1, 0.85, 1.0, 0.18), 1.0)
	draw_rect(PLAYFIELD, Color("#7df9ff"), false, 3.0)


func _draw_stars() -> void:
	for i in range(70):
		var x := PLAYFIELD.position.x + fmod(float(i * 137), PLAYFIELD.size.x)
		var y := PLAYFIELD.position.y + fmod(float(i * 71) + stage_time * (20.0 + float(i % 4) * 18.0), PLAYFIELD.size.y)
		draw_circle(Vector2(x, y), 1.5 + float(i % 3), Color(0.55, 0.9, 1.0, 0.35))


func _draw_player() -> void:
	if invuln_timer > 0.0 and int(invuln_timer * 12.0) % 2 == 0:
		return

	var input_x := Input.get_axis("move_left", "move_right")
	var lean := input_x * 7.0
	var hull := PackedVector2Array([
		player_pos + Vector2(0 + lean, -34),
		player_pos + Vector2(28 + lean, 22),
		player_pos + Vector2(8, 14),
		player_pos + Vector2(0, 32),
		player_pos + Vector2(-8, 14),
		player_pos + Vector2(-28 + lean, 22)
	])
	var hull_outline := PackedVector2Array(hull)
	hull_outline.append(hull[0])
	draw_colored_polygon(hull, Color("#35c7ff"))
	draw_polyline(hull_outline, Color("#e8f7ff"), 2.0)
	draw_circle(player_pos + Vector2(0, 2), 8.0, Color("#f7d36b"))
	draw_circle(player_pos + Vector2(0, 39), 10.0 + sin(stage_time * 18.0) * 2.0, Color("#ff7a33"))


func _draw_enemy(enemy: Dictionary) -> void:
	var enemy_type: String = enemy["type"]
	var color := Color("#ff5d78") if enemy_type == "needle_runner" else Color("#b26dff")
	var center: Vector2 = enemy["position"]
	var body := PackedVector2Array([
		center + Vector2(0, 28),
		center + Vector2(25, -5),
		center + Vector2(12, -24),
		center + Vector2(0, -14),
		center + Vector2(-12, -24),
		center + Vector2(-25, -5)
	])
	var body_outline := PackedVector2Array(body)
	body_outline.append(body[0])
	draw_colored_polygon(body, color)
	draw_polyline(body_outline, Color("#ffe6f1"), 2.0)
	draw_circle(center, 7.0, Color("#ffd166"))
