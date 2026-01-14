import 'package:bagaer/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class BagaerRichText extends StatelessWidget {
  final String text;
  final Color highlightColor;
  final TextStyle? baseStyle;
  final TextAlign textAlign;

  const BagaerRichText({
    super.key,
    required this.text,
    this.highlightColor = AppColors.primary,
    this.baseStyle,
    this.textAlign = TextAlign.center
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = baseStyle ??
      const TextStyle(
        fontSize: 16,
        color: Colors.black,
      );

    final boldStyle = defaultStyle.copyWith(
      fontWeight: FontWeight.bold,
      color: highlightColor,
    );

    // RegEx para capturar textos entre <blue>...</blue>
    final regex = RegExp(r'<blue>(.*?)<\/blue>');
    final spans = <InlineSpan>[];

    int start = 0;
    for (final match in regex.allMatches(text)) {
      if (match.start > start) {
        spans.add(TextSpan(
          text: text.substring(start, match.start),
          style: defaultStyle,
        ));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: boldStyle,
      ));
      start = match.end;
    }

    // Último trecho (após o último match)
    if (start < text.length) {
      spans.add(TextSpan(
        text: text.substring(start),
        style: defaultStyle,
      ));
    }

    return RichText(
      textAlign: textAlign,
      text: TextSpan(children: spans),
    );
  }
}