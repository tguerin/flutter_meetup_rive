import 'package:flutter/material.dart';

/// A tiny, dependency-free Dart syntax highlighter.
///
/// Not a real parser — a prioritised tokenizer that is "good enough" for the
/// short snippets shown on slides: comments, strings, annotations, numbers,
/// keywords, types, and call expressions.
class DartCodeTheme {
  const DartCodeTheme({
    required this.base,
    required this.keyword,
    required this.type,
    required this.string,
    required this.number,
    required this.comment,
    required this.annotation,
    required this.function,
    required this.punctuation,
  });

  final Color base;
  final Color keyword;
  final Color type;
  final Color string;
  final Color number;
  final Color comment;
  final Color annotation;
  final Color function;
  final Color punctuation;

  /// Palette tuned for a dark `almostBlack` code panel.
  static const DartCodeTheme dark = DartCodeTheme(
    base: Color(0xFFE6E6E6),
    keyword: Color(0xFFFF5C7A),
    type: Color(0xFFFFCC00),
    string: Color(0xFF5BD6A0),
    number: Color(0xFFFAA541),
    comment: Color(0xFF7C8595),
    annotation: Color(0xFFFFB454),
    function: Color(0xFF49B6F0),
    punctuation: Color(0xFFAEB6C2),
  );
}

const Set<String> _keywords = {
  'abstract', 'as', 'assert', 'async', 'await', 'base', 'break', 'case',
  'catch', 'class', 'const', 'continue', 'covariant', 'default', 'deferred',
  'do', 'dynamic', 'else', 'enum', 'export', 'extends', 'extension', 'external',
  'factory', 'final', 'finally', 'for', 'Function', 'get', 'hide', 'if',
  'implements', 'import', 'in', 'interface', 'is', 'late', 'library', 'mixin',
  'new', 'on', 'operator', 'part', 'required', 'rethrow', 'return', 'sealed',
  'set', 'show', 'static', 'super', 'switch', 'sync', 'this', 'throw', 'try',
  'typedef', 'var', 'void', 'when', 'while', 'with', 'yield',
};

const Set<String> _constants = {'true', 'false', 'null'};

const Set<String> _builtinTypes = {
  'int', 'double', 'num', 'bool', 'String', 'void', 'Object',
};

class _Rule {
  const _Rule(this.pattern, this.kind);
  final RegExp pattern;
  final _Kind kind;
}

enum _Kind { comment, string, annotation, number, ident, ws, punct, op, other }

final List<_Rule> _rules = [
  _Rule(RegExp(r'//[^\n]*'), _Kind.comment),
  _Rule(RegExp(r'/\*.*?\*/', dotAll: true), _Kind.comment),
  _Rule(RegExp(r"r?'''(?:.|\n)*?'''"), _Kind.string),
  _Rule(RegExp(r'r?"""(?:.|\n)*?"""'), _Kind.string),
  _Rule(RegExp(r"r?'(?:\\.|[^'\\\n])*'"), _Kind.string),
  _Rule(RegExp(r'r?"(?:\\.|[^"\\\n])*"'), _Kind.string),
  _Rule(RegExp(r'@[A-Za-z_]\w*'), _Kind.annotation),
  _Rule(RegExp(r'0[xX][0-9a-fA-F]+|\d+(?:\.\d+)?'), _Kind.number),
  _Rule(RegExp(r'[A-Za-z_$][\w$]*'), _Kind.ident),
  _Rule(RegExp(r'\s+'), _Kind.ws),
  _Rule(RegExp(r'[{}()\[\].,;:?]'), _Kind.punct),
  _Rule(RegExp(r'[=<>+\-*/%!&|~^]+'), _Kind.op),
];

List<TextSpan> _highlightDart(
  String code, {
  DartCodeTheme theme = DartCodeTheme.dark,
}) {
  final spans = <TextSpan>[];
  var i = 0;
  while (i < code.length) {
    _Rule? matched;
    Match? match;
    for (final rule in _rules) {
      final m = rule.pattern.matchAsPrefix(code, i);
      if (m != null && m.end > m.start) {
        matched = rule;
        match = m;
        break;
      }
    }
    if (matched == null || match == null) {
      spans.add(TextSpan(text: code[i], style: TextStyle(color: theme.base)));
      i += 1;
      continue;
    }

    final text = match.group(0)!;
    final color = _colorFor(matched.kind, text, code, match.end, theme);
    final italic = matched.kind == _Kind.comment;
    spans.add(
      TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontStyle: italic ? FontStyle.italic : FontStyle.normal,
        ),
      ),
    );
    i = match.end;
  }
  return spans;
}

Color _colorFor(
  _Kind kind,
  String text,
  String src,
  int end,
  DartCodeTheme t,
) {
  switch (kind) {
    case _Kind.comment:
      return t.comment;
    case _Kind.string:
      return t.string;
    case _Kind.annotation:
      return t.annotation;
    case _Kind.number:
      return t.number;
    case _Kind.ident:
      if (_keywords.contains(text) || _constants.contains(text)) {
        return t.keyword;
      }
      if (_builtinTypes.contains(text)) return t.type;
      final first = text[0];
      if (first == first.toUpperCase() && first != first.toLowerCase()) {
        return t.type;
      }
      if (end < src.length && _nextNonSpaceIsParen(src, end)) return t.function;
      return t.base;
    case _Kind.punct:
    case _Kind.op:
      return t.punctuation;
    case _Kind.ws:
    case _Kind.other:
      return t.base;
  }
}

bool _nextNonSpaceIsParen(String src, int from) {
  var j = from;
  while (j < src.length && (src[j] == ' ' || src[j] == '\t')) {
    j++;
  }
  return j < src.length && src[j] == '(';
}

/// Monospace fallback stack — no bundled font, so we lean on platform monos.
const List<String> kMonoFallback = [
  'JetBrains Mono',
  'Menlo',
  'Monaco',
  'Consolas',
  'Courier New',
];

/// A highlighted Dart code block, scaled to fit its container width.
class DartCodeBlock extends StatelessWidget {
  const DartCodeBlock({
    super.key,
    required this.code,
    this.theme = DartCodeTheme.dark,
    this.fontSize = 16,
  });

  final String code;
  final DartCodeTheme theme;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final baseStyle = TextStyle(
      fontFamilyFallback: kMonoFallback,
      fontSize: fontSize,
      height: 1.5,
      color: theme.base,
    );

    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.topLeft,
      child: RichText(
        softWrap: false,
        text: TextSpan(
          style: baseStyle,
          children: _highlightDart(code, theme: theme),
        ),
      ),
    );
  }
}
