import '../rive/card_step_demos.dart';
import 'betclic/betclic_code_slide.dart';

/// Step 1 — Design only: two artboards (BackCard, FrontCard) and an asset
/// that will later hold both faces. Dart still only loads the file and
/// renders a static artboard — no state machine, no bindings yet.
class RiveStep1Slide extends BetclicCodeSlide {
  RiveStep1Slide({super.key, super.pageNumber})
    : super(
        route: '/rive-step-1',
        title: 'Design',
        subtitle: '',
        codeLabel: 'STEP 01',
        code: _step1Code,
        result: const CardStep1Demo(),
      );
}

/// Step 2 — Animation + basic data binding: a new `card` artboard with the
/// `SmCard` state machine. The flip is driven by a `triggerFlip()` on a
/// strongly-typed view model.
class RiveStep2Slide extends BetclicCodeSlide {
  RiveStep2Slide({super.key, super.pageNumber})
    : super(
        route: '/rive-step-2',
        title: 'Animation & Data Binding',
        subtitle: '',
        codeLabel: 'STEP 02',
        codeSteps: const [_step2BuilderCode, _step2Code],
        result: const CardStep2Demo(),
      );
}

/// Step 3 — Customization: dedicated view models for the back (colour /
/// asset) and the front (value + suit), composed into the main `VmCard`.
class RiveStep3Slide extends BetclicCodeSlide {
  RiveStep3Slide({super.key, super.pageNumber})
    : super(
        route: '/rive-step-3',
        title: 'Customization',
        subtitle: '',
        codeLabel: 'STEP 03',
        codeSteps: const [_step3Code, _step3DecodeCode],
        codeFontSize: 14,
        codeFlex: 5,
        resultFlex: 6,
        result: const CardStep3Demo(),
      );
}

const String _step1Code = '''
// Load the file once — it holds every artboard.
final file = await File.asset(
  'assets/card_step_1.riv',
  riveFactory: Factory.rive,
);

// A controller is pinned to one artboard, so to switch we build a new
// one off the same file (no reload) and swap it into the RiveWidget.
RiveWidgetController controllerFor(String artboard) => RiveWidgetController(
  file,
  artboardSelector: ArtboardSelector.byName(artboard), // 'FrontCard' / 'BackCard'
);

void showArtboard(String name) {
  final old = controller;
  setState(() => controller = controllerFor(name));
  old.dispose();
}

RiveWidget(controller: controller);
''';

const String _step2BuilderCode = '''
// RiveWidgetBuilder hands you the load state — switch over it.
RiveWidgetBuilder(
  fileLoader: FileLoader.fromAsset(
    'assets/card_step_2.riv',
    riveFactory: Factory.rive,
  ),
  artboardSelector: ArtboardSelector.byName('Card'),
  stateMachineSelector: StateMachineSelector.byName('SmCard'),
  onLoaded: _onLoaded,
  builder: (context, state) => switch (state) {
    RiveLoading() => const CircularProgressIndicator(),
    RiveFailed(:final error) => Text('Failed: \$error'),
    RiveLoaded() => RiveWidget(controller: state.controller),
  },
);
''';

const String _step2Code = '''
// Grab the default view-model instance and bind it.
void _onLoaded(RiveLoaded state) {
  final vmi = state.file
      .defaultArtboardViewModel(state.controller.artboard)!
      .createDefaultInstance()!;
  state.controller.stateMachine.bindViewModelInstance(vmi);

  // Properties are looked up by name; triggers fire the state machine.
  vmi.trigger('triggerFlip')?.trigger();
}
''';

const String _step3Code = '''
// Each face is a nested view-model instance, reached by name.
state.controller.stateMachine.bindViewModelInstance(vmi);

final front = vmi.viewModel('propertyOfVmFrontCard');
front?.string('valueCard')?.value = 'A';
front?.enumerator('cardSymbol')?.value = 'heart';

final back = vmi.viewModel('propertyOfVmBackCard');
back?.color('colorBg')?.value = const Color(0xFFE10014);
back?.boolean('hasCustomBg')?.value = false;

vmi.trigger('triggerFlip')?.trigger();
''';

const String _step3DecodeCode = '''
// To bind a custom image, decode bytes into a RenderImage with the
// SAME factory the file was loaded with.
final bytes = await rootBundle.load('assets/logo.png');
final renderImage =
    await Factory.rive.decodeImage(bytes.buffer.asUint8List());

// Then drop it into the back-card asset slot.
back?.boolean('hasCustomBg')?.value = true;
back?.image('assetBg')?.value = renderImage;
''';
