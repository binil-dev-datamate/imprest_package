import 'package:imprest_cash/theme/colors.dart';
import 'package:flutter/material.dart';

/// One empty/placeholder state for the whole app: a centered icon, a title,
/// an optional body line and an optional action. Use this instead of bare
/// `Center(child: Text(...))` so report and list screens read uniformly.
class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? body;
  final Widget? action;
  final Color? iconColor;

  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.body,
    this.action,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: iconColor ?? AppColors.textGreyColor),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.displaySmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          if (body != null) ...[
            const SizedBox(height: 6),
            Text(
              body!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: AppColors.textGreyColor),
            ),
          ],
          if (action != null) ...[
            const SizedBox(height: 16),
            action!,
          ],
        ],
      ),
    );
  }
}
