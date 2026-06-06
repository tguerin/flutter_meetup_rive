import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

import '../../widgets/code_panel.dart';
import 'betclic_brand.dart';
import 'betclic_frame.dart';

/// Two-pane slide: a Dart [code] snippet on the left, a live [result] on the
/// right. Wraps everything in the standard [BetclicFrame] so the title /
/// footer / page number / logo stay consistent with the rest of the deck.
class BetclicCodeSlide extends FlutterDeckSlideWidget {
  BetclicCodeSlide({
    super.key,
    required String route,
    required this.title,
    required this.subtitle,
    required this.result,
    String? code,
    List<String>? codeSteps,
    this.codeLabel,
    this.pageNumber,
    this.codeFontSize = 16,
    this.codeFlex = 6,
    this.resultFlex = 5,
  }) : assert(
         code != null || codeSteps != null,
         'Provide either `code` or `codeSteps`.',
       ),
       codes = codeSteps ?? [code!],
       super(
         configuration: FlutterDeckSlideConfiguration(
           route: route,
           title: title,
           steps: codeSteps?.length ?? 1,
         ),
       );

  final String title;
  final String subtitle;

  /// Code snippets shown in the left panel. With more than one, the panel
  /// cross-fades to the next snippet each time the speaker advances a step.
  final List<String> codes;
  final Widget result;
  final String? codeLabel;
  final int? pageNumber;
  final double codeFontSize;
  final int codeFlex;
  final int resultFlex;

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (_) => BetclicFrame(
        title: title,
        pageNumber: pageNumber,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: codeFlex,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: BetclicBrand.fontFamily,
                        fontSize: 17,
                        height: 1.4,
                        color: BetclicBrand.muted,
                      ),
                    ),
                    const SizedBox(height: 18),
                    FlutterDeckSlideStepsBuilder(
                      builder: (context, step) {
                        final idx = (step - 1).clamp(0, codes.length - 1);
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
                          child: CodePanel(
                            key: ValueKey(idx),
                            code: codes[idx],
                            label: codeLabel,
                            fontSize: codeFontSize,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 32),
            Expanded(
              flex: resultFlex,
              child: Center(child: result),
            ),
          ],
        ),
      ),
    );
  }
}
