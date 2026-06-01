import 'package:flutter/material.dart';
import 'package:flutter_deck/flutter_deck.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'betclic_brand.dart';
import 'betclic_frame.dart';

/// Shared dark navy backdrop used by the cover / closing slides, with the
/// Betclic logo tucked into the bottom-right corner.
class _CoverScaffold extends StatelessWidget {
  const _CoverScaffold({required this.child, this.footer});

  final Widget child;
  final String? footer;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: BetclicBrand.coverGradient),
      child: Stack(
        children: [
          Positioned.fill(child: Center(child: child)),
          if (footer != null)
            Positioned(
              left: 56,
              bottom: 40,
              child: Text(
                footer!,
                style: const TextStyle(
                  fontFamily: BetclicBrand.fontFamily,
                  fontSize: 11,
                  letterSpacing: 1.5,
                  color: Colors.white54,
                ),
              ),
            ),
          const Positioned(right: 56, bottom: 36, child: BetclicLogo(height: 30)),
        ],
      ),
    );
  }
}

/// Opening slide — dark cover with the centered logo, title and date.
class BetclicWelcomeSlide extends FlutterDeckSlideWidget {
  const BetclicWelcomeSlide({
    super.key,
    required this.title,
    required this.subtitle,
    required this.date,
  }) : super(
         configuration: const FlutterDeckSlideConfiguration(
           route: '/welcome',
           title: 'Welcome',
         ),
       );

  final String title;
  final String subtitle;
  final String date;

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (_) => _CoverScaffold(
        footer: date,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BetclicLogo(height: 96),
            const SizedBox(height: 48),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: BetclicBrand.fontFamily,
                fontSize: 64,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1.0,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: BetclicBrand.fontFamily,
                fontSize: 24,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Q&A slide — dark cover with a large "Q&A" lockup.
class BetclicQaSlide extends FlutterDeckSlideWidget {
  const BetclicQaSlide({super.key, this.prompt = 'Ask us anything'})
    : super(
        configuration: const FlutterDeckSlideConfiguration(
          route: '/qa',
          title: 'Q&A',
        ),
      );

  final String prompt;

  @override
  FlutterDeckSlide build(BuildContext context) {
    return FlutterDeckSlide.blank(
      builder: (_) => _CoverScaffold(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontFamily: BetclicBrand.fontFamily,
                  fontSize: 132,
                  fontWeight: FontWeight.w800,
                  height: 1.0,
                ),
                children: [
                  TextSpan(text: 'Q', style: TextStyle(color: Colors.white)),
                  TextSpan(text: '&', style: TextStyle(color: BetclicBrand.red)),
                  TextSpan(text: 'A', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              prompt,
              style: const TextStyle(
                fontFamily: BetclicBrand.fontFamily,
                fontSize: 26,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Closing slide — dark cover with a large "Thank you" and (optionally) a
/// QR code + URL for the audience to play the mini-game on their phones.
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
      builder: (_) => _CoverScaffold(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontFamily: BetclicBrand.fontFamily,
                      fontSize: 96,
                      fontWeight: FontWeight.w800,
                      height: 1.0,
                      color: Colors.white,
                    ),
                    children: [
                      TextSpan(text: 'Thank '),
                      TextSpan(
                        text: 'you',
                        style: TextStyle(color: BetclicBrand.red),
                      ),
                    ],
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 20),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontFamily: BetclicBrand.fontFamily,
                      fontSize: 22,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ],
            ),
            if (playUrl != null) ...[
              const SizedBox(width: 80),
              _PlayQrCallout(url: playUrl!),
            ],
          ],
        ),
      ),
    );
  }
}

class _PlayQrCallout extends StatelessWidget {
  const _PlayQrCallout({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '↳ Play it yourself',
          style: TextStyle(
            fontFamily: BetclicBrand.fontFamily,
            fontSize: 16,
            letterSpacing: 1.5,
            color: Colors.white70,
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
            size: 220,
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
        const SizedBox(height: 14),
        SelectableText(
          url,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
