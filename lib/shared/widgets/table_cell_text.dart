import 'package:imprest_cash/shared/widgets/read_only_display.dart';
import 'package:imprest_cash/shared/widgets/texts.dart';
import 'package:imprest_cash/theme/colors.dart';
import 'package:flutter/material.dart';

/// Read-only table cell text that greys [ReadOnlyDisplay] empty placeholders.
class TableCellText extends StatelessWidget {
  const TableCellText(
    this.value, {
    super.key,
    this.align = TextAlign.left,
    this.bold = false,
    this.maxLines = 2,
    this.style,
  });

  /// Raw or already-formatted cell value. Null/blank becomes [ReadOnlyDisplay.empty].
  final String? value;
  final TextAlign align;
  final bool bold;
  final int maxLines;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final text = ReadOnlyDisplay.isEmptyPlaceholder(value)
        ? value!
        : ReadOnlyDisplay.text(value);
    if (ReadOnlyDisplay.isEmptyPlaceholder(text)) {
      return SmallText(
        text,
        color: AppColors.textGreyColor,
        align: align,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
      );
    }
    return Text(
      text,
      textAlign: align,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
      style: bold
          ? (style ?? Theme.of(context).textTheme.bodySmall)
              ?.copyWith(fontWeight: FontWeight.w700)
          : style,
    );
  }
}
