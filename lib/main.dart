import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:rive/rive.dart' as rive;

import 'slides/betclic/betclic_brand.dart';
import 'slides/betclic/betclic_content_slides.dart';
import 'slides/betclic/betclic_cover_slides.dart';
import 'slides/advanced_slides.dart';
import 'slides/betclic/betclic_video_slide.dart';
import 'slides/build_game_slides.dart';
import 'slides/panel_memory_slide.dart';
import 'slides/rive_intro_slides.dart';
import 'slides/rive_step_slides.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await rive.RiveNative.init();
  runApp(const MeetupDeck());
}

class MeetupDeck extends StatelessWidget {
  const MeetupDeck({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterDeckApp(
      configuration: const FlutterDeckConfiguration(
        background: FlutterDeckBackgroundConfiguration(
          light: FlutterDeckBackground.solid(Color(0xFFFAFAFA)),
          dark: FlutterDeckBackground.solid(Color(0xFF111111)),
        ),
        controls: FlutterDeckControlsConfiguration(
          shortcuts: FlutterDeckShortcutsConfiguration(enabled: true),
        ),
        progressIndicator: FlutterDeckProgressIndicator.solid(
          color: Color(0xFFEC407A),
          backgroundColor: Color(0x33EC407A),
        ),
      ),
      slides: [
        const BetclicCoverSlide(
          title: 'Rive × Flutter',
          subtitle: 'Animate your apps like never before',
          date: '27/05/2026',
        ),
        WhatsRiveSlide(pageNumber: 2),
        RiveVsLottieImageSlide(pageNumber: 3),
        RiveVsFlutterAnimateSlide(pageNumber: 4),
        const BuildIntroSlide(),
        const MinigameSlide(),
        BetclicVideoSlide(
          route: '/rive-step-1-video',
          title: 'Design',
          asset: 'assets/record_step_1.mp4',
          pageNumber: 5,
        ),
        RiveStep1Slide(pageNumber: 6),
        BetclicVideoSlide(
          route: '/rive-step-2-video',
          title: 'Animation & Data Binding',
          asset: 'assets/record_step_2.mp4',
          pageNumber: 7,
        ),
        RiveStep2Slide(pageNumber: 8),
        BetclicVideoSlide(
          route: '/rive-step-3-video',
          title: 'Customization',
          asset: 'assets/record_step_3.mp4',
          pageNumber: 9,
        ),
        RiveStep3Slide(pageNumber: 10),
        BetclicStatementSlide(
          route: '/statement',
          title: 'Key takeaway',
          pageNumber: 11,
          spans: const [
            BetclicSpan.plain('Rive lets design and engineering share '),
            BetclicSpan.red('one source of truth'),
            BetclicSpan.plain(' — and Flutter drives it with '),
            BetclicSpan.yellow('type-safe Dart'),
            BetclicSpan.plain('.'),
          ],
        ),
        PanelMemorySlide(pageNumber: 12),
        AssetStrategySlide(pageNumber: 13),
        GeneratorSlide(pageNumber: 14),
        const BetclicQaSlide(),
        const BetclicThankYouSlide(
          subtitle: 'Now find the A of hearts →',
          playUrl: 'https://tguerin.github.io/flutter_meetup_rive/play/',
        ),
      ],
    );
  }
}
