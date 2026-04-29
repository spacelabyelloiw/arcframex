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
- Focus/slow movement: Shift, F, or gamepad left bumper.
- Start/retry: Enter or Start.
- Pause: Escape or Start during play.

## Current Gameplay

- Press Enter on the title screen.
- Fly inside the centered 4:3 playfield.
- Hold fire to shoot Twin Vulcan shots.
- Destroy incoming enemy waves to build score and combo.
- Survive for 90 seconds to clear the prototype route.
- If shields are gone, hits consume lives and respawn the player.

## Known Limitations

- No boss yet.
- No authored/generated sprite sheets yet; this slice uses code-drawn placeholder ships.
- Procedural SFX definitions exist, but runtime sound generation is not wired in yet.
- GitHub Pages export may still fail until Godot accepts and imports the new main scene in CI.

