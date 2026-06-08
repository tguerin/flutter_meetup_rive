import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:video_player/video_player.dart';

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

/// "Rive vs Lottie" — three columns, chevron-separated: the game screen, the
/// pile of 11 Lotties it takes, and the single bound `.riv` (logo + the live
/// reward animation).
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1 — the game screen.
            Expanded(
              child: Center(
                child: Image.asset('assets/game_screen.png', fit: BoxFit.contain),
              ),
            ),
            const _Chevron(),
            // 2 — the 11 Lotties it takes.
            Expanded(
              child: Center(
                child: Image.asset('assets/lottie_files.png', fit: BoxFit.contain),
              ),
            ),
            const _Chevron(),
            // 3 — the single .riv: logo on top of the live reward animation.
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/rive_logo.png', height: 120),
                    const SizedBox(height: 10),
                    const Text(
                      'ic_reward.riv',
                      style: TextStyle(
                        fontFamily: BetclicBrand.fontFamily,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: BetclicBrand.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      '42 kb',
                      style: TextStyle(
                        fontFamily: BetclicBrand.fontFamily,
                        fontSize: 17,
                        fontStyle: FontStyle.italic,
                        color: BetclicBrand.muted,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Fixed size (no Flexible) so the logo + label + video stay
                    // a tight group that Center keeps vertically centered.
                    const SizedBox(
                      width: 440,
                      height: 318,
                      child: _LoopingVideo(asset: 'assets/lottie_vs_rive.mp4'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The grey double-chevron used to separate the three columns.
class _Chevron extends StatelessWidget {
  const _Chevron();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Image.asset('assets/arrow_chevron.png', width: 56),
    );
  }
}

/// A small looping, muted, auto-playing video used inline on a slide.
class _LoopingVideo extends StatefulWidget {
  const _LoopingVideo({required this.asset});

  final String asset;

  @override
  State<_LoopingVideo> createState() => _LoopingVideoState();
}

class _LoopingVideoState extends State<_LoopingVideo> {
  late final VideoPlayerController _controller;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.asset)
      ..setLooping(true)
      ..setVolume(0);
    _controller
        .initialize()
        .then((_) {
          if (!mounted) return;
          setState(() => _ready = true);
          _controller.play();
        })
        .catchError((_) {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Center(child: CircularProgressIndicator());
    }
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }
}

/// "Rive vs Flutter Animate" — to hand-roll the same thing in Flutter you write
/// a *lot* of imperative animation spec code. Each "next" fades in another
/// screenshot, scattered and overlapping, so the pile visibly grows.
class RiveVsFlutterAnimateSlide extends FlutterDeckSlideWidget {
  RiveVsFlutterAnimateSlide({super.key, this.pageNumber})
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/rive-vs-flutter-animate',
          title: 'Rive vs Flutter Animate',
          steps: 5, // == _cards.length
        ),
      );

  final int? pageNumber;

  // Scattered, rotated, overlapping placements — deliberately misorganized.
  // Large so the code stays readable; overlap/overflow is intentional.
  static const _cards = <({String asset, Alignment align, double angle, double width})>[
    (asset: 'assets/anim_code_2.png', align: Alignment(-0.92, -0.7), angle: -0.05, width: 620),
    (asset: 'assets/anim_code_3.png', align: Alignment(0.6, -0.72), angle: 0.06, width: 600),
    (asset: 'assets/anim_code_6.png', align: Alignment(0.05, 0.02), angle: -0.03, width: 600),
    (asset: 'assets/anim_code_4.png', align: Alignment(-0.7, 0.85), angle: 0.05, width: 660),
    (asset: 'assets/anim_code_5.png', align: Alignment(0.78, 0.78), angle: -0.06, width: 620),
  ];

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (_) => BetclicFrame(
        title: 'Rive vs Flutter Animate',
        pageNumber: pageNumber,
        child: FlutterDeckSlideStepsBuilder(
          builder: (context, step) => Stack(
            clipBehavior: Clip.none,
            children: [
              for (var i = 0; i < _cards.length; i++)
                Align(
                  alignment: _cards[i].align,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOut,
                    opacity: step > i ? 1 : 0,
                    child: Transform.rotate(
                      angle: _cards[i].angle,
                      // Filter the rotated layer so the card edges/text aren't
                      // jagged.
                      filterQuality: FilterQuality.medium,
                      child: _CodeCard(
                        asset: _cards[i].asset,
                        width: _cards[i].width,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A floating "code screenshot" card with rounded corners + shadow.
class _CodeCard extends StatelessWidget {
  const _CodeCard({required this.asset, required this.width});

  final String asset;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          asset,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.medium,
        ),
      ),
    );
  }
}
