import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:rive/rive.dart' as rive;

import 'slides/betclic/betclic_brand.dart';
import 'slides/betclic/betclic_content_slides.dart';
import 'slides/betclic/betclic_cover_slides.dart';
import 'slides/interactive_card_slide.dart';

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
        const BetclicWelcomeSlide(
          title: 'Rive × Flutter',
          subtitle: 'Bringing designer animations to life in Dart',
          date: '27/05/2026',
        ),
        BetclicBulletSlide(
          route: '/agenda',
          title: 'Agenda',
          pageNumber: 2,
          bullets: const [
            'What Rive is and why it fits Flutter',
            'State machines & data binding',
            'Strongly-typed View Models from Dart',
            'Live demo: the interactive card',
          ],
        ),
        BetclicContentSlide(
          route: '/content',
          title: 'Your section title',
          pageNumber: 3,
        ),
        const InteractiveCardSlide(),
        BetclicStatementSlide(
          route: '/statement',
          title: 'Key takeaway',
          pageNumber: 5,
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
