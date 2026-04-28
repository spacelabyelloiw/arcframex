# Generated Asset Guide

## Asset Direction

Generated assets should look like high-resolution 16-bit arcade art, not plain geometric placeholders. Prioritize silhouette, color coding, and readability over detail.

## First Asset Batch

- Player ship base form, blue prototype palette.
- Player banking left/right frames.
- Thruster frames.
- Twin Vulcan bullet.
- Charge laser beam segments and impact.
- Four intro enemies.
- `Null Relay Seraph` boss core and wings/arms.
- Pickups for score, shield, weapon energy, bomb.
- Warning hazard signs/lanes.
- HUD icons for lives, shields, weapon energy, bomb.
- Parallax background pieces for futuristic sky-bridge industrial zone.

## File Rules

- Store source/generated PNGs under `assets/art/...`.
- Use lowercase snake_case.
- Prefer transparent PNG spritesheets.
- Keep sprite pivots documented in import notes when important.
- Do not overwrite a generated source asset without preserving the prompt or reason.

## Prompt Template

```text
High-resolution 2D sprite sheet for a retro-modern vertical arcade shooter, crisp 16-bit-inspired edges, bold readable silhouette, saturated sci-fi palette, transparent background, no text, no UI frame. Subject: <asset>. Animation frames: <frames>. View: top-down/front-angled shooter perspective. Style: Mega Man X meets Strikers 1945 and Radiant Silvergun.
```

