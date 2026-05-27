import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:rive/rive.dart' as rive;

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
      slides: const [InteractiveCardSlide()],
    );
  }
}
