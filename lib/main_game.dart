import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;

import 'minigame/minigame_controller.dart';
import 'minigame/minigame_widget.dart';
import 'rive/demo_flutter_minigame_viewmodel.rive.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await rive.RiveNative.init();
  runApp(const MinigameApp());
}

class MinigameApp extends StatelessWidget {
  const MinigameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Find the A of hearts',
      debugShowCheckedModeBanner: false,
      home: const MinigamePage(),
    );
  }
}

class MinigamePage extends StatefulWidget {
  const MinigamePage({super.key});

  @override
  State<MinigamePage> createState() => _MinigamePageState();
}

class _MinigamePageState extends State<MinigamePage> {
  VmMiniGameViewModel? _vm;
  MinigameController? _controller;

  void _onViewModel(VmMiniGameViewModel vm) {
    _vm = vm;
    _controller = MinigameController(vm);
  }

  @override
  void dispose() {
    _controller?.dispose();
    _vm?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MinigameWidget(onViewModel: _onViewModel);
  }
}
