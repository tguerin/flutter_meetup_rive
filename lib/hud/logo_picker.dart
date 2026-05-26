import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;

import '../rive/prez_rive_viewmodel.rive.dart';

class _LogoPreset {
  const _LogoPreset({
    required this.label,
    required this.letter,
    required this.start,
    required this.end,
  });

  final String label;
  final String letter;
  final Color start;
  final Color end;
}

const _presets = <_LogoPreset>[
  _LogoPreset(
    label: 'Flutter',
    letter: 'F',
    start: Color(0xFF42A5F5),
    end: Color(0xFF0D47A1),
  ),
  _LogoPreset(
    label: 'Dart',
    letter: 'D',
    start: Color(0xFF26C6DA),
    end: Color(0xFF006064),
  ),
  _LogoPreset(
    label: 'Rive',
    letter: 'R',
    start: Color(0xFFEC407A),
    end: Color(0xFF880E4F),
  ),
];

class LogoPicker extends StatefulWidget {
  const LogoPicker({super.key, required this.vm});

  final VmCardViewModel vm;

  @override
  State<LogoPicker> createState() => _LogoPickerState();
}

class _LogoPickerState extends State<LogoPicker> {
  final List<ui.Image?> _logos = List<ui.Image?>.filled(_presets.length, null);
  int? _selected;

  @override
  void initState() {
    super.initState();
    _renderLogos();
  }

  @override
  void dispose() {
    for (final logo in _logos) {
      logo?.dispose();
    }
    super.dispose();
  }

  Future<void> _renderLogos() async {
    for (var i = 0; i < _presets.length; i++) {
      final image = await _renderLogo(_presets[i]);
      if (!mounted) {
        image.dispose();
        return;
      }
      setState(() => _logos[i] = image);
    }
  }

  static Future<ui.Image> _renderLogo(_LogoPreset preset) async {
    const size = 512.0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      const Rect.fromLTWH(0, 0, size, size),
    );
    final rect = const Rect.fromLTWH(0, 0, size, size);

    canvas.drawRect(
      rect,
      Paint()
        ..shader = ui.Gradient.linear(
          rect.topLeft,
          rect.bottomRight,
          [preset.start, preset.end],
        ),
    );

    final paragraphStyle = ui.ParagraphStyle(
      textAlign: TextAlign.center,
      fontSize: size * 0.55,
      fontWeight: FontWeight.w800,
    );
    final paragraph = (ui.ParagraphBuilder(paragraphStyle)
          ..pushStyle(ui.TextStyle(color: Colors.white))
          ..addText(preset.letter))
        .build()
      ..layout(const ui.ParagraphConstraints(width: size));
    canvas.drawParagraph(
      paragraph,
      Offset(0, size / 2 - paragraph.height / 2),
    );

    final picture = recorder.endRecording();
    try {
      return await picture.toImage(size.toInt(), size.toInt());
    } finally {
      picture.dispose();
    }
  }

  Future<void> _apply(int index) async {
    final image = _logos[index];
    if (image == null) return;
    setState(() => _selected = index);
    await widget.vm.propertyOfVmBackCard.updateAssetBgFromImage(
      image: image,
      riveFactory: rive.Factory.flutter,
      srcRect: null,
    );
  }

  void _reset() {
    setState(() => _selected = null);
    widget.vm.propertyOfVmBackCard.resetAssetBg();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Bind a logo image to the back-card asset slot',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (var i = 0; i < _presets.length; i++)
              _LogoTile(
                preset: _presets[i],
                selected: _selected == i,
                onTap: () => _apply(i),
              ),
            _ResetTile(onTap: _reset),
          ],
        ),
      ],
    );
  }
}

class _LogoTile extends StatelessWidget {
  const _LogoTile({
    required this.preset,
    required this.selected,
    required this.onTap,
  });

  final _LogoPreset preset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 72,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [preset.start, preset.end],
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                preset.letter,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(preset.label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _ResetTile extends StatelessWidget {
  const _ResetTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 72,
        padding: const EdgeInsets.all(6),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.restart_alt),
            ),
            const SizedBox(height: 4),
            Text('Reset', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
