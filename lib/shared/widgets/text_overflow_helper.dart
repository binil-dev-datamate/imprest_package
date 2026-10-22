import 'package:flutter/material.dart';

class TextOverflowHelper {
  static bool isTextOverflowing(
      {required String text,
      required TextStyle? style,
      required double maxWidth,
      TextDirection textDirection = TextDirection.ltr}) {
    if (text.isEmpty || maxWidth <= 0) return false;

    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: textDirection,
      maxLines: 1,
    );

    painter.layout(maxWidth: double.infinity);

    return painter.size.width > maxWidth;
  }

  static Widget ellipsisIndicator(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: Text('...',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600,
          )),
    );
  }
}
