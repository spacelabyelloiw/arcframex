# GitHub Pages Deployment

## Goal

Every push to `main` should export the Godot Web build and deploy it to GitHub Pages.

## Repo Settings Required

1. Push this project to GitHub.
2. Open repository settings.
3. Go to **Pages**.
4. Set **Source** to **GitHub Actions**.
5. Push to `main` or run `Deploy Godot Web to GitHub Pages` manually from the Actions tab.

## Workflow

The workflow is `.github/workflows/deploy-godot-pages.yml`.

It does the following:

- Checks out the repo.
- Downloads Godot and matching export templates.
- Exports the `Web` preset to `build/web/index.html`.
- Uploads the export as a Pages artifact.
- Deploys the artifact to the `github-pages` environment.

## Important Notes

- Use the non-.NET Godot build for Web exports.
- Do not commit `build/` or `exports/`; CI rebuilds them.
- The workflow currently pins Godot to `4.6.2-stable`.
- If Godot changes export preset keys in a future version, open the project in the target Godot editor, re-save `export_presets.cfg`, and commit the diff.

