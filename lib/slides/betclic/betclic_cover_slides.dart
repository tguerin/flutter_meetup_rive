import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'betclic_brand.dart';

/// Opening cover — the Betclic logo backdrop (slide 1) with the talk title,
/// subtitle and date overlaid in the lower third (the logo is baked into the
/// background art).
class BetclicCoverSlide extends FlutterDeckSlideWidget {
  const BetclicCoverSlide({
    super.key,
    required this.title,
    required this.subtitle,
    required this.date,
  }) : super(
         configuration: const FlutterDeckSlideConfiguration(
           route: '/cover',
           title: 'Cover',
         ),
       );

  final String title;
  final String subtitle;
  final String date;

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (_) => BetclicBackground(
        asset: BetclicBg.cover,
        child: Stack(
          children: [
            Align(
              alignment: const Alignment(0, 0.18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: BetclicBrand.fontFamily,
                      fontSize: 72,
                      fontWeight: FontWeight.w800,
                      height: 1.02,
                      letterSpacing: -0.5,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: BetclicBrand.fontFamily,
                      fontSize: 26,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 36,
              child: Center(
                child: Text(
                  date,
                  style: const TextStyle(
                    fontFamily: BetclicBrand.fontFamily,
                    fontSize: 14,
                    letterSpacing: 1.5,
                    color: BetclicBrand.yellow,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Q&A slide — the branded "Q&A" art (slide 7), used as-is.
class BetclicQaSlide extends FlutterDeckSlideWidget {
  const BetclicQaSlide({super.key})
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/qa',
          title: 'Q&A',
        ),
      );

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (_) =>
          const BetclicBackground(asset: BetclicBg.qa, child: SizedBox()),
    );
  }
}

/// Closing slide — the branded "THANK YOU" art (slide 8). The big wordmark is
/// baked into the background, so we only overlay the play-it-yourself QR on
/// the right (where the art leaves room).
class BetclicThankYouSlide extends FlutterDeckSlideWidget {
  const BetclicThankYouSlide({super.key, this.subtitle, this.playUrl})
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/thank-you',
          title: 'Thank you',
        ),
      );

  final String? subtitle;
  final String? playUrl;

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (_) => BetclicBackground(
        asset: BetclicBg.thanks,
        child: playUrl == null
            ? const SizedBox()
            : Align(
                alignment: const Alignment(0.82, 0),
                child: _PlayQrCallout(url: playUrl!, subtitle: subtitle),
              ),
      ),
    );
  }
}

class _PlayQrCallout extends StatelessWidget {
  const _PlayQrCallout({required this.url, this.subtitle});

  final String url;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          '↳ Play it yourself',
          style: TextStyle(
            fontFamily: BetclicBrand.fontFamily,
            fontSize: 16,
            letterSpacing: 1.5,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: QrImageView(
            data: url,
            size: 200,
            backgroundColor: Colors.white,
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: BetclicBrand.ink,
            ),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: BetclicBrand.ink,
            ),
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 14),
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: BetclicBrand.fontFamily,
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}
