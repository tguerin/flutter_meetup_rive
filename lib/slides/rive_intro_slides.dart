import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

import 'betclic/betclic_brand.dart';
import 'betclic/betclic_frame.dart';

/// "What's Rive?" — the Rive logo on top, the rive.app landing page centered
/// below it, on the white content background.
class WhatsRiveSlide extends FlutterDeckSlideWidget {
  WhatsRiveSlide({super.key, this.pageNumber})
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/whats-rive',
          title: "What's Rive?",
        ),
      );

  final int? pageNumber;

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (_) => BetclicFrame(
        title: "What's Rive?",
        pageNumber: pageNumber,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/rive_logo.png', height: 96),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                // Fade the dark screenshot out vertically so it blends into
                // the white slide instead of ending on a hard edge.
                child: ShaderMask(
                  blendMode: BlendMode.dstIn,
                  shaderCallback: (rect) => const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white, Colors.white, Colors.transparent],
                    stops: [0.0, 0.5, 1.0],
                  ).createShader(rect),
                  child: Image.asset(
                    'assets/rive_main_page.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Rive vs Lottie" — the comparison image (many Lottie exports vs one bound
/// `.riv`).
class RiveVsLottieImageSlide extends FlutterDeckSlideWidget {
  RiveVsLottieImageSlide({super.key, this.pageNumber})
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/rive-vs-lottie-image',
          title: 'Rive vs Lottie',
        ),
      );

  final int? pageNumber;

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (_) => BetclicFrame(
        title: 'Rive vs Lottie',
        pageNumber: pageNumber,
        child: Center(
          child: Image.asset('assets/lottie_vs_rive.png', fit: BoxFit.contain),
        ),
      ),
    );
  }
}

/// "Rive vs Lottie" — what Rive does that Lottie can't (easily).
class RiveVsLottieBulletsSlide extends FlutterDeckSlideWidget {
  RiveVsLottieBulletsSlide({super.key, this.pageNumber})
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/rive-vs-lottie-bullets',
          title: 'Rive vs Lottie — why Rive',
        ),
      );

  final int? pageNumber;

  static const _bullets = <String>[
    'Interactivity & state machines — react to input, not just play a fixed timeline',
    'Data binding — drive text, colors, numbers and images at runtime from Dart',
    'Runtime customization — recolor, swap assets, change values without re-exporting',
    'One file, many variants — a single .riv replaces dozens of Lottie JSON exports (smaller bundle)',
    'Two-way events — the animation can call back into your app',
    'Design, animate and wire logic in one editor — no per-change developer round-trip',
  ];

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (_) => BetclicFrame(
        title: 'Rive vs Lottie — why Rive',
        pageNumber: pageNumber,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final b in _bullets)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 9, right: 18),
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: BetclicBrand.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        b,
                        style: const TextStyle(
                          fontFamily: BetclicBrand.fontFamily,
                          fontSize: 23,
                          height: 1.3,
                          color: BetclicBrand.ink,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
