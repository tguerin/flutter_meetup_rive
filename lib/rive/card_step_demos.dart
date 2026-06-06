import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;

import '../slides/betclic/betclic_brand.dart';

// Card artboards expose a "Card" artboard driven by the "SmCard" state machine
// and a default view model. We talk to that view model through the plain Rive
// data-binding API (vmi.trigger / .color / .string / .enumerator / .image /
// .viewModel) — no generated, strongly-typed wrapper. A tool to generate typed
// view models is shown in a later slide.
const _cardArtboard = 'Card';
const _cardStateMachine = 'SmCard';

/// A soft neutral backdrop so the (white) Rive card stays visible against the
/// white slide. Deliberately *not* a card itself — the card chrome comes from
/// Rive; this only provides contrast and room for the animation.
class _CardStage extends StatelessWidget {
  const _CardStage({
    required this.child,
    this.width = 380,
    this.height = 460,
    this.padding = 36,
  });

  final Widget child;
  final double width;
  final double height;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF1F2F5), Color(0xFFE7E9EE)],
        ),
      ),
      child: child,
    );
  }
}

/// Small brand-styled two-option toggle (used to switch artboard in step 1).
class _SegmentToggle extends StatelessWidget {
  const _SegmentToggle({
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  final List<({String value, String label})> options;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F2F4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: BetclicBrand.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final o in options)
            GestureDetector(
              onTap: () => onChanged(o.value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: o.value == selected
                      ? BetclicBrand.red
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  o.label,
                  style: TextStyle(
                    fontFamily: BetclicBrand.fontFamily,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                    color: o.value == selected
                        ? Colors.white
                        : BetclicBrand.muted,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Step 1 — just two artboards (BackCard / FrontCard). No state machine, no
/// view model: the toggle picks which artboard to render, showing how the
/// same file exposes several artboards we can switch between.
class CardStep1Demo extends StatefulWidget {
  const CardStep1Demo({super.key});

  @override
  State<CardStep1Demo> createState() => _CardStep1DemoState();
}

class _CardStep1DemoState extends State<CardStep1Demo> {
  // The two artboards baked into card_step_1.riv.
  String _artboard = 'FrontCard';

  // The file is loaded once; switching artboards just rebuilds a controller
  // off the same loaded file — no asset reload.
  rive.File? _file;
  rive.RiveWidgetController? _controller;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final file = await rive.File.asset(
      'assets/card_step_1.riv',
      riveFactory: rive.Factory.rive,
    );
    if (file == null || !mounted) {
      file?.dispose();
      return;
    }
    _file = file;
    setState(() => _controller = _controllerFor(_artboard));
  }

  rive.RiveWidgetController _controllerFor(String artboard) {
    return rive.RiveWidgetController(
      _file!,
      artboardSelector: rive.ArtboardSelector.byName(artboard),
    );
  }

  void _select(String artboard) {
    if (artboard == _artboard || _file == null) return;
    final old = _controller;
    setState(() {
      _artboard = artboard;
      _controller = _controllerFor(artboard);
    });
    old?.dispose();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _file?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SegmentToggle(
          options: const [
            (value: 'FrontCard', label: 'Front'),
            (value: 'BackCard', label: 'Back'),
          ],
          selected: _artboard,
          onChanged: _select,
        ),
        const SizedBox(height: 28),
        _CardStage(
          child: controller == null
              ? const Center(child: CircularProgressIndicator())
              : rive.RiveWidget(
                  // New controller per artboard → swaps without reloading
                  // the file.
                  key: ValueKey(_artboard),
                  controller: controller,
                  fit: rive.Fit.contain,
                ),
        ),
      ],
    );
  }
}

/// Step 2 — Card artboard + SmCard state machine + a VmCard view model. We
/// fire `triggerFlip()` from Dart on a small interval so the audience sees
/// the binding driving the animation.
class CardStep2Demo extends StatefulWidget {
  const CardStep2Demo({super.key});

  @override
  State<CardStep2Demo> createState() => _CardStep2DemoState();
}

class _CardStep2DemoState extends State<CardStep2Demo> {
  late final rive.FileLoader _fileLoader = rive.FileLoader.fromAsset(
    'assets/card_step_2.riv',
    riveFactory: rive.Factory.rive,
  );

  rive.ViewModelInstance? _vmi;

  @override
  void dispose() {
    _vmi?.dispose();
    super.dispose();
  }

  void _onLoaded(rive.RiveLoaded state) {
    final vmi = state.file
        .defaultArtboardViewModel(state.controller.artboard)
        ?.createDefaultInstance();
    if (vmi == null) return;
    state.controller.stateMachine.bindViewModelInstance(vmi);
    _vmi = vmi;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        rive.RiveWidgetBuilder(
          fileLoader: _fileLoader,
          artboardSelector: rive.ArtboardSelector.byName(_cardArtboard),
          stateMachineSelector: rive.StateMachineSelector.byName(
            _cardStateMachine,
          ),
          onLoaded: _onLoaded,
          builder: (context, state) => switch (state) {
            rive.RiveLoaded() => _CardStage(
              child: rive.RiveWidget(
                controller: state.controller,
                fit: rive.Fit.contain,
              ),
            ),
            rive.RiveLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            rive.RiveFailed(:final error) => Center(
              child: Text('Failed to load Rive: $error'),
            ),
          },
        ),
        const SizedBox(height: 28),
        _FlipButton(
          onPressed: () => _vmi?.trigger('triggerFlip')?.trigger(),
        ),
      ],
    );
  }
}

/// A brand-styled "Flip card" action used to drive `triggerFlip()` from Dart.
class _FlipButton extends StatelessWidget {
  const _FlipButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.flip_camera_android, size: 20),
      label: const Text('Flip card'),
      style: ElevatedButton.styleFrom(
        backgroundColor: BetclicBrand.red,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: const TextStyle(
          fontFamily: BetclicBrand.fontFamily,
          fontSize: 15,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
      ),
    );
  }
}

/// Step 3 — same Card artboard, but the back & front now have their own view
/// models. A small HUD drives the look & feel live: back colour, a bound
/// image, the card value & suit, and a flip — all from typed Dart bindings.
class CardStep3Demo extends StatefulWidget {
  const CardStep3Demo({super.key});

  @override
  State<CardStep3Demo> createState() => _CardStep3DemoState();
}

class _CardStep3DemoState extends State<CardStep3Demo> {
  late final rive.FileLoader _fileLoader = rive.FileLoader.fromAsset(
    'assets/card_step_3.riv',
    riveFactory: rive.Factory.rive,
  );

  rive.ViewModelInstance? _vmi;

  @override
  void dispose() {
    _vmi?.dispose();
    super.dispose();
  }

  void _onLoaded(rive.RiveLoaded state) {
    final vmi = state.file
        .defaultArtboardViewModel(state.controller.artboard)
        ?.createDefaultInstance();
    if (vmi == null) return;
    state.controller.stateMachine.bindViewModelInstance(vmi);

    final back = vmi.viewModel('propertyOfVmBackCard');
    back?.color('colorBg')?.value = BetclicBrand.red;
    back?.boolean('hasCustomBg')?.value = false;
    final front = vmi.viewModel('propertyOfVmFrontCard');
    front?.string('valueCard')?.value = 'A';
    front?.enumerator('cardSymbol')?.value = 'heart';

    setState(() => _vmi = vmi);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _CardStage(
          width: 300,
          height: 414,
          padding: 16,
          child: rive.RiveWidgetBuilder(
            fileLoader: _fileLoader,
            artboardSelector: rive.ArtboardSelector.byName(_cardArtboard),
            stateMachineSelector: rive.StateMachineSelector.byName(
              _cardStateMachine,
            ),
            onLoaded: _onLoaded,
            builder: (context, state) => switch (state) {
              rive.RiveLoaded() => rive.RiveWidget(
                controller: state.controller,
                fit: rive.Fit.contain,
              ),
              rive.RiveLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
              rive.RiveFailed(:final error) => Center(
                child: Text('Failed to load Rive: $error'),
              ),
            },
          ),
        ),
        const SizedBox(width: 24),
        Flexible(
          child: _vmi == null
              ? const SizedBox.shrink()
              : _CardStep3Hud(vm: _vmi!),
        ),
      ],
    );
  }
}

/// Compact look-and-feel HUD for step 3 — back colour, bound image, card
/// value & suit, and a flip. Drives the bound view model through the plain
/// Rive data-binding API; the HUD's own state tracks the current selection.
class _CardStep3Hud extends StatefulWidget {
  const _CardStep3Hud({required this.vm});

  final rive.ViewModelInstance vm;

  @override
  State<_CardStep3Hud> createState() => _CardStep3HudState();
}

class _CardStep3HudState extends State<_CardStep3Hud> {
  static const _swatches = <Color>[
    BetclicBrand.red,
    Color(0xFF0E2841),
    BetclicBrand.yellow,
    Color(0xFF34AE7D),
    Color(0xFF009EE2),
    Color(0xFF8E24AA),
  ];

  static const _values = ['A', 'K', 'Q', 'J', '10', '7'];

  // Suit options: the label glyph + the Rive enum value name on `cardSymbol`.
  static const _suits = <({String glyph, String name})>[
    (glyph: '♥', name: 'heart'),
    (glyph: '♦', name: 'diamond'),
    (glyph: '♠', name: 'spade'),
    (glyph: '♣', name: 'club'),
  ];

  int _colorIndex = 0;
  String _value = 'A';
  String _suit = 'heart';

  rive.ViewModelInstance get _back =>
      widget.vm.viewModel('propertyOfVmBackCard')!;
  rive.ViewModelInstance get _front =>
      widget.vm.viewModel('propertyOfVmFrontCard')!;

  void _pickColor(int i) {
    setState(() => _colorIndex = i);
    final back = _back;
    back.image('assetBg')?.value = null;
    back.boolean('hasCustomBg')?.value = false;
    back.color('colorBg')?.value = _swatches[i];
  }

  void _pickValue(String v) {
    setState(() => _value = v);
    _front.string('valueCard')?.value = v;
  }

  void _pickSuit(String name) {
    setState(() => _suit = name);
    _front.enumerator('cardSymbol')?.value = name;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: BetclicBrand.border, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _HudLabel('Back color'),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 0; i < _swatches.length; i++)
                _Swatch(
                  color: _swatches[i],
                  selected: i == _colorIndex,
                  onTap: () => _pickColor(i),
                ),
            ],
          ),
          const SizedBox(height: 16),
          const _HudLabel('Bound image'),
          _ImageBinder(back: _back),
          const SizedBox(height: 16),
          const _HudLabel('Value'),
          Wrap(
            spacing: 6,
            children: [
              for (final v in _values)
                _PillChip(
                  label: v,
                  selected: _value == v,
                  onTap: () => _pickValue(v),
                ),
            ],
          ),
          const SizedBox(height: 16),
          const _HudLabel('Suit'),
          Wrap(
            spacing: 6,
            children: [
              for (final s in _suits)
                _PillChip(
                  label: s.glyph,
                  selected: _suit == s.name,
                  onTap: () => _pickSuit(s.name),
                ),
            ],
          ),
          const SizedBox(height: 18),
          _FlipButton(
            onPressed: () => widget.vm.trigger('triggerFlip')?.trigger(),
          ),
        ],
      ),
    );
  }
}

/// Small caps section label in brand red.
class _HudLabel extends StatelessWidget {
  const _HudLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontFamily: BetclicBrand.fontFamily,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.4,
          color: BetclicBrand.red,
        ),
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? BetclicBrand.ink : Colors.transparent,
            width: 3,
          ),
        ),
        child: selected
            ? const Icon(Icons.check, size: 15, color: Colors.white)
            : null,
      ),
    );
  }
}

class _PillChip extends StatelessWidget {
  const _PillChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? BetclicBrand.red : const Color(0xFFF1F2F4),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? BetclicBrand.red : BetclicBrand.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: BetclicBrand.fontFamily,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : BetclicBrand.ink,
          ),
        ),
      ),
    );
  }
}

/// Image-binding row: a couple of generated logos + a reset, each bound into
/// the back-card asset slot through the back view model.
class _ImageBinder extends StatefulWidget {
  const _ImageBinder({required this.back});

  /// The nested back-card view-model instance (`propertyOfVmBackCard`).
  final rive.ViewModelInstance back;

  @override
  State<_ImageBinder> createState() => _ImageBinderState();
}

class _ImageBinderState extends State<_ImageBinder> {
  static const _logos = <({String label, String letter, Color a, Color b})>[
    (label: 'Flutter', letter: 'F', a: Color(0xFF42A5F5), b: Color(0xFF0D47A1)),
    (label: 'Dart', letter: 'D', a: Color(0xFF26C6DA), b: Color(0xFF006064)),
    (label: 'Rive', letter: 'R', a: Color(0xFFEC407A), b: Color(0xFF880E4F)),
  ];

  // Decode each logo once into a RenderImage and keep it alive for the
  // lifetime of the widget. Assigning a freshly-decoded image and disposing
  // it straight away (as updateAssetBgFromImage does) frees it under the
  // native Rive renderer, so switching between bound images wouldn't stick.
  final List<rive.RenderImage?> _images = List<rive.RenderImage?>.filled(
    _logos.length,
    null,
  );
  int? _selected;

  @override
  void initState() {
    super.initState();
    _decodeAll();
  }

  @override
  void dispose() {
    for (final img in _images) {
      img?.dispose();
    }
    super.dispose();
  }

  Future<void> _decodeAll() async {
    for (var i = 0; i < _logos.length; i++) {
      final image = await _decodeLogo(_logos[i]);
      if (image == null) continue;
      if (!mounted) {
        image.dispose();
        return;
      }
      setState(() => _images[i] = image);
    }
  }

  static Future<rive.RenderImage?> _decodeLogo(
    ({String label, String letter, Color a, Color b}) preset,
  ) async {
    const size = 512.0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, size, size));
    const rect = Rect.fromLTWH(0, 0, size, size);
    canvas.drawRect(
      rect,
      Paint()
        ..shader = ui.Gradient.linear(rect.topLeft, rect.bottomRight, [
          preset.a,
          preset.b,
        ]),
    );
    final paragraph =
        (ui.ParagraphBuilder(
                ui.ParagraphStyle(
                  textAlign: TextAlign.center,
                  fontSize: size * 0.55,
                  fontWeight: FontWeight.w800,
                ),
              )
              ..pushStyle(ui.TextStyle(color: Colors.white))
              ..addText(preset.letter))
            .build()
          ..layout(const ui.ParagraphConstraints(width: size));
    canvas.drawParagraph(paragraph, Offset(0, size / 2 - paragraph.height / 2));
    final picture = recorder.endRecording();
    ui.Image image;
    try {
      image = await picture.toImage(size.toInt(), size.toInt());
    } finally {
      picture.dispose();
    }
    try {
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      if (bytes == null) return null;
      return rive.Factory.rive.decodeImage(bytes.buffer.asUint8List());
    } finally {
      image.dispose();
    }
  }

  void _apply(int index) {
    final image = _images[index];
    if (image == null) return;
    setState(() => _selected = index);
    widget.back.boolean('hasCustomBg')?.value = true;
    widget.back.image('assetBg')?.value = image;
  }

  void _reset() {
    setState(() => _selected = null);
    widget.back.image('assetBg')?.value = null;
    widget.back.boolean('hasCustomBg')?.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      children: [
        for (var i = 0; i < _logos.length; i++)
          _ImageTile(
            letter: _logos[i].letter,
            a: _logos[i].a,
            b: _logos[i].b,
            selected: _selected == i,
            onTap: () => _apply(i),
          ),
        _ResetTile(onTap: _reset),
      ],
    );
  }
}

class _ImageTile extends StatelessWidget {
  const _ImageTile({
    required this.letter,
    required this.a,
    required this.b,
    required this.selected,
    required this.onTap,
  });

  final String letter;
  final Color a;
  final Color b;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [a, b],
          ),
          border: Border.all(
            color: selected ? BetclicBrand.ink : Colors.transparent,
            width: 2.5,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          letter,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFF1F2F4),
          border: Border.all(color: BetclicBrand.border),
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.restart_alt, size: 22, color: BetclicBrand.ink),
      ),
    );
  }
}
