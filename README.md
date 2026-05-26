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
flutter run -d chrome
```

## Deploy to GitHub Pages

1. Push to `main`.
2. **One-time**: GitHub → repo Settings → Pages → Build and deployment →
   Source = **GitHub Actions**.
3. The `.github/workflows/deploy.yml` action builds with
   `--base-href "/flutter_meetup_rive/"` and publishes `build/web`.
4. URL: `https://<owner>.github.io/flutter_meetup_rive/`.

The workflow uses `jdx/mise-action`, so the Flutter version pinned in
`mise.toml` is also the one CI uses — no version drift.

## flutter_deck shortcuts

Defaults from `flutter_deck`: arrow keys / page-up / page-down to navigate,
`f` to toggle fullscreen, `m` for marker mode. See
[flutter_deck docs](https://flutterdeck.dev) for the full list.
