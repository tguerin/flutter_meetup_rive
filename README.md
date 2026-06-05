# flutter_meetup_rive

A live demo deck for a Rive + Flutter meetup talk. Built with
[`flutter_deck`](https://pub.dev/packages/flutter_deck), driven by a
strongly-typed Rive ViewModel (`rive_viewmodel` + `rive_viewmodel_generator`).

The single demo slide hosts an interactive card animation: a HUD lets you
trigger flip / bump / switch states, edit the card value and suit, recolor
the back, and bind dynamic logos into the back-card asset slot — all from
typed Dart bindings.

## Run locally

```bash
mise install            # one-time — installs Flutter 3.41.9 per mise.toml
flutter pub get
flutter run -d chrome                          # the slide deck (default)
flutter run -d chrome -t lib/main_game.dart    # the standalone mini-game

# Native macOS deck — the designer recordings are embedded in the app bundle
# (they play instantly, offline). The `desktop` flavor is REQUIRED: it's what
# bundles the `assets/record_step_*.mp4` videos (flavor-conditional assets).
flutter run -d macos --flavor desktop -t lib/main.dart
```

> The mp4 recordings are tagged with the `desktop` flavor in `pubspec.yaml`, so
> they are **only** bundled in the macOS build. The web builds (no flavor) omit
> them — keeping the GitHub Pages deploy light — and the video slides show a
> "shown live in the desktop build" placeholder there. Running macOS **without**
> `--flavor desktop` builds the deck but leaves the videos out.

## Deploy to GitHub Pages

1. Push to `main`.
2. **One-time**: GitHub → repo Settings → Pages → Build and deployment →
   Source = **GitHub Actions**.
3. The `.github/workflows/deploy.yml` action builds **two** Flutter web
   targets and stitches them into one artifact:
   - `lib/main.dart`     → root (`--base-href "/flutter_meetup_rive/"`)
   - `lib/main_game.dart` → `/play/` (`--base-href "/flutter_meetup_rive/play/"`)
4. URLs:
   - Slides: `https://<owner>.github.io/flutter_meetup_rive/`
   - Mini-game: `https://<owner>.github.io/flutter_meetup_rive/play/`

The workflow uses `jdx/mise-action`, so the Flutter version pinned in
`mise.toml` is also the one CI uses — no version drift.

## flutter_deck shortcuts

Defaults from `flutter_deck`: arrow keys / page-up / page-down to navigate,
`f` to toggle fullscreen, `m` for marker mode. See
[flutter_deck docs](https://flutterdeck.dev) for the full list.
