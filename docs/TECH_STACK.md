# Tech Stack

## Chosen Stack

- **Godot:** 4.6.x stable, non-.NET build.
- **Language:** GDScript.
- **Target exports:** Windows first, Web/GitHub Pages for continuous playable builds.
- **Rendering:** 2D scenes, sprite sheets, parallax backgrounds, tilemaps for collision/layout where useful.
- **Audio:** procedural SFX generated in-engine first, later replace or layer with authored WAV/OGG assets.
- **Data:** JSON files for first-build tuning and content tables.
- **Version control:** GitHub, with a Pages deploy workflow on every push to `main`.

## Rationale

Godot 4.x matches the GDD: strong 2D tooling, scene composition, controller support, and accessible export flow. GDScript keeps iteration fast and avoids the Godot 4 C# Web export limitation documented by Godot.

Use JSON early because future bots can inspect, diff, and tune it easily. Move stable schemas into Godot `Resource` classes only when editor tooling becomes more valuable than raw text.

## External References

- Godot 4.6.2 was the latest stable GitHub release found during setup on 2026-04-27: https://github.com/godotengine/godot/releases
- Godot Web export notes: https://docs.godotengine.org/en/4.5/tutorials/export/exporting_for_web.html
- GitHub Pages custom workflow docs: https://docs.github.com/pages/getting-started-with-github-pages/using-custom-workflows-with-github-pages

