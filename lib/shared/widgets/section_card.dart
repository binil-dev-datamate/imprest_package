import 'package:flutter/material.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({super.key, this.title, required this.children});

  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              title!,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: colors.primary),
            ),
          ),
        ...children,
      ],
    );
  }
}
