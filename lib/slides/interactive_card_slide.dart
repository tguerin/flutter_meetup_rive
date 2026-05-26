import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../hud/card_hud.dart';
import '../rive/card_animation.dart';
import '../rive/prez_rive_viewmodel.rive.dart';

class InteractiveCardSlide extends FlutterDeckSlideWidget {
  const InteractiveCardSlide({super.key})
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/card',
          title: 'Interactive Rive card',
        ),
      );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (_) => const _InteractiveCardBody(),
    );
  }
}

class _InteractiveCardBody extends StatefulWidget {
  const _InteractiveCardBody();

  @override
  State<_InteractiveCardBody> createState() => _InteractiveCardBodyState();
}

class _InteractiveCardBodyState extends State<_InteractiveCardBody> {
  VmCardViewModel? _vm;

  @override
  void dispose() {
    _vm?.dispose();
    super.dispose();
  }

  void _onViewModel(VmCardViewModel vm) {
    setState(() => _vm = vm);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 6,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Strongly-typed Rive View Models',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Bind a logo, change the color, flip the card — all from Dart.',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: CardAnimation(onViewModel: _onViewModel),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 4,
            child: _vm == null
                ? const Center(child: CircularProgressIndicator())
                : CardHud(vm: _vm!),
          ),
        ],
      ),
    );
  }
}
