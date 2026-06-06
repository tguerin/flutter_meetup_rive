import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;

import '../rive/demo_flutter_minigame_viewmodel.rive.dart';

typedef OnMiniGameViewModel = void Function(VmMiniGameViewModel vm);

/// Hosts the "Find the A of hearts" Rive mini-game. All gameplay lives
/// inside the Rive state machine (start / shuffle / click / flip / restart
/// are driven by Rive's own `BtStart`, `BtRestart` and per-card artboards);
/// Dart just instantiates the canvas and forwards the typed view-model so a
/// caller can drive it programmatically if needed.
class MinigameWidget extends StatefulWidget {
  const MinigameWidget({super.key, this.onViewModel});

  final OnMiniGameViewModel? onViewModel;

  @override
  State<MinigameWidget> createState() => _MinigameWidgetState();
}

class _MinigameWidgetState extends State<MinigameWidget> {
  late final rive.FileLoader _fileLoader;

  @override
  void initState() {
    super.initState();
    _fileLoader = rive.FileLoader.fromAsset(
      'assets/demo_flutter_minigame.riv',
      riveFactory: rive.Factory.rive,
    );
  }

  void _onLoaded(rive.RiveLoaded state) {
    final vmi = state.file
        .defaultArtboardViewModel(state.controller.artboard)
        ?.createDefaultInstance();
    if (vmi == null) return;
    final vm = VmMiniGameViewModel.fromViewModel(vmi);
    vm.bind(state.controller.stateMachine);
    widget.onViewModel?.call(vm);
  }

  @override
  Widget build(BuildContext context) {
    return rive.RiveWidgetBuilder(
      fileLoader: _fileLoader,
      artboardSelector: rive.ArtboardSelector.byName(
        DemoFlutterMinigameArtboard.miniGame.name,
      ),
      stateMachineSelector: rive.StateMachineSelector.byName(
        DemoFlutterMinigameArtboard.miniGame.SmMiniGame.name,
      ),
      onLoaded: _onLoaded,
      builder: (context, state) => switch (state) {
        rive.RiveLoaded() => rive.RiveWidget(
          controller: state.controller,
          fit: rive.Fit.layout,
          alignment: Alignment.center,
        ),
        rive.RiveLoading() => const Center(child: CircularProgressIndicator()),
        rive.RiveFailed(:final error) => Center(
          child: Text(
            'Failed to load mini-game: $error',
            style: const TextStyle(color: Colors.white70),
          ),
        ),
      },
    );
  }
}
