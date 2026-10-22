import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:imprest_cash/shared/widgets/appbar.dart';
import 'package:imprest_cash/shared/wrappers/escape_pop_wrapper_v2.dart';

/// Placeholder for an Imprest page that is not built yet.
///
/// Every dashboard menu item opens this page so navigation (including
/// Esc / red-close back to the dashboard) can be checked end to end.
class ImprestPlaceholderPage extends StatelessWidget {
  const ImprestPlaceholderPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return EscapePoppableWrapperV2(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppCustomAppbar(
          title: title,
          // sessionLabel: 'Waiting for session',
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Gap(8),
              Text(
                'This screen is not built yet.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.grey.shade600),
              ),
              const Gap(8),
              Text(
                'Press Esc to go back to the dashboard.',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
