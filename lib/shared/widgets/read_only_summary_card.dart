import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SummaryRowData {
  const SummaryRowData({
    required this.label,
    required this.value,
    this.bold = false,
    this.showDividerBefore = false,
  });

  final String label;
  final String value;
  final bool bold;
  final bool showDividerBefore;
}

/// Read-only totals card matching the invoice summary panel chrome.
class ReadOnlySummaryCard extends StatelessWidget {
  const ReadOnlySummaryCard({
    super.key,
    this.title = 'Summary',
    required this.rows,
  });

  final String title;
  final List<SummaryRowData> rows;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Gap(12),
          for (final row in rows) ...[
            if (row.showDividerBefore) const Divider(height: 20),
            _row(theme, row),
          ],
        ],
      ),
    );
  }

  Widget _row(ThemeData theme, SummaryRowData row) {
    final style = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: row.bold ? FontWeight.w700 : FontWeight.w400,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            row.label,
            style: style?.copyWith(
              color: row.bold ? null : Colors.grey.shade700,
            ),
          ),
          Text(row.value, style: style),
        ],
      ),
    );
  }
}
