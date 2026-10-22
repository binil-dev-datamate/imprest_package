import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// App bar copied from Accounting.
///
/// The Accounting original renders `SelectedCompanyWidget` from the
/// company-selection cubit. Imprest has no such cubit: the host session
/// (INIT_SESSION) will supply this label in a later phase.
class AppCustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const AppCustomAppbar({
    super.key,
    required this.title,
    this.actions,
    this.titleStyle,
    this.showSelectionInfo = true,
    this.titleTooltip,
    this.sessionLabel = 'Waiting for session',
  });

  final String title;
  final String? titleTooltip;
  final List<Widget>? actions;
  final bool showSelectionInfo;
  final TextStyle? titleStyle;

  /// Company / branch / financial-year label from the host session.
  final String sessionLabel;

  @override
  Widget build(BuildContext context) {
    // Check if the current route can be popped
    bool canPop = ModalRoute.of(context)?.canPop ?? false;

    return Material(
      color: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 5,
      shadowColor: Colors.black.withValues(alpha: 0.25),
      surfaceTintColor: Colors.transparent,
      child: Container(
        height: preferredSize.height,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Row(
          children: [
            // Title section
            Expanded(
              child: Tooltip(
                message: titleTooltip ?? title,
                waitDuration: const Duration(milliseconds: 300),
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: titleStyle ??
                      Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
            // Actions section (including the close button)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (actions != null) ...actions!,
                if (showSelectionInfo)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.25),
                      ),
                    ),
                    child: Text(
                      sessionLabel,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                const Gap(16),
                if (canPop)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Focus(
                      skipTraversal: true,
                      child: IconButton(
                        tooltip: "Close (Esc)",
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: const Size(28, 28),
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        icon: const Icon(Icons.close,
                            size: 14, color: Colors.white),
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
