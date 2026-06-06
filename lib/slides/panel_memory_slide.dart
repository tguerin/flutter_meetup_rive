// RivePanel is still marked experimental in the rive package; it's the
// intended API for sharing one texture across many RiveWidgets.
// ignore_for_file: experimental_member_use
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:rive/rive.dart' as rive;

import '../widgets/code_panel.dart';
import 'betclic/betclic_frame.dart';

/// Slide: explains [rive.RivePanel] (one shared texture for many RiveWidgets)
/// and proves it with a live 16-card (4×4) memory / pairs game — every card is
/// its own Rive instance, all painting into a single panel.
class PanelMemorySlide extends FlutterDeckSlideWidget {
  PanelMemorySlide({super.key, this.pageNumber})
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/rive-panel',
          title: 'RivePanel',
        ),
      );

  final int? pageNumber;

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (_) => BetclicFrame(
        title: 'RivePanel: one texture, many cards',
        pageNumber: pageNumber,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(
              flex: 5,
              child: Center(
                child: CodePanel(
                  code: _panelCode,
                  label: 'RIVE PANEL',
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 32),
            const Expanded(
              flex: 6,
              child: Center(
                child: AspectRatio(aspectRatio: 1, child: _MemoryGame()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The RivePanel usage shown on the left of the slide.
const String _panelCode = '''
// One shared GPU texture for every card → cheap, and it dodges
// the browser's WebGL-context limit.
RivePanel(
  child: GridView.count(
    crossAxisCount: 4,
    children: [
      for (final card in cards)
        RiveWidgetBuilder(
          fileLoader: sharedLoader, // the .riv is loaded once
          artboardSelector: ArtboardSelector.byName('Card'),
          stateMachineSelector: StateMachineSelector.byName('SmCard'),
          builder: (context, state) => switch (state) {
            RiveLoaded() => RiveWidget(
              controller: state.controller,
              useSharedTexture: true, // ← paints into the panel
            ),
            _ => const SizedBox.shrink(),
          },
        ),
    ],
  ),
);
''';

/// One card in the grid: value + suit, plus its bound view-model instance.
class _Card {
  _Card(this.value, this.suit);

  final String value;
  final String suit;
  rive.ViewModelInstance? vmi;
  bool faceUp = false;
  bool matched = false;

  // `triggerFlip` is the animated toggle between back and face. We track the
  // visible side in Dart and fire it whenever we want to flip.
  void flip() => vmi?.trigger('triggerFlip')?.trigger();
}

class _MemoryGame extends StatefulWidget {
  const _MemoryGame();

  @override
  State<_MemoryGame> createState() => _MemoryGameState();
}

class _MemoryGameState extends State<_MemoryGame> {
  late final rive.FileLoader _fileLoader = rive.FileLoader.fromAsset(
    'assets/card_step_3.riv',
    riveFactory: rive.Factory.rive,
  );

  // 8 distinct faces; each appears twice → 16 cards.
  static const _faces = <({String value, String suit})>[
    (value: 'A', suit: 'heart'),
    (value: 'K', suit: 'spade'),
    (value: 'Q', suit: 'diamond'),
    (value: 'J', suit: 'club'),
    (value: '10', suit: 'heart'),
    (value: '9', suit: 'spade'),
    (value: '8', suit: 'diamond'),
    (value: '7', suit: 'club'),
  ];

  late final List<_Card> _cards = [
    for (final f in _faces) ...[_Card(f.value, f.suit), _Card(f.value, f.suit)],
  ]..shuffle(Random(42));
  int? _firstUp; // index of the first revealed card awaiting a match
  bool _busy = false; // true during the mismatch flip-back delay

  @override
  void dispose() {
    for (final c in _cards) {
      c.vmi?.dispose();
    }
    _fileLoader.dispose();
    super.dispose();
  }

  void _onTap(int i) {
    final card = _cards[i];
    if (_busy || card.matched || card.faceUp) return;

    card.flip();
    setState(() => card.faceUp = true);

    if (_firstUp == null) {
      _firstUp = i;
      return;
    }

    final first = _cards[_firstUp!];
    if (first.value == card.value && first.suit == card.suit) {
      // Match — both stay face-up.
      setState(() {
        first.matched = true;
        card.matched = true;
        _firstUp = null;
      });
    } else {
      // Mismatch — flip both back after a beat.
      final firstIndex = _firstUp!;
      _busy = true;
      _firstUp = null;
      Timer(const Duration(milliseconds: 900), () {
        if (!mounted) return;
        _cards[firstIndex].flip();
        card.flip();
        setState(() {
          _cards[firstIndex].faceUp = false;
          card.faceUp = false;
          _busy = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return rive.RivePanel(
      child: GridView.count(
        crossAxisCount: 4,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          for (var i = 0; i < _cards.length; i++)
            GestureDetector(
              onTap: () => _onTap(i),
              child: _CardView(
                fileLoader: _fileLoader,
                value: _cards[i].value,
                suit: _cards[i].suit,
                onReady: (vmi) => _cards[i].vmi = vmi,
              ),
            ),
        ],
      ),
    );
  }
}

/// A single card rendered through the shared RivePanel texture.
class _CardView extends StatelessWidget {
  const _CardView({
    required this.fileLoader,
    required this.value,
    required this.suit,
    required this.onReady,
  });

  final rive.FileLoader fileLoader;
  final String value;
  final String suit;
  final ValueChanged<rive.ViewModelInstance> onReady;

  @override
  Widget build(BuildContext context) {
    return rive.RiveWidgetBuilder(
      fileLoader: fileLoader,
      artboardSelector: rive.ArtboardSelector.byName('Card'),
      stateMachineSelector: rive.StateMachineSelector.byName('SmCard'),
      onLoaded: (state) {
        final vmi = state.file
            .defaultArtboardViewModel(state.controller.artboard)
            ?.createDefaultInstance();
        if (vmi == null) return;
        state.controller.stateMachine.bindViewModelInstance(vmi);
        final front = vmi.viewModel('propertyOfVmFrontCard');
        front?.string('valueCard')?.value = value;
        front?.enumerator('cardSymbol')?.value = suit;
        // Start face-down: if the artboard defaults to the face, flip it back.
        if (vmi.boolean('isFaceVisible')?.value ?? false) {
          vmi.trigger('triggerFlip')?.trigger();
        }
        onReady(vmi);
      },
      builder: (context, state) => switch (state) {
        rive.RiveLoaded() => rive.RiveWidget(
          controller: state.controller,
          fit: rive.Fit.contain,
          useSharedTexture: true,
        ),
        rive.RiveLoading() => const SizedBox.shrink(),
        rive.RiveFailed(:final error) => Center(
          child: Text('$error', style: const TextStyle(fontSize: 9)),
        ),
      },
    );
  }
}
