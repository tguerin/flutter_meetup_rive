import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../minigame/minigame_controller.dart';
import '../minigame/minigame_widget.dart';
import '../rive/demo_flutter_minigame_viewmodel.rive.dart';
import 'betclic/betclic_brand.dart';

/// Section divider — "Let's build a game". Dark Betclic backdrop, big headline.
class BuildIntroSlide extends FlutterDeckSlideWidget {
  const BuildIntroSlide({super.key})
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/build-intro',
          title: "Let's build a game",
        ),
      );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (_) => BetclicBackground(
        asset: BetclicBg.section,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Let's build a game",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: BetclicBrand.fontFamily,
                  fontSize: 64,
                  fontWeight: FontWeight.w800,
                  height: 1.05,
                  letterSpacing: -0.5,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The live, playable mini-game (the "bento" of animated pieces) — shown
/// full-screen, no chrome.
class MinigameSlide extends FlutterDeckSlideWidget {
  const MinigameSlide({super.key})
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/minigame',
          title: 'The game',
        ),
      );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(builder: (_) => const _LiveMinigame());
  }
}

/// Wires the real [MinigameWidget] to a [MinigameController] so the game is
/// fully playable on the slide (same wiring as `lib/main_game.dart`).
class _LiveMinigame extends StatefulWidget {
  const _LiveMinigame();

  @override
  State<_LiveMinigame> createState() => _LiveMinigameState();
}

class _LiveMinigameState extends State<_LiveMinigame> {
  VmMiniGameViewModel? _vm;
  MinigameController? _controller;

  void _onViewModel(VmMiniGameViewModel vm) {
    _vm = vm;
    _controller = MinigameController(vm);
  }

  @override
  void dispose() {
    _controller?.dispose();
    _vm?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MinigameWidget(onViewModel: _onViewModel);
  }
}
