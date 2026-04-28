# Procedural Audio Plan

## Direction

Use procedural sound effects for the first playable so combat feel can iterate without waiting on authored audio. Keep every generated sound short, punchy, and readable.

## Implementation Shape

- Add an `AudioManager` autoload.
- Use pooled `AudioStreamPlayer` nodes for overlapping one-shot sounds.
- Generate tones/noise into `AudioStreamWAV` or use `AudioStreamGenerator` for sounds that need runtime modulation.
- Store procedural SFX definitions in `data/audio/sfx.json`.

## First SFX Set

- `ui_move`: short blip, low volume.
- `ui_confirm`: brighter rising chirp.
- `player_shot`: tight square/saw pulse with quick decay.
- `player_charge_loop`: layered hum that grows in volume/pitch.
- `charge_release`: bright sweep into impact transient.
- `bomb`: bass hit plus noise burst.
- `enemy_hit`: small filtered click.
- `enemy_destroy`: noise pop with falling pitch.
- `player_hit`: harsh warning zap.
- `pickup`: clean upward arpeggio.
- `boss_warning`: repeating alarm tone.
- `boss_destroy`: multi-stage descending blast.

## Guardrails

- Keep SFX below music headroom.
- Avoid constant harsh high frequencies during primary fire.
- Add cooldowns for repeated UI and hit sounds.
- Expose global SFX/music volume in options early.

