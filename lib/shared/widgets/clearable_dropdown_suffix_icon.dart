import 'package:flutter/material.dart';

class ClearableDropdownSuffixIcon extends StatelessWidget {
  const ClearableDropdownSuffixIcon({
    super.key,
    required this.enabled,
    this.onClear,
  });

  final bool enabled;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final arrowIcon = Icon(
      Icons.keyboard_arrow_down,
      size: 20,
      color: enabled ? Theme.of(context).primaryColor : Colors.grey,
    );

    if (onClear == null) return arrowIcon;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: enabled ? onClear : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Icon(
              Icons.close,
              size: 18,
              color: enabled ? Colors.grey.shade700 : Colors.grey,
            ),
          ),
        ),
        arrowIcon,
      ],
    );
  }
}
