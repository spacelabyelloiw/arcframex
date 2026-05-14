extends Node2D

const PLAYFIELD := Rect2(Vector2(240, 0), Vector2(1440, 1080))
const PLAYER_RADIUS := 18.0
const ENEMY_RADIUS := 22.0
const BULLET_RADIUS := 6.0
const ENEMY_SPAWN_INTERVAL := 0.9
const ENEMY_BULLET_INTERVAL := 1.4
const BOSS_TRIGGER_TIME := 45.0
const BOSS_MAX_HEALTH := 220
const BOSS_RADIUS := 62.0
const CHARGE_TIME := 1.2
const CHARGE_LASER_DURATION := 0.22
const CHARGE_LASER_WIDTH := 52.0
const BACKGROUND_SCROLL_SPEED := 154.0
const HIT_FLASH_TIME := 0.11

var player_texture: Texture2D = preload("res://assets/art/player/spr_player_ship_base.png")
var player_bank_left_1_texture: Texture2D
var player_bank_left_2_texture: Texture2D
var player_bank_right_1_texture: Texture2D
var player_bank_right_2_texture: Texture2D
var choir_drone_texture: Texture2D = preload("res://assets/art/enemies/spr_choir_drone.png")
var needle_runner_texture: Texture2D = preload("res://assets/art/enemies/spr_needle_runner.png")
var boss_texture: Texture2D = preload("res://assets/art/bosses/spr_null_relay_seraph.png")
var sky_arc_background_texture: Texture2D = preload("res://assets/art/backgrounds/bg_sky_arc_breach.png")
var explosion_frame_textures: Array[Texture2D] = [
	preload("res://assets/art/vfx/explosion_flame_00.png"),
	preload("res://assets/art/vfx/explosion_flame_01.png"),
	preload("res://assets/art/vfx/explosion_flame_02.png"),
	preload("res://assets/art/vfx/explosion_flame_03.png"),
	preload("res://assets/art/vfx/explosion_flame_04.png"),
	preload("res://assets/art/vfx/explosion_flame_05.png")
]
var audio_manager_script: Script = preload("res://scripts/managers/audio_manager.gd")
var hud_renderer_script: Script = preload("res://scripts/ui/hud_renderer.gd")
var player_controller_script: Script = preload("res://scripts/player/player_controller.gd")
var bullet_manager_script: Script = preload("res://scripts/bullets/bullet_manager.gd")

var game_state := "title"
var spawn_timer := 0.0
var stage_time := 0.0
var score := 0
var combo := 0
var paused := false
var bomb_flash_timer := 0.0
var shake_timer := 0.0
var shake_strength := 0.0
var draw_shake_offset := Vector2.ZERO
var boss_hit_flash := 0.0
var boss_started := false
var boss_active := false
var boss_intro_timer := 0.0
var boss_pos := Vector2.ZERO
var boss_health := BOSS_MAX_HEALTH
var boss_fire_timer := 0.0
var boss_weave := 0.0
var enemies: Array[Dictionary] = []
var effects: Array[Dictionary] = []
var rng := RandomNumberGenerator.new()
var audio_manager
var hud_renderer
var player_controller
var bullet_manager
var hud_layer: CanvasLayer
var title_label: Label
var subtitle_label: Label
var hud_label: Label
var status_label: Label

func _ready() -> void:
	rng.randomize()
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	hud_renderer = hud_renderer_script.new()
	player_controller = player_controller_script.new()
	bullet_manager = bullet_manager_script.new()
	_load_player_bank_textures()
	_ensure_input_map()
	_setup_audio()
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
	bomb_flash_timer = maxf(bomb_flash_timer - delta, 0.0)
	shake_timer = maxf(shake_timer - delta, 0.0)
	boss_hit_flash = maxf(boss_hit_flash - delta, 0.0)
	var player_events: Dictionary = player_controller.update(delta, PLAYFIELD, PLAYER_RADIUS, true)
	_apply_player_events(player_events)
	if boss_started:
		_update_boss(delta)
	else:
		_update_enemy_spawning(delta)
	bullet_manager.update(delta, PLAYFIELD)
	_update_enemies(delta)
	_update_effects(delta)
	_update_collisions()
	_update_hud()

	if stage_time >= BOSS_TRIGGER_TIME and not boss_started:
		_start_boss()

	queue_redraw()


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, get_viewport_rect().size), Color("#07101e"))
	draw_shake_offset = _get_shake_offset()
	draw_set_transform(draw_shake_offset, 0.0, Vector2.ONE)
	_draw_playfield()
	_draw_stars()

	bullet_manager.draw(self)

	for enemy in enemies:
		_draw_enemy(enemy)

	if boss_started:
		_draw_boss()

	if game_state == "playing" or game_state == "level_clear":
		_draw_player()

	for effect in effects:
		_draw_effect(effect)

	if bomb_flash_timer > 0.0:
		var alpha := minf(bomb_flash_timer * 3.0, 0.32)
		draw_rect(PLAYFIELD, Color(0.3, 0.9, 1.0, alpha))

	_draw_scanline_overlay()
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	_draw_side_panels()


func _setup_ui() -> void:
	hud_layer = CanvasLayer.new()
	add_child(hud_layer)

	title_label = _make_label(Vector2(0, 335), Vector2(1920, 86), 64, HORIZONTAL_ALIGNMENT_CENTER)
	subtitle_label = _make_label(Vector2(0, 432), Vector2(1920, 80), 26, HORIZONTAL_ALIGNMENT_CENTER)
	hud_label = _make_label(Vector2.ZERO, Vector2.ZERO, 24, HORIZONTAL_ALIGNMENT_LEFT)
	hud_label.visible = false
	status_label = _make_label(Vector2(0, 510), Vector2(1920, 72), 34, HORIZONTAL_ALIGNMENT_CENTER)

	hud_layer.add_child(title_label)
	hud_layer.add_child(subtitle_label)
	hud_layer.add_child(hud_label)
	hud_layer.add_child(status_label)
	_show_title()


func _setup_audio() -> void:
	audio_manager = audio_manager_script.new()
	add_child(audio_manager)


func _load_player_bank_textures() -> void:
	player_bank_left_1_texture = _load_image_texture("res://assets/art/player/spr_player_ship_bank_left_1.png")
	player_bank_left_2_texture = _load_image_texture("res://assets/art/player/spr_player_ship_bank_left_2.png")
	player_bank_right_1_texture = _load_image_texture("res://assets/art/player/spr_player_ship_bank_right_1.png")
	player_bank_right_2_texture = _load_image_texture("res://assets/art/player/spr_player_ship_bank_right_2.png")


func _load_image_texture(path: String) -> Texture2D:
	var image := Image.new()
	if image.load(path) != OK:
		return null
	return ImageTexture.create_from_image(image)


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
	player_controller.reset(PLAYFIELD)
	spawn_timer = 0.0
	stage_time = 0.0
	score = 0
	combo = 0
	paused = false
	bomb_flash_timer = 0.0
	shake_timer = 0.0
	shake_strength = 0.0
	boss_hit_flash = 0.0
	boss_started = false
	boss_active = false
	boss_intro_timer = 0.0
	boss_pos = Vector2(PLAYFIELD.position.x + PLAYFIELD.size.x * 0.5, PLAYFIELD.position.y + 130.0)
	boss_health = BOSS_MAX_HEALTH
	boss_fire_timer = 0.0
	boss_weave = 0.0
	bullet_manager.reset()
	enemies.clear()
	effects.clear()


func _apply_player_events(player_events: Dictionary) -> void:
	var shots: Array = player_events["shots"]
	for shot in shots:
		bullet_manager.add_player_shot(shot)
	if not shots.is_empty():
		_play_sfx("player_shot")
	if bool(player_events["charge_released"]):
		_fire_charged_laser()
	if bool(player_events["bomb_requested"]):
		_use_bomb()


func _fire_charged_laser() -> void:
	var player_pos: Vector2 = player_controller.position
	bullet_manager.add_charged_laser({
		"x": player_pos.x,
		"top_y": PLAYFIELD.position.y,
		"bottom_y": player_pos.y - 28.0,
		"ttl": CHARGE_LASER_DURATION,
		"age": 0.0,
		"width": CHARGE_LASER_WIDTH
	})
	_apply_charged_laser_damage(player_pos.x, CHARGE_LASER_WIDTH)
	_add_shake(0.14, 8.0)
	_play_sfx("charge_release")


func _apply_charged_laser_damage(laser_x: float, laser_width: float) -> void:
	for enemy in enemies:
		var enemy_position: Vector2 = enemy["position"]
		if absf(enemy_position.x - laser_x) <= laser_width * 0.7:
			enemy["health"] = int(enemy["health"]) - 8
			enemy["hit_flash"] = HIT_FLASH_TIME
			if int(enemy["health"]) <= 0:
				_add_explosion(enemy_position, Color("#8ff6ff"), 42.0)
				score += 150 + combo * 10
				combo += 1
	if boss_active and absf(boss_pos.x - laser_x) <= BOSS_RADIUS + laser_width:
		boss_health -= 12
		boss_hit_flash = 0.12
		score += 50
		if boss_health <= 0:
			_defeat_boss()


func _use_bomb() -> void:
	if not player_controller.consume_bomb():
		return
	bomb_flash_timer = 0.28
	bullet_manager.clear_enemy_bullets()
	for enemy in enemies:
		var enemy_position: Vector2 = enemy["position"]
		enemy["health"] = 0
		_add_explosion(enemy_position, Color("#35c7ff"), 52.0)
	score += enemies.size() * 120
	combo += enemies.size()
	if boss_active:
		boss_health -= 35
		boss_hit_flash = 0.22
		_add_explosion(boss_pos, Color("#ff5dff"), 92.0)
		if boss_health <= 0:
			_defeat_boss()
	_add_shake(0.24, 18.0)
	_play_sfx("bomb")


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
		"wobble": rng.randf_range(0.0, TAU),
		"hit_flash": 0.0
	})


func _update_enemies(delta: float) -> void:
	for enemy in enemies:
		var wobble: float = enemy["wobble"] + delta * 3.0
		var enemy_position: Vector2 = enemy["position"]
		var enemy_velocity: Vector2 = enemy["velocity"]
		enemy_position += enemy_velocity * delta
		enemy_position.x += sin(wobble) * 32.0 * delta
		enemy["wobble"] = wobble
		enemy["position"] = enemy_position
		enemy["hit_flash"] = maxf(float(enemy.get("hit_flash", 0.0)) - delta, 0.0)
		enemy["fire_timer"] = float(enemy["fire_timer"]) - delta
		if float(enemy["fire_timer"]) <= 0.0 and PLAYFIELD.has_point(enemy_position):
			enemy["fire_timer"] = ENEMY_BULLET_INTERVAL
			var to_player: Vector2 = (player_controller.position - enemy_position).normalized()
			bullet_manager.add_enemy_bullet({"position": enemy_position + Vector2(0, 20), "velocity": to_player * 260.0})
	enemies = enemies.filter(_is_enemy_active)


func _update_effects(delta: float) -> void:
	for effect in effects:
		effect["age"] = float(effect["age"]) + delta
		effect["ttl"] = float(effect["ttl"]) - delta
	effects = effects.filter(func(effect: Dictionary) -> bool: return float(effect["ttl"]) > 0.0)


func _start_boss() -> void:
	boss_started = true
	boss_active = false
	boss_intro_timer = 2.2
	boss_pos = Vector2(PLAYFIELD.position.x + PLAYFIELD.size.x * 0.5, PLAYFIELD.position.y - 90.0)
	boss_health = BOSS_MAX_HEALTH
	boss_fire_timer = 0.8
	enemies.clear()
	bullet_manager.clear_enemy_bullets()
	status_label.text = "WARNING: NULL RELAY SERAPH"
	_play_sfx("boss_warning")


func _update_boss(delta: float) -> void:
	boss_weave += delta
	if boss_intro_timer > 0.0:
		boss_intro_timer -= delta
		boss_pos = boss_pos.lerp(Vector2(PLAYFIELD.position.x + PLAYFIELD.size.x * 0.5, PLAYFIELD.position.y + 135.0), delta * 1.8)
		if boss_intro_timer <= 0.0:
			boss_active = true
			status_label.text = ""
		return

	boss_pos.x = PLAYFIELD.position.x + PLAYFIELD.size.x * 0.5 + sin(boss_weave * 1.4) * 210.0
	boss_pos.y = PLAYFIELD.position.y + 132.0 + sin(boss_weave * 2.1) * 24.0
	boss_fire_timer -= delta
	if boss_fire_timer <= 0.0:
		_fire_boss_pattern()


func _fire_boss_pattern() -> void:
	var health_ratio := float(boss_health) / float(BOSS_MAX_HEALTH)
	if health_ratio > 0.6:
		boss_fire_timer = 1.0
		_fire_boss_spread(5, 230.0, PI * 0.26)
	elif health_ratio > 0.25:
		boss_fire_timer = 0.75
		_fire_boss_spread(7, 250.0, PI * 0.42)
		_fire_aimed_boss_shot(290.0)
	else:
		boss_fire_timer = 0.55
		_fire_boss_spread(9, 285.0, PI * 0.55)
		_fire_aimed_boss_shot(340.0)


func _fire_boss_spread(count: int, speed: float, arc_width: float) -> void:
	var start_angle := PI * 0.5 - arc_width * 0.5
	var step := arc_width / float(maxi(count - 1, 1))
	for i in range(count):
		var angle := start_angle + step * float(i)
		var velocity := Vector2(cos(angle), sin(angle)) * speed
		bullet_manager.add_enemy_bullet({"position": boss_pos + Vector2(0, 46), "velocity": velocity})


func _fire_aimed_boss_shot(speed: float) -> void:
	var to_player: Vector2 = (player_controller.position - boss_pos).normalized()
	bullet_manager.add_enemy_bullet({"position": boss_pos + Vector2(-28, 30), "velocity": to_player.rotated(-0.1) * speed})
	bullet_manager.add_enemy_bullet({"position": boss_pos + Vector2(28, 30), "velocity": to_player.rotated(0.1) * speed})


func _update_collisions() -> void:
	if boss_active:
		for bullet in bullet_manager.player_bullets:
			var bullet_position_for_boss: Vector2 = bullet["position"]
			if boss_pos.distance_to(bullet_position_for_boss) <= BOSS_RADIUS + BULLET_RADIUS:
				boss_health -= int(bullet["damage"])
				boss_hit_flash = HIT_FLASH_TIME
				bullet_manager.mark_player_bullet_spent(bullet)
				score += 5
				if boss_health <= 0:
					_defeat_boss()
					return

	for enemy in enemies:
		for bullet in bullet_manager.player_bullets:
			var enemy_position: Vector2 = enemy["position"]
			var bullet_position: Vector2 = bullet["position"]
			if enemy_position.distance_to(bullet_position) <= ENEMY_RADIUS + BULLET_RADIUS:
				enemy["health"] = int(enemy["health"]) - int(bullet["damage"])
				enemy["hit_flash"] = HIT_FLASH_TIME
				bullet_manager.mark_player_bullet_spent(bullet)
				if int(enemy["health"]) <= 0:
					score += 100 + combo * 10
					combo += 1
					_add_explosion(enemy_position, Color("#ffd166"), 34.0)
					_play_sfx("enemy_destroy")

	bullet_manager.prune_player_bullets(PLAYFIELD)

	if player_controller.invuln_timer > 0.0:
		return

	for enemy in enemies:
		var enemy_position: Vector2 = enemy["position"]
		if player_controller.position.distance_to(enemy_position) <= PLAYER_RADIUS + ENEMY_RADIUS:
			_damage_player()
			enemy["health"] = 0
			_add_explosion(enemy_position, Color("#ff5d78"), 40.0)
			return

	for enemy_bullet in bullet_manager.enemy_bullets:
		var enemy_bullet_position: Vector2 = enemy_bullet["position"]
		if player_controller.position.distance_to(enemy_bullet_position) <= PLAYER_RADIUS + 8.0:
			_damage_player()
			bullet_manager.mark_enemy_bullet_spent(enemy_bullet, PLAYFIELD)
			return


func _damage_player() -> void:
	combo = 0
	_add_explosion(player_controller.position, Color("#ff5d78"), 48.0)
	_add_shake(0.18, 12.0)
	_play_sfx("player_hit")
	var damage_result: Dictionary = player_controller.damage(PLAYFIELD)
	if bool(damage_result["game_over"]):
		_game_over()
		return

	if bool(damage_result["respawned"]):
		bullet_manager.clear_enemy_bullets()


func _game_over() -> void:
	game_state = "game_over"
	title_label.text = "GAME OVER"
	subtitle_label.text = "Press Enter or Start to retry"
	status_label.text = "Score: %d" % score
	_add_shake(0.3, 16.0)
	_play_sfx("player_hit")


func _level_clear() -> void:
	game_state = "level_clear"
	title_label.text = "WEAPON ACQUIRED"
	subtitle_label.text = "Sonic Wave Cannon"
	status_label.text = "Sky Arc Breach clear  |  Score: %d  |  Press Enter or Start" % score
	enemies.clear()
	bullet_manager.clear_enemy_bullets()
	_play_sfx("pickup")


func _defeat_boss() -> void:
	_add_explosion(boss_pos, Color("#ff5dff"), 120.0)
	_add_explosion(boss_pos + Vector2(-90, 40), Color("#ffd166"), 86.0)
	_add_explosion(boss_pos + Vector2(90, 42), Color("#8ff6ff"), 86.0)
	_add_shake(0.5, 22.0)
	boss_active = false
	boss_started = false
	boss_health = 0
	score += 5000 + combo * 25
	combo += 10
	bullet_manager.clear_player_bullets()
	bullet_manager.clear_enemy_bullets()
	_level_clear()


func _update_hud() -> void:
	hud_label.text = ""


func _is_enemy_active(enemy: Dictionary) -> bool:
	var enemy_position: Vector2 = enemy["position"]
	return enemy_position.y < PLAYFIELD.end.y + 60.0 and int(enemy["health"]) > 0


func _add_explosion(pos: Vector2, color: Color, radius: float) -> void:
	effects.append({"position": pos, "color": color, "radius": radius, "ttl": 0.34, "age": 0.0, "type": "flame_explosion"})


func _add_shake(duration: float, strength: float) -> void:
	shake_timer = maxf(shake_timer, duration)
	shake_strength = maxf(shake_strength, strength)


func _get_shake_offset() -> Vector2:
	if shake_timer <= 0.0:
		shake_strength = 0.0
		return Vector2.ZERO
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))


func _play_sfx(sfx_name: String) -> void:
	if audio_manager != null:
		audio_manager.play_sfx(sfx_name)


func _ensure_input_map() -> void:
	_add_key_action("move_left", [KEY_A, KEY_LEFT])
	_add_key_action("move_right", [KEY_D, KEY_RIGHT])
	_add_key_action("move_up", [KEY_W, KEY_UP])
	_add_key_action("move_down", [KEY_S, KEY_DOWN])
	_add_key_action("fire", [KEY_SPACE])
	_add_key_action("bomb", [KEY_X])
	_add_key_action("focus", [KEY_SHIFT, KEY_F])
	_add_key_action("start_game", [KEY_ENTER])
	_add_key_action("pause_game", [KEY_ESCAPE])
	_add_joypad_button_action("fire", [JOY_BUTTON_A])
	_add_joypad_button_action("bomb", [JOY_BUTTON_B])
	_add_joypad_button_action("focus", [JOY_BUTTON_LEFT_SHOULDER])
	_add_joypad_button_action("start_game", [JOY_BUTTON_START])
	_add_joypad_button_action("pause_game", [JOY_BUTTON_START])


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


func _add_joypad_button_action(action_name: StringName, button_ids: Array[int]) -> void:
	if not InputMap.has_action(action_name):
		InputMap.add_action(action_name)
	for button_id in button_ids:
		var has_button := false
		for event in InputMap.action_get_events(action_name):
			if event is InputEventJoypadButton and event.button_index == button_id:
				has_button = true
				break
		if not has_button:
			var button_event := InputEventJoypadButton.new()
			button_event.button_index = button_id
			InputMap.action_add_event(action_name, button_event)


func _draw_side_panels() -> void:
	hud_renderer.draw(self, {
		"playfield": PLAYFIELD,
		"score": score,
		"combo": combo,
		"lives": player_controller.lives,
		"bombs": player_controller.bombs,
		"shields": player_controller.shields,
		"boss_started": boss_started
	})


func _draw_playfield() -> void:
	_draw_scrolling_background()


func _draw_scrolling_background() -> void:
	if sky_arc_background_texture == null:
		draw_rect(PLAYFIELD, Color("#0b1730"))
		return

	var bg_height := PLAYFIELD.size.x * float(sky_arc_background_texture.get_height()) / float(sky_arc_background_texture.get_width())
	var scroll := fmod(stage_time * BACKGROUND_SCROLL_SPEED, bg_height)
	var bg_size := Vector2(PLAYFIELD.size.x, bg_height)
	var first_y := PLAYFIELD.position.y + scroll - bg_height
	while first_y > PLAYFIELD.position.y:
		first_y -= bg_height
	for i in range(3):
		var dst := Rect2(Vector2(PLAYFIELD.position.x, first_y + bg_height * float(i)), bg_size)
		draw_texture_rect(sky_arc_background_texture, dst, false)
	draw_rect(PLAYFIELD, Color(0.02, 0.05, 0.09, 0.18))


func _draw_stars() -> void:
	for i in range(70):
		var x := PLAYFIELD.position.x + fmod(float(i * 137), PLAYFIELD.size.x)
		var y := PLAYFIELD.position.y + fmod(float(i * 71) + stage_time * (20.0 + float(i % 4) * 18.0), PLAYFIELD.size.y)
		draw_circle(_pixel_snap(Vector2(x, y)), 1.5 + float(i % 3), Color(0.55, 0.9, 1.0, 0.24))


func _draw_player() -> void:
	if player_controller.invuln_timer > 0.0 and int(player_controller.invuln_timer * 12.0) % 2 == 0:
		return

	var input_x := Input.get_axis("move_left", "move_right")
	var lean := input_x * 10.0
	var bob := sin(stage_time * 13.0) * 2.0
	var player_pos: Vector2 = player_controller.position
	var charge_timer: float = player_controller.charge_timer
	var active_player_texture := _get_player_bank_texture(input_x)
	_draw_texture_centered(active_player_texture, player_pos + Vector2(lean, -8 + bob), Vector2(118, 128), input_x * 0.025)
	if charge_timer >= CHARGE_TIME:
		draw_arc(player_pos, 42.0 + sin(stage_time * 18.0) * 4.0, 0.0, TAU, 36, Color("#8ff6ff"), 4.0)
	elif charge_timer > 0.0:
		draw_arc(player_pos, 30.0, -PI * 0.5, -PI * 0.5 + TAU * (charge_timer / CHARGE_TIME), 24, Color("#35c7ff"), 3.0)
	draw_circle(player_pos, 5.0, Color(0.9, 1.0, 1.0, 0.85))
	draw_circle(player_pos + Vector2(0, 2), 8.0, Color("#f7d36b"))
	draw_circle(_pixel_snap(player_pos + Vector2(0, 42)), 10.0 + sin(stage_time * 18.0) * 2.0, Color("#ff7a33"))


func _get_player_bank_texture(input_x: float) -> Texture2D:
	if input_x <= -0.65 and player_bank_left_2_texture != null:
		return player_bank_left_2_texture
	if input_x <= -0.18 and player_bank_left_1_texture != null:
		return player_bank_left_1_texture
	if input_x >= 0.65 and player_bank_right_2_texture != null:
		return player_bank_right_2_texture
	if input_x >= 0.18 and player_bank_right_1_texture != null:
		return player_bank_right_1_texture
	return player_texture


func _draw_boss() -> void:
	if not boss_started:
		return

	var boss_draw_pos := boss_pos + Vector2(0, 12 + sin(boss_weave * 7.0) * 2.0)
	var boss_rotation := sin(boss_weave * 2.0) * 0.025
	_draw_texture_centered(boss_texture, boss_draw_pos, Vector2(330, 305), boss_rotation)
	if boss_hit_flash > 0.0:
		_draw_texture_centered(boss_texture, boss_draw_pos, Vector2(330, 305), boss_rotation, Color(1.0, 1.0, 1.0, 0.75))
		draw_circle(boss_pos, 112.0, Color(1.0, 1.0, 1.0, boss_hit_flash * 2.0))
	draw_circle(boss_pos + Vector2(0, 4), 18.0 + sin(boss_weave * 8.0) * 3.0, Color(1.0, 0.35, 0.95, 0.65))
	draw_arc(boss_pos, BOSS_RADIUS, 0.0, TAU, 32, Color("#ffe6f1"), 3.0)

	var bar_width := 520.0
	var bar_pos := Vector2(PLAYFIELD.position.x + (PLAYFIELD.size.x - bar_width) * 0.5, PLAYFIELD.position.y + 22.0)
	var health_ratio := clampf(float(boss_health) / float(BOSS_MAX_HEALTH), 0.0, 1.0)
	draw_rect(Rect2(bar_pos, Vector2(bar_width, 16)), Color("#1f1024"))
	draw_rect(Rect2(bar_pos, Vector2(bar_width * health_ratio, 16)), Color("#ff5d78"))
	draw_rect(Rect2(bar_pos, Vector2(bar_width, 16)), Color("#ffe6f1"), false, 2.0)


func _draw_enemy(enemy: Dictionary) -> void:
	var enemy_type: String = enemy["type"]
	var center: Vector2 = enemy["position"]
	var wobble: float = enemy["wobble"]
	var hit_flash: float = float(enemy.get("hit_flash", 0.0))
	if enemy_type == "needle_runner":
		_draw_texture_centered(needle_runner_texture, center + Vector2(0, 2), Vector2(78, 78), sin(wobble) * 0.08)
		if hit_flash > 0.0:
			_draw_texture_centered(needle_runner_texture, center + Vector2(0, 2), Vector2(78, 78), sin(wobble) * 0.08, Color(1.0, 1.0, 1.0, 0.82))
	else:
		_draw_texture_centered(choir_drone_texture, center + Vector2(0, 2 + sin(wobble * 1.7) * 2.0), Vector2(78, 70), sin(wobble) * 0.05)
		if hit_flash > 0.0:
			_draw_texture_centered(choir_drone_texture, center + Vector2(0, 2 + sin(wobble * 1.7) * 2.0), Vector2(78, 70), sin(wobble) * 0.05, Color(1.0, 1.0, 1.0, 0.82))
	draw_circle(_pixel_snap(center), 7.0, Color("#ffd166"))


func _draw_effect(effect: Dictionary) -> void:
	var effect_position: Vector2 = effect["position"]
	var effect_color: Color = effect["color"]
	var radius: float = effect["radius"]
	var age: float = effect["age"]
	var ttl: float = effect["ttl"]
	var progress := clampf(age / (age + ttl), 0.0, 1.0)
	var alpha := 1.0 - progress
	if String(effect.get("type", "")) == "flame_explosion" and not explosion_frame_textures.is_empty():
		var frame_index := mini(int(progress * float(explosion_frame_textures.size())), explosion_frame_textures.size() - 1)
		var frame_texture := explosion_frame_textures[frame_index]
		var frame_size := Vector2(radius * 2.2, radius * 2.2) * lerpf(0.55, 1.15, progress)
		_draw_texture_centered(frame_texture, effect_position, frame_size, 0.0, Color(1.0, 1.0, 1.0, alpha))
		return
	draw_circle(effect_position, radius * progress, Color(effect_color.r, effect_color.g, effect_color.b, 0.28 * alpha))
	draw_arc(effect_position, radius * progress, 0.0, TAU, 36, Color(effect_color.r, effect_color.g, effect_color.b, alpha), 4.0)


func _draw_texture_centered(texture: Texture2D, center: Vector2, size: Vector2, rotation := 0.0, modulate: Color = Color.WHITE) -> void:
	if texture == null:
		return
	var snapped := _pixel_snap(center)
	draw_set_transform(snapped + draw_shake_offset, rotation, Vector2.ONE)
	draw_texture_rect(texture, Rect2(-size * 0.5, size), false, modulate)
	draw_set_transform(draw_shake_offset, 0.0, Vector2.ONE)


func _pixel_snap(pos: Vector2) -> Vector2:
	return Vector2(roundf(pos.x / 2.0) * 2.0, roundf(pos.y / 2.0) * 2.0)


func _draw_scanline_overlay() -> void:
	for y in range(0, 1080, 4):
		draw_rect(Rect2(Vector2(PLAYFIELD.position.x, float(y)), Vector2(PLAYFIELD.size.x, 1.0)), Color(0.0, 0.0, 0.0, 0.16))
	draw_rect(PLAYFIELD, Color(0.0, 0.08, 0.18, 0.08))
