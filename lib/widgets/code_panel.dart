import 'package:flutter/material.dart';

import '../slides/betclic/betclic_brand.dart';
import 'dart_code.dart';

/// Dart snippet rendered as a dark editor card with a "macOS traffic light"
/// header band and an optional red pill label on the right.
class CodePanel extends StatelessWidget {
  const CodePanel({
    super.key,
    required this.code,
    this.label,
    this.fontSize = 16,
  });

  final String code;
  final String? label;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF121117),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _Header(label: label),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
            child: DartCodeBlock(code: code, fontSize: fontSize),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0x0AFFFFFF),
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        border: Border(
          bottom: BorderSide(color: Colors.white12, width: 1),
        ),
      ),
      child: Row(
        children: [
          _dot(const Color(0xFFFF5F57)),
          const SizedBox(width: 8),
          _dot(const Color(0xFFFEBC2E)),
          const SizedBox(width: 8),
          _dot(const Color(0xFF28C840)),
          const Spacer(),
          if (label != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: BetclicBrand.red,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                label!,
                style: const TextStyle(
                  fontFamily: BetclicBrand.fontFamily,
                  color: Colors.white,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.6,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _dot(Color color) => Container(
    width: 11,
    height: 11,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}
