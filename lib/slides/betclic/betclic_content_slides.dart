import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';

import 'betclic_brand.dart';
import 'betclic_frame.dart';

/// Reusable empty content slide (template slides 5 / 7 / 8): the Betclic frame,
/// title, footer, page number and logo — with a blank area to drop any [child].
class BetclicContentSlide extends FlutterDeckSlideWidget {
  BetclicContentSlide({
    super.key,
    required String route,
    required this.title,
    this.pageNumber,
    this.child,
  }) : super(
         configuration: FlutterDeckSlideConfiguration(
           route: route,
           title: title,
         ),
       );

  final String title;
  final int? pageNumber;
  final Widget? child;

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (_) => BetclicFrame(
        title: title,
        pageNumber: pageNumber,
        child: child ?? const _ContentPlaceholder(),
      ),
    );
  }
}

class _ContentPlaceholder extends StatelessWidget {
  const _ContentPlaceholder();

  @override
  Widget build(BuildContext context) {
    return DottedPlaceholder(
      child: Text(
        'Your content here',
        style: TextStyle(
          fontFamily: BetclicBrand.fontFamily,
          fontSize: 18,
          color: BetclicBrand.muted.withValues(alpha: 0.8),
        ),
      ),
    );
  }
}

/// A light dashed-border drop area, shown when a content slide has no child yet.
class DottedPlaceholder extends StatelessWidget {
  const DottedPlaceholder({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        border: Border.all(color: BetclicBrand.border, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}

/// Bullet-points slide template (the "slides with only bullet points" ask).
class BetclicBulletSlide extends FlutterDeckSlideWidget {
  BetclicBulletSlide({
    super.key,
    required String route,
    required this.title,
    required this.bullets,
    this.pageNumber,
  }) : super(
         configuration: FlutterDeckSlideConfiguration(
           route: route,
           title: title,
         ),
       );

  final String title;
  final List<String> bullets;
  final int? pageNumber;

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (_) => BetclicFrame(
        title: title,
        pageNumber: pageNumber,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final b in bullets)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10, right: 18),
                      width: 14,
                      height: 14,
                      decoration: const BoxDecoration(
                        color: BetclicBrand.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        b,
                        style: const TextStyle(
                          fontFamily: BetclicBrand.fontFamily,
                          fontSize: 26,
                          height: 1.25,
                          color: BetclicBrand.ink,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Centered statement slide (template slide 10): a large mixed red/black
/// sentence on the white frame, with footer + logo.
class BetclicStatementSlide extends FlutterDeckSlideWidget {
  BetclicStatementSlide({
    super.key,
    required String route,
    required String title,
    required this.spans,
    this.pageNumber,
  }) : super(
         configuration: FlutterDeckSlideConfiguration(
           route: route,
           title: title,
         ),
       );

  final List<BetclicSpan> spans;
  final int? pageNumber;

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (_) => BetclicFrame(
        pageNumber: pageNumber,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: BetclicRichText(
              spans,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: BetclicBrand.fontFamily,
                fontSize: 44,
                fontWeight: FontWeight.w500,
                height: 1.2,
                color: BetclicBrand.ink,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
