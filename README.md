# Rive × Flutter — meetup deck

A live, runnable talk on bringing designer animations into Flutter with
[Rive](https://rive.app). The whole presentation is a Flutter app built with
[`flutter_deck`](https://pub.dev/packages/flutter_deck): the slides are widgets,
and the "demo" slides are the **real, interactive** Rive integrations the talk
is about — not screenshots.

Speakers: **Thomas Guerin** (Staff Software Engineer) · **Nicolas Faveraux**
(Motion Designer).

## What's in the deck

1. **Cover** — title + speakers.
2. **What's Rive?** — the editor and what it produces.
3. **Rive vs Lottie** — one game screen → the 11 Lottie JSON exports it takes
   (~990 Kb) → a single bound `.riv` (42 Kb) playing live.
4. **Rive in action** — a montage of real Rive-powered UI.
5. **Rive vs Flutter Animate** — the pile of imperative animation code you'd
   hand-write in Flutter, revealed one screenshot at a time.
6. **Let's build a game → the game** — a section break, then the **live,
   playable** mini-game (the "bento" of animated pieces; the card is the hero).
7. **Rive 1–3** — three build steps, each a designer screen-recording followed
   by a *code + live result* slide:
   - **Design** — two artboards, switched at runtime by rebuilding a
     `RiveWidgetController` off the same loaded `File`.
   - **Animation & Data Binding** — `RiveWidgetBuilder` + a bound view-model
     instance; the flip is driven from Dart via `triggerFlip`.
   - **Customization** — nested back/front view models drive colour, value,
     suit and a decoded image; tweak it live from the HUD.
8. **Key takeaway.**
9. **RivePanel** — a 4×4 memory/pairs game: 16 independent Rive card instances
   sharing **one** GPU texture via `RivePanel` + `useSharedTexture`.
10. **Loading referenced assets** — file-scoped `AssetLoader` vs
    instance-scoped data binding.
11. **Generate typed view models** — the raw, string-based binding API
    side-by-side with a generated typed API
    ([`tguerin/rive-viewmodel-generator`](https://github.com/tguerin/rive-viewmodel-generator);
    Rive's own [`rive-code-generator-wip`](https://github.com/rive-app/rive-code-generator-wip)
    is still WIP).
12. **Q&A** and **Thank you** — with a QR code to play the mini-game.

The card demos talk to Rive through the **plain data-binding API**
(`vmi.viewModel(...)`, `.string()`, `.trigger()`, `.image()`, …); the typed
generator is the subject of slide 11. All rendering uses the native
`Factory.rive` renderer.

## Run locally

```bash
mise install            # one-time — installs the pinned Flutter (see mise.toml)
flutter pub get

# The deck (web)
flutter run -d chrome

# The deck (native macOS) — REQUIRED to bundle the screen recordings.
# The `record_step_*.mp4` videos are tagged with the `desktop` flavor, so only
# the macOS build embeds them (plays instantly, offline). Without the flavor
# the deck still runs, but those video slides show a placeholder.
flutter run -d macos --flavor desktop -t lib/main.dart

# The standalone mini-game (also deployed at /play/)
flutter run -d chrome -t lib/main_game.dart
```

> **Why the flavor?** The three designer recordings are ~150 MB. Flavor-tagging
> them keeps them out of the no-flavor **web** build (light GitHub Pages deploy)
> while embedding them in the **macOS** build. The shorter clips (montage,
> Lottie-vs-Rive) are compressed and bundled everywhere.

## Presenting

Navigate with the **arrow keys** or **Page Up / Page Down** (so a Logitech-style
presenter remote works). Multi-step slides (e.g. the code fades, the code pile)
advance step-by-step. `f` toggles fullscreen, `m` is marker mode — see the
[flutter_deck docs](https://flutterdeck.dev).

## Project structure

```
lib/
  main.dart                     # the deck: app config + ordered slide list
  main_game.dart                # standalone mini-game entrypoint (/play/)
  slides/
    betclic/                    # brand kit: colours, backgrounds, frame, code/
                                #   video/cover slide templates
    rive_intro_slides.dart      # What's Rive / Rive vs Lottie / vs Flutter Animate
    rive_step_slides.dart       # Rive 1–3 code slides (+ snippets)
    build_game_slides.dart      # "Let's build a game" + live mini-game slide
    panel_memory_slide.dart     # RivePanel 4×4 memory game
    advanced_slides.dart        # asset strategy + view-model generators
  rive/
    card_step_demos.dart        # the interactive card demos (steps 1–3)
    demo_flutter_minigame_viewmodel.rive.dart  # generated VM for the mini-game
  minigame/                     # mini-game widget + controller
  widgets/                      # dependency-free Dart syntax highlighter / code panel
assets/                         # .riv files, slide PNGs, mp4 clips, brand art
```

Key packages: `rive`, `rive_viewmodel`, `flutter_deck`, `video_player`,
`qr_flutter`.

## Deploy to GitHub Pages

1. Push to `main`.
2. **One-time**: GitHub → repo Settings → Pages → Build and deployment →
   Source = **GitHub Actions**.
3. `.github/workflows/deploy.yml` builds **two** web targets and stitches them
   into one artifact:
   - `lib/main.dart`      → root (`--base-href "/flutter_meetup_rive/"`)
   - `lib/main_game.dart` → `/play/` (`--base-href "/flutter_meetup_rive/play/"`)
4. URLs:
   - Slides: `https://<owner>.github.io/flutter_meetup_rive/`
   - Mini-game: `https://<owner>.github.io/flutter_meetup_rive/play/`

The workflow uses `jdx/mise-action`, so CI builds with the same Flutter version
pinned in `mise.toml` — no version drift.
