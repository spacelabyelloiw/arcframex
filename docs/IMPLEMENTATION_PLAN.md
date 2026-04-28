# Implementation Plan

## Product Target

Build the first playable described in the GDD: one complete intro level, `Sky Arc Breach`, ending with `Null Relay Seraph` and a weapon-acquired screen for `Sonic Wave Cannon`.

## Milestone 0: Repo and Project Foundation

- Create Godot project shell.
- Add folder structure from the GDD.
- Add GitHub Pages Web export workflow.
- Add docs for future agents.
- Confirm GitHub Pages is configured to use GitHub Actions.

## Milestone 1: Playable Core

- Main scene with 16:9 shell and centered 960x720 logical playfield.
- Input map for controller and keyboard.
- Player ship movement, focus speed, bounds, banking, thruster placeholder animation.
- Twin Vulcan primary fire.
- Bullet pooling and simple enemy hit detection.
- HUD placeholders for lives, shields, score, weapon, energy, charge, bombs.

## Milestone 2: Combat Loop

- Charge shot: 1.2s charge, release into 3s piercing laser.
- Bomb/special: screen clear or high-damage pulse with strong telegraph.
- Player damage, shield pips, invulnerability flicker, death, respawn.
- Pickups: score, shield, weapon energy, bomb charge.
- Combo and basic rank scoring.

## Milestone 3: Intro Level

- Data-driven wave spawner reading `data/levels/intro_sky_arc_breach.json`.
- Four enemy types minimum:
  - `choir_drone`
  - `needle_runner`
  - `pylon_turret`
  - `relay_carrier`
- Mid-level warning hazard/setpiece.
- Checkpoint at mid-level.
- Debug jump-to-boss.

## Milestone 4: Boss and Reward

- `Null Relay Seraph` scene with three attack phases.
- Boss warning intro and boss health bar.
- Readable bullets, warning lanes, side drone summon.
- Staged boss explosion.
- Weapon acquired screen.
- Unlock/select prototype `Sonic Wave Cannon`.

## Milestone 5: Feel, Polish, and Web

- Generated placeholder sprites for player, enemies, boss, bullets, pickups, UI.
- Procedural SFX for shots, charge, hit, explosion, pickup, warning, menu.
- Camera shake, flash, and VFX pass.
- Web export smoke test.
- Confirm GitHub Actions deploys the exported build after push to `main`.

## Acceptance Gate for First Playable

- Can start from title screen and complete the intro level.
- Controller and keyboard both work.
- Player cannot leave playfield.
- Boss can be defeated.
- Level complete, game over, pause, and weapon acquired screens exist.
- Web build deploys through GitHub Pages.

