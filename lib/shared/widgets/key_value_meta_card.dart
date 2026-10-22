import 'package:imprest_cash/shared/widgets/overflow_aware_text.dart';
import 'package:imprest_cash/shared/widgets/read_only_display.dart';
import 'package:imprest_cash/shared/widgets/texts.dart';
import 'package:imprest_cash/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

/// Horizontal wrap of label/value pairs used on read-only detail headers.
class KeyValueMetaCard extends StatelessWidget {
  const KeyValueMetaCard({
    super.key,
    required this.entries,
    this.itemWidth = 220,
    this.copyable = false,
  });

  final List<MapEntry<String, String>> entries;
  final double itemWidth;
  final bool copyable;

  static const _valueStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    wordSpacing: -1,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Wrap(
        spacing: 32,
        runSpacing: 14,
        children: [
          for (final e in entries)
            ConstrainedBox(
              constraints: BoxConstraints(minWidth: itemWidth, maxWidth: 360),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SmallText(e.key, color: AppColors.textGreyColor),
                  const Gap(3),
                  if (copyable)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _overflowValue(e.value),
                        const Gap(8),
                        IconButton(
                          tooltip: 'Copy',
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 28,
                            minHeight: 28,
                          ),
                          icon: const Icon(
                            Icons.copy_outlined,
                            size: 14,
                            color: AppColors.appThemeColorLight,
                          ),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: e.value));
                          },
                        ),
                      ],
                    )
                  else
                    _overflowValue(e.value),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _overflowValue(String value) {
    if (ReadOnlyDisplay.isEmptyPlaceholder(value)) {
      return SmallText(
        value,
        color: AppColors.textGreyColor,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    }
    return Text(
      value,
      style: _valueStyle,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ).withOverflowTooltip(
      waitDuration: const Duration(milliseconds: 400),
    );
  }
}
