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
const BOSS_TRIGGER_TIME := 45.0
const BOSS_MAX_HEALTH := 220
const BOSS_RADIUS := 62.0
const AUDIO_POOL_SIZE := 10

var player_texture: Texture2D = preload("res://assets/art/player/spr_player_ship_base.png")
var choir_drone_texture: Texture2D = preload("res://assets/art/enemies/spr_choir_drone.png")
var needle_runner_texture: Texture2D = preload("res://assets/art/enemies/spr_needle_runner.png")
var boss_texture: Texture2D = preload("res://assets/art/bosses/spr_null_relay_seraph.png")
var sky_arc_background_texture: Texture2D = preload("res://assets/art/backgrounds/bg_sky_arc_breach.png")

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
var boss_started := false
var boss_active := false
var boss_intro_timer := 0.0
var boss_pos := Vector2.ZERO
var boss_health := BOSS_MAX_HEALTH
var boss_fire_timer := 0.0
var boss_weave := 0.0
var bullets: Array[Dictionary] = []
var enemies: Array[Dictionary] = []
var enemy_bullets: Array[Dictionary] = []
var audio_players: Array[AudioStreamPlayer] = []
var rng := RandomNumberGenerator.new()
var hud_layer: CanvasLayer
var title_label: Label
var subtitle_label: Label
var hud_label: Label
var status_label: Label

func _ready() -> void:
	rng.randomize()
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
	invuln_timer = maxf(invuln_timer - delta, 0.0)
	_update_player(delta)
	_update_player_fire(delta)
	if boss_started:
		_update_boss(delta)
	else:
		_update_enemy_spawning(delta)
	_update_bullets(delta)
	_update_enemies(delta)
	_update_enemy_bullets(delta)
	_update_collisions()
	_update_hud()

	if stage_time >= BOSS_TRIGGER_TIME and not boss_started:
		_start_boss()

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

	if boss_started:
		_draw_boss()

	if game_state == "playing" or game_state == "level_clear":
		_draw_player()


func _setup_ui() -> void:
	hud_layer = CanvasLayer.new()
	add_child(hud_layer)

	title_label = _make_label(Vector2(0, 335), Vector2(1920, 86), 64, HORIZONTAL_ALIGNMENT_CENTER)
	subtitle_label = _make_label(Vector2(0, 432), Vector2(1920, 80), 26, HORIZONTAL_ALIGNMENT_CENTER)
	hud_label = _make_label(PLAYFIELD.position + Vector2(24, 20), Vector2(PLAYFIELD.size.x - 48, 48), 24, HORIZONTAL_ALIGNMENT_LEFT)
	status_label = _make_label(Vector2(0, 510), Vector2(1920, 72), 34, HORIZONTAL_ALIGNMENT_CENTER)

	hud_layer.add_child(title_label)
	hud_layer.add_child(subtitle_label)
	hud_layer.add_child(hud_label)
	hud_layer.add_child(status_label)
	_show_title()


func _setup_audio() -> void:
	for i in range(AUDIO_POOL_SIZE):
		var player := AudioStreamPlayer.new()
		player.bus = "Master"
		add_child(player)
		audio_players.append(player)


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
	boss_started = false
	boss_active = false
	boss_intro_timer = 0.0
	boss_pos = Vector2(PLAYFIELD.position.x + PLAYFIELD.size.x * 0.5, PLAYFIELD.position.y + 130.0)
	boss_health = BOSS_MAX_HEALTH
	boss_fire_timer = 0.0
	boss_weave = 0.0
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
		_play_sfx("player_shot")


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


func _start_boss() -> void:
	boss_started = true
	boss_active = false
	boss_intro_timer = 2.2
	boss_pos = Vector2(PLAYFIELD.position.x + PLAYFIELD.size.x * 0.5, PLAYFIELD.position.y - 90.0)
	boss_health = BOSS_MAX_HEALTH
	boss_fire_timer = 0.8
	enemies.clear()
	enemy_bullets.clear()
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
		enemy_bullets.append({"position": boss_pos + Vector2(0, 46), "velocity": velocity})


func _fire_aimed_boss_shot(speed: float) -> void:
	var to_player: Vector2 = (player_pos - boss_pos).normalized()
	enemy_bullets.append({"position": boss_pos + Vector2(-28, 30), "velocity": to_player.rotated(-0.1) * speed})
	enemy_bullets.append({"position": boss_pos + Vector2(28, 30), "velocity": to_player.rotated(0.1) * speed})


func _update_enemy_bullets(delta: float) -> void:
	for enemy_bullet in enemy_bullets:
		var bullet_position: Vector2 = enemy_bullet["position"]
		var bullet_velocity: Vector2 = enemy_bullet["velocity"]
		bullet_position += bullet_velocity * delta
		enemy_bullet["position"] = bullet_position
	enemy_bullets = enemy_bullets.filter(_is_enemy_bullet_active)


func _update_collisions() -> void:
	if boss_active:
		for bullet in bullets:
			var bullet_position_for_boss: Vector2 = bullet["position"]
			if boss_pos.distance_to(bullet_position_for_boss) <= BOSS_RADIUS + BULLET_RADIUS:
				boss_health -= int(bullet["damage"])
				bullet["position"] = Vector2(bullet_position_for_boss.x, -9999.0)
				score += 5
				if boss_health <= 0:
					_defeat_boss()
					return

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
					_play_sfx("enemy_destroy")

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
	_play_sfx("player_hit")
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
	_play_sfx("player_hit")


func _level_clear() -> void:
	game_state = "level_clear"
	title_label.text = "WEAPON ACQUIRED"
	subtitle_label.text = "Sonic Wave Cannon"
	status_label.text = "Sky Arc Breach clear  |  Score: %d  |  Press Enter or Start" % score
	enemies.clear()
	enemy_bullets.clear()
	_play_sfx("pickup")


func _defeat_boss() -> void:
	boss_active = false
	boss_started = false
	boss_health = 0
	score += 5000 + combo * 25
	combo += 10
	bullets.clear()
	enemy_bullets.clear()
	_level_clear()


func _update_hud() -> void:
	var boss_text := ""
	if boss_started:
		boss_text = "   BOSS %03d/%03d" % [maxi(boss_health, 0), BOSS_MAX_HEALTH]
	hud_label.text = "LIVES %d   SHIELD %d   SCORE %06d   COMBO x%d   TIME %02d%s" % [maxi(lives, 0), shields, score, combo, int(stage_time), boss_text]


func _is_player_bullet_active(bullet: Dictionary) -> bool:
	var bullet_position: Vector2 = bullet["position"]
	return bullet_position.y > PLAYFIELD.position.y - 40.0


func _is_enemy_active(enemy: Dictionary) -> bool:
	var enemy_position: Vector2 = enemy["position"]
	return enemy_position.y < PLAYFIELD.end.y + 60.0 and int(enemy["health"]) > 0


func _is_enemy_bullet_active(enemy_bullet: Dictionary) -> bool:
	var bullet_position: Vector2 = enemy_bullet["position"]
	return PLAYFIELD.grow(60.0).has_point(bullet_position)


func _play_sfx(sfx_name: String) -> void:
	var stream := _build_sfx_stream(sfx_name)
	for player in audio_players:
		if not player.playing:
			player.stream = stream
			player.play()
			return

	audio_players[0].stream = stream
	audio_players[0].play()


func _build_sfx_stream(sfx_name: String) -> AudioStreamWAV:
	var frequency := 520.0
	var duration := 0.08
	var volume := 0.22
	var waveform := "sine"
	var end_frequency := frequency

	match sfx_name:
		"player_shot":
			frequency = 980.0
			end_frequency = 760.0
			duration = 0.045
			volume = 0.13
			waveform = "pulse"
		"enemy_destroy":
			frequency = 260.0
			end_frequency = 90.0
			duration = 0.16
			volume = 0.22
			waveform = "noise"
		"player_hit":
			frequency = 190.0
			end_frequency = 70.0
			duration = 0.22
			volume = 0.28
			waveform = "saw"
		"boss_warning":
			frequency = 330.0
			end_frequency = 330.0
			duration = 0.55
			volume = 0.2
			waveform = "alarm"
		"pickup":
			frequency = 660.0
			end_frequency = 1320.0
			duration = 0.28
			volume = 0.24
			waveform = "sine"

	return _make_wav(frequency, end_frequency, duration, volume, waveform)


func _make_wav(frequency: float, end_frequency: float, duration: float, volume: float, waveform: String) -> AudioStreamWAV:
	var mix_rate := 22050
	var sample_count := int(duration * float(mix_rate))
	var bytes := PackedByteArray()
	bytes.resize(sample_count * 2)

	for i in range(sample_count):
		var t := float(i) / float(mix_rate)
		var progress := float(i) / float(maxi(sample_count - 1, 1))
		var current_frequency := lerpf(frequency, end_frequency, progress)
		var envelope := sin(progress * PI)
		var sample := _sample_wave(waveform, current_frequency, t, progress) * envelope * volume
		var int_sample := int(clampf(sample, -1.0, 1.0) * 32767.0)
		if int_sample < 0:
			int_sample = 65536 + int_sample
		bytes[i * 2] = int_sample & 0xff
		bytes[i * 2 + 1] = (int_sample >> 8) & 0xff

	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = mix_rate
	stream.stereo = false
	stream.data = bytes
	return stream


func _sample_wave(waveform: String, frequency: float, t: float, progress: float) -> float:
	match waveform:
		"pulse":
			return 1.0 if sin(TAU * frequency * t) >= 0.0 else -1.0
		"saw":
			return 2.0 * fmod(frequency * t, 1.0) - 1.0
		"noise":
			return rng.randf_range(-1.0, 1.0) * (1.0 - progress * 0.35)
		"alarm":
			var gate := 1.0 if int(progress * 12.0) % 2 == 0 else 0.35
			return sin(TAU * frequency * t) * gate
		_:
			return sin(TAU * frequency * t)


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
	_draw_scrolling_background()


func _draw_scrolling_background() -> void:
	if sky_arc_background_texture == null:
		draw_rect(PLAYFIELD, Color("#0b1730"))
		return

	var bg_height := PLAYFIELD.size.x * float(sky_arc_background_texture.get_height()) / float(sky_arc_background_texture.get_width())
	var scroll := fmod(stage_time * 88.0, bg_height)
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
		draw_circle(Vector2(x, y), 1.5 + float(i % 3), Color(0.55, 0.9, 1.0, 0.35))


func _draw_player() -> void:
	if invuln_timer > 0.0 and int(invuln_timer * 12.0) % 2 == 0:
		return

	var input_x := Input.get_axis("move_left", "move_right")
	var lean := input_x * 7.0
	_draw_texture_centered(player_texture, player_pos + Vector2(lean, -8), Vector2(118, 128))
	draw_circle(player_pos, 5.0, Color(0.9, 1.0, 1.0, 0.85))
	draw_circle(player_pos + Vector2(0, 2), 8.0, Color("#f7d36b"))
	draw_circle(player_pos + Vector2(0, 42), 10.0 + sin(stage_time * 18.0) * 2.0, Color("#ff7a33"))


func _draw_boss() -> void:
	if not boss_started:
		return

	_draw_texture_centered(boss_texture, boss_pos + Vector2(0, 12), Vector2(330, 305))
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
	if enemy_type == "needle_runner":
		_draw_texture_centered(needle_runner_texture, center + Vector2(0, 2), Vector2(78, 78))
	else:
		_draw_texture_centered(choir_drone_texture, center + Vector2(0, 2), Vector2(78, 70))
	draw_circle(center, 7.0, Color("#ffd166"))


func _draw_texture_centered(texture: Texture2D, center: Vector2, size: Vector2) -> void:
	if texture == null:
		return
	draw_texture_rect(texture, Rect2(center - size * 0.5, size), false)
