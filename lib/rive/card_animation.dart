import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;

import 'prez_rive_viewmodel.rive.dart';

typedef OnCardViewModel = void Function(VmCardViewModel vm);

class CardAnimation extends StatefulWidget {
  const CardAnimation({super.key, required this.onViewModel});

  final OnCardViewModel onViewModel;

  @override
  State<CardAnimation> createState() => _CardAnimationState();
}

class _CardAnimationState extends State<CardAnimation> {
  late final rive.FileLoader _fileLoader;

  @override
  void initState() {
    super.initState();
    _fileLoader = rive.FileLoader.fromAsset(
      'assets/prez_rive.riv',
      riveFactory: rive.Factory.flutter,
    );
  }

  void _onLoaded(rive.RiveLoaded state) {
    final vmi = state.file
        .defaultArtboardViewModel(state.controller.artboard)
        ?.createDefaultInstance();
    if (vmi == null) return;
    final vm = VmCardViewModel.fromViewModel(vmi);
    vm.bind(state.controller.stateMachine);
    widget.onViewModel(vm);
  }

  @override
  Widget build(BuildContext context) {
    return rive.RiveWidgetBuilder(
      fileLoader: _fileLoader,
      artboardSelector: rive.ArtboardSelector.byName(
        PrezRiveArtboard.card.name,
      ),
      stateMachineSelector: rive.StateMachineSelector.byName(
        PrezRiveArtboard.card.SmCard.name,
      ),
      onLoaded: _onLoaded,
      builder: (context, state) => switch (state) {
        rive.RiveLoaded() => rive.RiveWidget(
          controller: state.controller,
          fit: rive.Fit.contain,
        ),
        rive.RiveLoading() => const Center(child: CircularProgressIndicator()),
        rive.RiveFailed(:final error) => Center(
          child: Text('Failed to load Rive: $error'),
        ),
      },
    );
  }
}
