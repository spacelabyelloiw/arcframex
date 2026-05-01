# Future Bot Handoff

## Read First

1. `arc_frame_x_codex_ready_game_design_document.md`
2. `docs/IMPLEMENTATION_PLAN.md`
3. `docs/TECH_STACK.md`
4. `docs/DATA_SCHEMAS.md`

## Core Constraints

- Build the first playable, not the full campaign.
- Keep systems data-driven where practical.
- Use generated placeholder art, but keep it stylized and readable.
- Use procedural SFX for now.
- Preserve the 4:3 central playfield inside 16:9.
- Favor GDScript for Web export compatibility.

## Suggested Folder Ownership

- `scenes/player`, `scripts/player`: movement, damage, weapons, charge.
- `scenes/bullets`, `scripts/bullets`: projectile behavior and pooling.
- `scenes/enemies`, `scripts/enemies`: generic enemy base plus per-enemy scripts.
- `scenes/bosses`, `scripts/bosses`: boss state machines and attack patterns.
- `scenes/levels`, `scripts/managers`: level loading, wave spawning, checkpoints.
- `data`: JSON tuning and content.
- `assets`: generated and authored assets only; do not commit export output.

## Current Refactor Status

- `scripts/managers/audio_manager.gd` owns procedural SFX generation and pooled playback.
- `scripts/ui/hud_renderer.gd` owns the current side-panel HUD drawing.
- `scripts/player/player_controller.gd` owns player position, movement, lives, shields, bombs, invulnerability, fire timing, and charge timing.
- `scripts/core/main_game.gd` still owns bullets, enemies, boss, collision, and most rendering logic. Continue extracting these in small playable slices.

## Bot Working Rules

- Before changing gameplay, check the relevant data file and schema.
- Prefer adding a data row over hardcoding a one-off value.
- Keep scene names and file names lowercase snake_case.
- After adding a new system, document the extension point briefly in this file or a focused doc.
- Do not add campaign-scale content until the first playable acceptance gate is met.

## Known Setup Gap

This folder was not a git repository when the setup docs were created. Connect it to GitHub with:

```powershell
git init
git branch -M main
git remote add origin <repo-url>
git add .
git commit -m "Scaffold Arc Frame X Godot project"
git push -u origin main
```
