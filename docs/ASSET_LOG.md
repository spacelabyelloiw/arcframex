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

## 2026-04-28: Sky Arc Breach Scrolling Background

Mode: built-in image generation tool, using the user's supplied reference image as look-and-feel guidance.

Generated asset:

- `assets/art/backgrounds/bg_sky_arc_breach.png`

Prompt summary:

Generated an original vertical scrolling shooter background inspired by the reference: a futuristic industrial sky fortress deck with a central runway, dark gunmetal panels, orange hazard markings, blue glow strips, mechanical towers, and clouds/blue sky visible between structures. The prompt explicitly excluded UI, ships, enemies, bullets, text, and watermarking.

Implementation notes:

- The prototype draws this image scaled to the 960px playfield width.
- It loops vertically under gameplay at a slightly slower scroll than the star/grid overlay.
- A dark translucent overlay is applied in code to preserve bullet readability.
