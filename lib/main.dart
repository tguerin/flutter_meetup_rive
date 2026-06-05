import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:rive/rive.dart' as rive;

import 'slides/betclic/betclic_brand.dart';
import 'slides/betclic/betclic_content_slides.dart';
import 'slides/betclic/betclic_cover_slides.dart';
import 'slides/betclic/betclic_video_slide.dart';
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
          shortcuts: FlutterDeckShortcutsConfiguration(
            enabled: true,
          ),
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
        const BetclicWelcomeSlide(),
        BetclicBulletSlide(
          route: '/agenda',
          title: 'Agenda',
          pageNumber: 2,
          bullets: const [
            'What Rive is and why it fits Flutter',
            'Rive vs Lottie',
            'State machines & data binding',
            'Strongly-typed View Models from Dart',
            'Live demo: the interactive card',
          ],
        ),
        WhatsRiveSlide(pageNumber: 3),
        RiveVsLottieImageSlide(pageNumber: 4),
        RiveVsLottieBulletsSlide(pageNumber: 5),
        BetclicVideoSlide(
          route: '/rive-step-1-video',
          title: 'Rive 1 — Design',
          subtitle: 'How the designer built it in the Rive editor.',
          asset: 'assets/record_step_1.mp4',
          pageNumber: 6,
        ),
        RiveStep1Slide(pageNumber: 7),
        BetclicVideoSlide(
          route: '/rive-step-2-video',
          title: 'Rive 2 — Animation & data binding',
          subtitle: 'How the designer built it in the Rive editor.',
          asset: 'assets/record_step_2.mp4',
          pageNumber: 8,
        ),
        RiveStep2Slide(pageNumber: 9),
        BetclicVideoSlide(
          route: '/rive-step-3-video',
          title: 'Rive 3 — Customization',
          subtitle: 'How the designer built it in the Rive editor.',
          asset: 'assets/record_step_3.mp4',
          pageNumber: 10,
        ),
        RiveStep3Slide(pageNumber: 11),
        BetclicStatementSlide(
          route: '/statement',
          title: 'Key takeaway',
          pageNumber: 12,
          spans: const [
            BetclicSpan.plain('Rive lets design and engineering share '),
            BetclicSpan.red('one source of truth'),
            BetclicSpan.plain(' — and Flutter drives it with '),
            BetclicSpan.yellow('type-safe Dart'),
            BetclicSpan.plain('.'),
          ],
        ),
        const BetclicQaSlide(),
        const BetclicThankYouSlide(
          subtitle: 'Now find the A of hearts →',
          playUrl: 'https://tguerin.github.io/flutter_meetup_rive/play/',
        ),
      ],
    );
  }
}
