import 'package:imprest_cash/shared/widgets/butttons/focus_icon_button.dart';
import 'package:flutter/material.dart';

class RepeaterAddButton extends StatelessWidget {
  const RepeaterAddButton({
    super.key,
    required this.focusNode,
    required this.onPressed,
    this.isTabKeyListening = false,
  });

  final FocusNode? focusNode;
  final VoidCallback? onPressed;
  final bool isTabKeyListening;

  @override
  Widget build(BuildContext context) {
    if (isTabKeyListening) {
      return FocusIconButton(
        focusNode: focusNode ?? FocusNode(),
        icon: Icons.add_circle,
        iconColor: Colors.green,
        focusedBackgroundColor: Colors.green.withValues(alpha: .1),
        onPressed: onPressed,
      );
    } else {
      return IconButton(
        focusNode: focusNode,
        icon: const Icon(Icons.add_circle, color: Colors.green),
        onPressed: onPressed,
      );
    }
  }
}
