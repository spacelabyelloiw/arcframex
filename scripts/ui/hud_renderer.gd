extends RefCounted
class_name HudRenderer

const LEFT_PANEL_WIDTH := 240.0
const RIGHT_PANEL_WIDTH := 240.0


func draw(canvas: CanvasItem, state: Dictionary) -> void:
	var playfield: Rect2 = state["playfield"]
	var score: int = state["score"]
	var combo: int = state["combo"]
	var lives: int = state["lives"]
	var bombs: int = state["bombs"]
	var shields: int = state["shields"]
	var boss_started: bool = state["boss_started"]

	var left_panel := Rect2(Vector2.ZERO, Vector2(LEFT_PANEL_WIDTH, 1080))
	var right_panel := Rect2(Vector2(playfield.end.x, 0), Vector2(RIGHT_PANEL_WIDTH, 1080))
	canvas.draw_rect(left_panel, Color("#03070d"))
	canvas.draw_rect(right_panel, Color("#03070d"))
	_draw_panel_trim(canvas, left_panel, true)
	_draw_panel_trim(canvas, right_panel, false)
	_draw_left_arcade_hud(canvas, score, combo, lives, bombs, shields)
	_draw_right_arcade_hud(canvas, boss_started)


func _draw_panel_trim(canvas: CanvasItem, panel: Rect2, left_side: bool) -> void:
	var accent := Color("#007bff")
	var dim := Color(0.0, 0.45, 0.9, 0.28)
	var inner_x := panel.end.x - 12.0 if left_side else panel.position.x + 12.0
	canvas.draw_line(Vector2(inner_x, 0), Vector2(inner_x, 1080), dim, 2.0)
	for i in range(6):
		var y := 60.0 + float(i) * 165.0
		var x0 := panel.position.x + 24.0
		var x1 := panel.end.x - 24.0
		canvas.draw_line(Vector2(x0, y), Vector2(x1, y), Color(0.0, 0.35, 0.75, 0.22), 1.0)
	if left_side:
		var points := PackedVector2Array([
			Vector2(panel.end.x - 2, 0),
			Vector2(panel.end.x - 2, 680),
			Vector2(panel.end.x - 42, 720),
			Vector2(panel.end.x - 42, 900),
			Vector2(panel.end.x - 2, 942),
			Vector2(panel.end.x - 2, 1080)
		])
		canvas.draw_polyline(points, accent, 3.0)
	else:
		var points := PackedVector2Array([
			Vector2(panel.position.x + 2, 0),
			Vector2(panel.position.x + 2, 680),
			Vector2(panel.position.x + 42, 720),
			Vector2(panel.position.x + 42, 900),
			Vector2(panel.position.x + 2, 942),
			Vector2(panel.position.x + 2, 1080)
		])
		canvas.draw_polyline(points, accent, 3.0)


func _draw_left_arcade_hud(canvas: CanvasItem, score: int, combo: int, lives: int, bombs: int, shields: int) -> void:
	_draw_hud_text(canvas, Vector2(24, 58), "ARC FRAME X", 28, Color("#eef7ff"))
	_draw_hud_text(canvas, Vector2(24, 134), "SCORE", 25, Color("#008cff"))
	_draw_hud_text(canvas, Vector2(24, 184), "%08d" % score, 38, Color("#eef7ff"))
	_draw_hud_text(canvas, Vector2(24, 276), "CHAIN", 25, Color("#ff9b1f"))
	_draw_hud_text(canvas, Vector2(24, 334), "%03d" % combo, 54, Color("#ffc43b"))
	_draw_hud_text(canvas, Vector2(24, 450), "LIVES", 25, Color("#008cff"))
	for i in range(maxi(lives, 0)):
		_draw_mini_ship(canvas, Vector2(48 + i * 44, 510))
	_draw_hud_text(canvas, Vector2(24, 802), "BOMB", 25, Color("#008cff"))
	_draw_hud_text(canvas, Vector2(24, 850), "x%02d" % bombs, 32, Color("#eef7ff"))
	_draw_bomb_icon(canvas, Vector2(122, 842))
	_draw_hud_text(canvas, Vector2(24, 954), "SHIELD", 25, Color("#008cff"))
	_draw_meter(canvas, Rect2(Vector2(24, 995), Vector2(192, 28)), float(shields) / 2.0, Color("#35ff8a"), Color("#007bff"))


func _draw_right_arcade_hud(canvas: CanvasItem, boss_started: bool) -> void:
	_draw_hud_text(canvas, Vector2(1712, 58), "WEAPON", 28, Color("#008cff"))
	_draw_card(canvas, Rect2(Vector2(1710, 108), Vector2(170, 202)), "TWIN\nVULCAN", Color("#35c7ff"))
	_draw_hud_text(canvas, Vector2(1712, 410), "NEXT", 28, Color("#008cff"))
	_draw_card(canvas, Rect2(Vector2(1710, 458), Vector2(170, 202)), "SONIC\nWAVE", Color("#ff9b1f"))
	_draw_minimap(canvas, Rect2(Vector2(1702, 782), Vector2(188, 248)), boss_started)


func _draw_hud_text(canvas: CanvasItem, pos: Vector2, text: String, size: int, color: Color) -> void:
	var font := ThemeDB.fallback_font
	canvas.draw_string(font, pos, text, HORIZONTAL_ALIGNMENT_LEFT, -1, size, Color(0, 0, 0, 0.75))
	canvas.draw_string(font, pos + Vector2(-2, -2), text, HORIZONTAL_ALIGNMENT_LEFT, -1, size, color)


func _draw_meter(canvas: CanvasItem, rect: Rect2, value: float, start_color: Color, end_color: Color) -> void:
	canvas.draw_rect(rect.grow(4.0), Color("#021226"))
	canvas.draw_rect(rect.grow(2.0), Color("#5ad7ff"), false, 2.0)
	var segments := 12
	for i in range(segments):
		var t := float(i) / float(segments - 1)
		var filled := t <= clampf(value, 0.0, 1.0)
		var x := rect.position.x + 4.0 + float(i) * ((rect.size.x - 8.0) / float(segments))
		var seg := Rect2(Vector2(x, rect.position.y + 4.0), Vector2(11.0, rect.size.y - 8.0))
		canvas.draw_rect(seg, start_color.lerp(end_color, t) if filled else Color("#09213b"))


func _draw_card(canvas: CanvasItem, rect: Rect2, text: String, color: Color) -> void:
	canvas.draw_rect(rect, Color("#050b14"))
	canvas.draw_rect(rect, Color("#7ccfff"), false, 2.0)
	_draw_hud_text(canvas, rect.position + Vector2(25, 54), text, 25, Color("#eef7ff"))
	canvas.draw_circle(rect.position + Vector2(rect.size.x * 0.5, rect.size.y - 48), 22.0, Color(color.r, color.g, color.b, 0.25))
	canvas.draw_circle(rect.position + Vector2(rect.size.x * 0.5, rect.size.y - 48), 12.0, color)


func _draw_minimap(canvas: CanvasItem, rect: Rect2, boss_started: bool) -> void:
	canvas.draw_rect(rect, Color("#041124"))
	canvas.draw_rect(rect, Color("#00a5ff"), false, 2.0)
	for i in range(1, 5):
		var x := rect.position.x + rect.size.x * float(i) / 5.0
		canvas.draw_line(Vector2(x, rect.position.y), Vector2(x, rect.end.y), Color(0.0, 0.7, 1.0, 0.22), 1.0)
	for i in range(1, 7):
		var y := rect.position.y + rect.size.y * float(i) / 7.0
		canvas.draw_line(Vector2(rect.position.x, y), Vector2(rect.end.x, y), Color(0.0, 0.7, 1.0, 0.22), 1.0)
	var player_y := rect.end.y - 34.0
	canvas.draw_circle(Vector2(rect.position.x + rect.size.x * 0.5, player_y), 8.0, Color("#35c7ff"))
	if boss_started:
		canvas.draw_circle(Vector2(rect.position.x + rect.size.x * 0.5, rect.position.y + 28.0), 6.0, Color("#ff5d78"))


func _draw_mini_ship(canvas: CanvasItem, pos: Vector2) -> void:
	var points := PackedVector2Array([
		pos + Vector2(0, -18),
		pos + Vector2(14, 15),
		pos + Vector2(0, 8),
		pos + Vector2(-14, 15)
	])
	canvas.draw_colored_polygon(points, Color("#35c7ff"))
	canvas.draw_polyline(PackedVector2Array([points[0], points[1], points[2], points[3], points[0]]), Color("#eef7ff"), 2.0)


func _draw_bomb_icon(canvas: CanvasItem, pos: Vector2) -> void:
	canvas.draw_rect(Rect2(pos, Vector2(46, 46)), Color("#0b3d12"))
	canvas.draw_rect(Rect2(pos, Vector2(46, 46)), Color("#4eff6f"), false, 3.0)
	_draw_hud_text(canvas, pos + Vector2(14, 33), "B", 28, Color("#baff7a"))
