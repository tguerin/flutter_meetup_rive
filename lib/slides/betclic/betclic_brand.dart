import 'package:flutter/material.dart';

/// Betclic template colours, lifted from the PowerPoint theme.
abstract final class BetclicBrand {
  /// Primary brand red (theme accent1, also the logo box).
  static const Color red = Color(0xFFE10014);

  /// Highlight yellow ("Betclic Yellow #FFCC00").
  static const Color yellow = Color(0xFFFFCC00);

  /// Dark navy used on cover / closing slides (theme dk2).
  static const Color navy = Color(0xFF0E2841);
  static const Color navyDeep = Color(0xFF0A0E1A);

  /// Content slide background + ink.
  static const Color surface = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF000000);
  static const Color muted = Color(0xFF8A8A8A);
  static const Color border = Color(0xFFE8E9EB);

  static const String fontFamily = 'Betclic';

  static const LinearGradient coverGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [navyDeep, navy],
  );
}

/// Full-slide background PNGs exported from the Betclic PowerPoint master.
abstract final class BetclicBg {
  static const cover = 'assets/branding/bg_cover_logo.png'; // logo centered
  static const welcome = 'assets/branding/bg_welcome.png'; // "WELCOME"
  static const section = 'assets/branding/bg_section.png'; // dark parts
  static const content = 'assets/branding/bg_content.png'; // light content
  static const qa = 'assets/branding/bg_qa.png'; // "Q&A" + mic
  static const thanks = 'assets/branding/bg_thanks.png'; // "THANK YOU"
}

/// Lays a full-bleed Betclic [asset] background under [child].
class BetclicBackground extends StatelessWidget {
  const BetclicBackground({
    super.key,
    required this.asset,
    required this.child,
  });

  final String asset;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(asset, fit: BoxFit.cover),
        child,
      ],
    );
  }
}

/// One styled fragment used to build the template's mixed red/black headlines.
class BetclicSpan {
  const BetclicSpan(this.text, {this.color, this.highlight, this.bold = false});

  /// Plain black text.
  const BetclicSpan.plain(this.text)
    : color = null,
      highlight = null,
      bold = false;

  /// Bold red text (the template's main emphasis style).
  const BetclicSpan.red(this.text)
    : color = BetclicBrand.red,
      highlight = null,
      bold = true;

  /// Black text on a yellow highlight.
  const BetclicSpan.yellow(this.text)
    : color = BetclicBrand.ink,
      highlight = BetclicBrand.yellow,
      bold = true;

  final String text;
  final Color? color;
  final Color? highlight;
  final bool bold;
}

/// Renders a list of [BetclicSpan]s as a single rich paragraph.
class BetclicRichText extends StatelessWidget {
  const BetclicRichText(
    this.spans, {
    super.key,
    required this.style,
    this.textAlign = TextAlign.left,
  });

  final List<BetclicSpan> spans;
  final TextStyle style;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: textAlign,
      text: TextSpan(
        style: style,
        children: [
          for (final s in spans)
            TextSpan(
              text: s.text,
              style: TextStyle(
                color: s.color ?? style.color,
                backgroundColor: s.highlight,
                fontWeight: s.bold ? FontWeight.w800 : style.fontWeight,
              ),
            ),
        ],
      ),
    );
  }
}
