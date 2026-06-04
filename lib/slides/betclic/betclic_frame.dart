import 'package:flutter/material.dart';

import 'betclic_brand.dart';

/// The recurring Betclic content-slide chrome: white surface, thin frame,
/// an optional title with a red accent bar, the "CONFIDENTIAL DOCUMENT"
/// footer, the page number and the Betclic logo in the bottom-right corner.
///
/// Drop any [child] inside to get a slide that matches template slides 5/7/8.
class BetclicFrame extends StatelessWidget {
  const BetclicFrame({
    super.key,
    this.title,
    this.pageNumber,
    this.footer,
    required this.child,
  });

  final String? title;
  final int? pageNumber;
  final String? footer;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: BetclicBrand.surface,
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: BetclicBrand.border, width: 1.5),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(56, 48, 56, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (title != null) ...[
                  Text(
                    title!,
                    style: const TextStyle(
                      fontFamily: BetclicBrand.fontFamily,
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      color: BetclicBrand.ink,
                      height: 1.05,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(width: 64, height: 5, color: BetclicBrand.red),
                  const SizedBox(height: 28),
                ],
                Expanded(child: child),
                const SizedBox(height: 12),
                _FooterBar(footer: footer, pageNumber: pageNumber),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterBar extends StatelessWidget {
  const _FooterBar({this.footer, this.pageNumber});

  final String? footer;
  final int? pageNumber;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (footer != null)
          Text(
            footer!,
            style: const TextStyle(
              fontFamily: BetclicBrand.fontFamily,
              fontSize: 11,
              letterSpacing: 1.5,
              color: BetclicBrand.muted,
            ),
          ),
        const Spacer(),
        if (pageNumber != null)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              '$pageNumber',
              style: const TextStyle(
                fontFamily: BetclicBrand.fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: BetclicBrand.ink,
              ),
            ),
          ),
        const BetclicLogo(height: 26),
      ],
    );
  }
}

/// The red Betclic wordmark, cropped from the template title slide.
class BetclicLogo extends StatelessWidget {
  const BetclicLogo({super.key, this.height = 40});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/betclic_logo.png',
      height: height,
      filterQuality: FilterQuality.medium,
    );
  }
}
