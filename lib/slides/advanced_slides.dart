import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../widgets/code_panel.dart';
import 'betclic/betclic_brand.dart';
import 'betclic/betclic_frame.dart';

/// Asset-loading strategy — the rendered diagram (File-scoped `AssetLoader`
/// vs Instance-scoped Data Binding).
class AssetStrategySlide extends FlutterDeckSlideWidget {
  AssetStrategySlide({super.key, this.pageNumber})
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/asset-strategy',
          title: 'Loading referenced assets',
        ),
      );

  final int? pageNumber;

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (_) => BetclicFrame(
        title: 'Loading referenced assets',
        pageNumber: pageNumber,
        child: Center(
          child: Image.asset('assets/asset_strategy.png', fit: BoxFit.contain),
        ),
      ),
    );
  }
}

/// View-model generators: raw, string-based API side-by-side with the
/// generated, typed API. Advancing fades the example from the value/suit
/// binding to image loading — where the generated API is *much* simpler.
/// The generator links live in their own strip at the bottom.
class GeneratorSlide extends FlutterDeckSlideWidget {
  GeneratorSlide({super.key, this.pageNumber})
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/vm-generator',
          title: 'Skip the strings: generate typed view models',
          steps: 2,
        ),
      );

  final int? pageNumber;

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (_) => BetclicFrame(
        title: 'Skip the strings: generate typed view models',
        pageNumber: pageNumber,
        child: Column(
          children: [
            Expanded(
              child: FlutterDeckSlideStepsBuilder(
                builder: (context, step) {
                  final i = (step - 1).clamp(0, _examples.length - 1);
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    child: _Comparison(key: ValueKey(i), example: _examples[i]),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const _GeneratorLinks(),
          ],
        ),
      ),
    );
  }
}

/// A raw-vs-generated example.
typedef _Example = ({String title, String raw, String typed});

const List<_Example> _examples = [
  (
    title: 'Set the card value & suit',
    raw:
        "// Strings everywhere — a typo is a runtime crash.\n"
        "final front = vmi.viewModel('propertyOfVmFrontCard');\n"
        "front?.string('valueCard')?.value = 'A';\n"
        "front?.enumerator('cardSymbol')?.value = 'heart';",
    typed:
        "// Typed — autocomplete + compile-time safety.\n"
        "final vm = VmCardViewModel.fromViewModel(vmi);\n"
        "vm.propertyOfVmFrontCard\n"
        "  ..valueCard = 'A'\n"
        "  ..cardSymbol = CardSymbol.heart;",
  ),
  (
    title: 'Load & bind an image',
    raw:
        "// Decode the bytes and bind them by hand.\n"
        "final bytes = await rootBundle.load('assets/logo.png');\n"
        "final image = await Factory.rive\n"
        "    .decodeImage(bytes.buffer.asUint8List());\n"
        "vmi.viewModel('propertyOfVmBackCard')\n"
        "   ?.image('assetBg')?.value = image;",
    typed:
        "// One call — decode + bind handled for you.\n"
        "final vm = VmCardViewModel.fromViewModel(vmi);\n"
        "await vm.propertyOfVmBackCard.updateAssetBgFromImageProvider(\n"
        "  imageProvider: const AssetImage('assets/logo.png'),\n"
        "  riveFactory: Factory.rive,\n"
        ");",
  ),
];

class _Comparison extends StatelessWidget {
  const _Comparison({super.key, required this.example});

  final _Example example;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            example.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: BetclicBrand.fontFamily,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: BetclicBrand.ink,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: CodePanel(
                    code: example.raw,
                    label: 'RAW STRINGS',
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 28),
              Flexible(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: CodePanel(
                    code: example.typed,
                    label: 'GENERATED',
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Compact strip of the two generator tools.
class _GeneratorLinks extends StatelessWidget {
  const _GeneratorLinks();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        _LinkItem(
          badge: 'MINE',
          name: 'rive-viewmodel-generator',
          url: 'github.com/tguerin/rive-viewmodel-generator',
        ),
        SizedBox(height: 10),
        _LinkItem(
          badge: 'OFFICIAL · WIP',
          name: 'rive-code-generator-wip',
          url: 'github.com/rive-app/rive-code-generator-wip',
        ),
      ],
    );
  }
}

class _LinkItem extends StatelessWidget {
  const _LinkItem({required this.badge, required this.name, required this.url});

  final String badge;
  final String name;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: BetclicBrand.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: BetclicBrand.red,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              badge,
              style: const TextStyle(
                fontFamily: BetclicBrand.fontFamily,
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            name,
            style: const TextStyle(
              fontFamily: BetclicBrand.fontFamily,
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: BetclicBrand.ink,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            url,
            style: const TextStyle(
              fontFamilyFallback: ['JetBrains Mono', 'Menlo', 'monospace'],
              fontSize: 13.5,
              color: BetclicBrand.red,
            ),
          ),
        ],
      ),
    );
  }
}
