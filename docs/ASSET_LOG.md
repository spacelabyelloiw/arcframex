# Asset Log

## 2026-04-28: First Generated Sprite Sheet

Mode: built-in image generation tool, then local chroma-key removal and cropping.

Source sheet:

- `assets/art/source_sprite_sheet.png`

Extracted sprites:

- `assets/art/player/spr_player_ship_base.png`
- `assets/art/enemies/spr_choir_drone.png`
- `assets/art/enemies/spr_needle_runner.png`
- `assets/art/bosses/spr_null_relay_seraph.png`

Prompt summary:

Generated a compact retro-modern 2D arcade shooter sprite sheet on a flat `#00ff00` chroma-key background. Requested a blue prototype player fighter, purple choir drone, red needle runner, and large magenta-violet Null Relay Seraph boss. The sheet was cropped into transparent PNGs and wired into the current prototype renderer.

Replacement notes:

- Keep transparent PNG output.
- Preserve strong top-down shooter silhouettes.
- The current gameplay hitboxes are smaller than the sprite art on purpose.
- Do not overwrite these files without also updating this log or adding versioned filenames.

