# Playtest Notes

## Current Build

This is the first playable prototype slice. It is not the full first-build milestone yet.

## How to Run

1. Open Godot 4.6.x.
2. Import/open this folder as a project.
3. Press the Play button.
4. The main scene should load automatically from `scenes/core/main_game.tscn`.

## Controls

- Move: WASD, arrow keys, or left stick.
- Fire: Space or gamepad A.
- Charge laser: hold Space until the charge ring completes, then release.
- Bomb: X.
- Focus/slow movement: Shift, F, or gamepad left bumper.
- Start/retry: Enter or Start.
- Pause: Escape or Start during play.

## Current Gameplay

- Press Enter on the title screen.
- Fly inside the centered 4:3 playfield.
- Watch for the generated Sky Arc Breach industrial background scrolling beneath the action.
- Hold fire to shoot Twin Vulcan shots.
- Destroy incoming enemy waves to build score and combo.
- Survive until the boss warning, then defeat Null Relay Seraph.
- Defeating the boss triggers the weapon acquired screen.
- If shields are gone, hits consume lives and respawn the player.

## Known Limitations

- Generated placeholder sprites are in use, but they are not final art.
- Procedural SFX are wired directly into the prototype scene; they should move to an `AudioManager` later.
- GitHub Pages export may still fail until Godot accepts and imports the new main scene in CI.
