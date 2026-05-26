import 'package:flutter/material.dart';

import '../rive/prez_rive_viewmodel.rive.dart';

class FrontCardControls extends StatefulWidget {
  const FrontCardControls({super.key, required this.vm});

  final VmCardViewModel vm;

  @override
  State<FrontCardControls> createState() => _FrontCardControlsState();
}

class _FrontCardControlsState extends State<FrontCardControls> {
  late final TextEditingController _controller;

  PropertyOfVmFrontCard get _front => widget.vm.propertyOfVmFrontCard;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _front.valueCard);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'Card value',
            hintText: 'A, K, Q, J, 10, ...',
            border: OutlineInputBorder(),
            isDense: true,
          ),
          onChanged: (value) => _front.valueCard = value,
        ),
        const SizedBox(height: 12),
        StreamBuilder<SymbolsCard>(
          stream: _front.symbolsCardStream,
          initialData: _front.symbolsCard,
          builder: (context, snapshot) {
            final current = snapshot.data ?? _front.symbolsCard;
            return Wrap(
              spacing: 8,
              children: [
                for (final symbol in SymbolsCard.values)
                  ChoiceChip(
                    label: Text(_glyph(symbol), style: const TextStyle(fontSize: 18)),
                    selected: current == symbol,
                    onSelected: (_) => _front.symbolsCard = symbol,
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  static String _glyph(SymbolsCard s) => switch (s) {
    SymbolsCard.diamond => '♦',
    SymbolsCard.heart => '♥',
    SymbolsCard.spade => '♠',
    SymbolsCard.club => '♣',
  };
}
