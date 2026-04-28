# Data Schemas

These schemas are copied and normalized from the GDD for first-build implementation. Keep JSON files small and readable.

## Weapon

```json
{
  "id": "sonic_wave_cannon",
  "display_name": "Sonic Wave Cannon",
  "type": "frame_weapon",
  "ammo_max": 100,
  "ammo_cost": 5,
  "cooldown": 0.35,
  "damage": 8,
  "projectile_scene": "res://scenes/bullets/sonic_wave_projectile.tscn",
  "palette_id": "signal",
  "charged": {
    "enabled_requires_upgrade": "buster_array",
    "charge_time": 1.1,
    "ammo_cost": 15,
    "damage": 22,
    "effect": "wide_resonance_cone"
  },
  "can_clear_bullets": false,
  "can_open_secret_tags": ["sonic_gate", "shield_resonance_lock"]
}
```

## Enemy

```json
{
  "id": "choir_drone",
  "display_name": "Choir Drone",
  "scene": "res://scenes/enemies/enemy_choir_drone.tscn",
  "max_health": 3,
  "contact_damage": 1,
  "score_value": 100,
  "movement_pattern": "path_follow",
  "fire_pattern": "single_straight",
  "drop_table": "basic_enemy",
  "tags": ["flying", "choirborne", "basic"]
}
```

## Level

```json
{
  "level_id": "intro_sky_arc_breach",
  "display_name": "Sky Arc Breach",
  "scroll_speed": 90,
  "music": "intro_stage_theme",
  "waves": [],
  "checkpoints": [],
  "boss": {
    "id": "null_relay_seraph",
    "trigger_time": 330.0
  }
}
```

## Boss

```json
{
  "id": "null_relay_seraph",
  "display_name": "Null Relay Seraph",
  "scene": "res://scenes/bosses/boss_null_relay_seraph.tscn",
  "max_health": 450,
  "phase_markers": [0.6, 0.2],
  "weakness_weapon_ids": [],
  "phases": [],
  "reward_weapon_id": "sonic_wave_cannon"
}
```

