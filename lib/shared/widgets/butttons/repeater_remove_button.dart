import 'package:flutter/material.dart';

class RepeaterRemoveButton extends StatelessWidget {
  const RepeaterRemoveButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.delete,
        color: onPressed == null ? Colors.grey : Colors.red,
      ),
      onPressed: onPressed,
    );
  }
}
