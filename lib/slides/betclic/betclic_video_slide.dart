import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:video_player/video_player.dart';

import 'betclic_brand.dart';
import 'betclic_frame.dart';

/// A slide that plays a designer screen-recording (how a Rive step was built)
/// inside the standard Betclic frame. The video auto-plays, loops and is
/// muted; tap to pause / resume.
class BetclicVideoSlide extends FlutterDeckSlideWidget {
  BetclicVideoSlide({
    super.key,
    required String route,
    required this.title,
    required this.asset,
    this.subtitle,
    this.pageNumber,
  }) : super(
         configuration: FlutterDeckSlideConfiguration(
           route: route,
           title: title,
         ),
       );

  final String title;
  final String asset;
  final String? subtitle;
  final int? pageNumber;

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (_) => BetclicFrame(
        title: title,
        pageNumber: pageNumber,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (subtitle != null) ...[
              Text(
                subtitle!,
                style: TextStyle(
                  fontFamily: BetclicBrand.fontFamily,
                  fontSize: 17,
                  height: 1.4,
                  color: BetclicBrand.muted,
                ),
              ),
              const SizedBox(height: 18),
            ],
            Expanded(child: _VideoPlayer(asset: asset)),
          ],
        ),
      ),
    );
  }
}

class _VideoPlayer extends StatefulWidget {
  const _VideoPlayer({required this.asset});

  final String asset;

  @override
  State<_VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<_VideoPlayer> {
  late final VideoPlayerController _controller;
  bool _ready = false;
  bool _failed = false;
  bool _paused = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.asset)
      ..setLooping(true)
      ..setVolume(0);
    // The recordings are bundled only in the macOS `desktop` flavor (see
    // pubspec.yaml), so on web the asset is absent and init throws — fall back
    // to a static placeholder instead of spinning forever.
    _controller
        .initialize()
        .then((_) {
          if (!mounted) return;
          setState(() => _ready = true);
          _controller.play();
        })
        .catchError((_) {
          if (!mounted) return;
          setState(() => _failed = true);
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      if (_paused) {
        _controller.play();
        _paused = false;
      } else {
        _controller.pause();
        _paused = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_failed) {
      return const _VideoUnavailable();
    }
    if (!_ready) {
      return const Center(child: CircularProgressIndicator());
    }
    return Center(
      child: GestureDetector(
        onTap: _toggle,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 30,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  VideoPlayer(_controller),
                  if (_paused)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.45),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 44,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Shown when the recording isn't bundled (e.g. the web build, where the
/// videos are excluded to keep the deploy light). The clip plays in the
/// native macOS `desktop` build.
class _VideoUnavailable extends StatelessWidget {
  const _VideoUnavailable();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 36),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F2F5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: BetclicBrand.border, width: 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: BetclicBrand.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Screen recording — shown live in the desktop build',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: BetclicBrand.fontFamily,
                fontSize: 15,
                color: BetclicBrand.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
