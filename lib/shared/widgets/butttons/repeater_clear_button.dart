import 'package:flutter/material.dart';

class RepeaterClearButton extends StatelessWidget {
  const RepeaterClearButton({
    super.key,
    required this.onPressed,
    this.color,
  });

  final VoidCallback? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.clear,
        size: 18,
        color: color,
      ),
      onPressed: onPressed,
    );
  }
}
