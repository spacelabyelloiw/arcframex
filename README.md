# Arc Frame X

Godot 4.x vertical scrolling 2D shooter based on `arc_frame_x_codex_ready_game_design_document.md`.

The first target is a polished first playable: title screen, menu, one complete intro level, player movement/combat, pickups, checkpoint, one boss, basic scoring, procedural sound effects, generated placeholder sprites, and a Web export deployed to GitHub Pages.

## Recommended Stack

- Engine: Godot 4.6.x stable, non-.NET editor/export templates.
- Language: GDScript first. Avoid C# because Godot 4 Web export does not support C# projects.
- Rendering: high-resolution 2D sprites with pixel-art-inspired edges, 960x720 logical 4:3 playfield inside 16:9 presentation.
- Audio: procedural SFX through Godot audio generation first; composed music can be added later.
- Data: JSON for early tuning and content tables, with an optional migration to custom Godot `Resource` classes once patterns stabilize.
- Deploy: GitHub Actions exports the Web build and deploys the artifact to GitHub Pages on every push to `main`.

## Key Docs

- [Implementation plan](docs/IMPLEMENTATION_PLAN.md)
- [Tech stack](docs/TECH_STACK.md)
- [Future bot handoff](docs/FUTURE_BOT_HANDOFF.md)
- [GitHub Pages deployment](docs/DEPLOYMENT_GITHUB_PAGES.md)
- [Procedural audio plan](docs/PROCEDURAL_AUDIO.md)
- [Generated asset guide](docs/GENERATED_ASSET_GUIDE.md)
- [Data schemas](docs/DATA_SCHEMAS.md)

## Local Setup

1. Install Godot 4.6.x stable.
2. Open this folder as a Godot project.
3. Keep gameplay code in `scripts/`, scenes in `scenes/`, data in `data/`, and source art/audio in `assets/`.
4. Use the `Web` export preset for browser builds.

## Current Repo State

This repository currently contains planning docs, a Godot project shell, an export preset, and a GitHub Pages workflow. The next implementation step is to create the first playable vertical-slice scene structure.

