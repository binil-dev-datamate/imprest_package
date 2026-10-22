import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FocusIconButton extends StatelessWidget {
  final FocusNode focusNode;
  final VoidCallback? onPressed;
  final IconData icon;
  final Color iconColor;
  final Color focusedBackgroundColor;
  final Color? defaultBackgroundColor;

  const FocusIconButton({
    super.key,
    required this.focusNode,
    required this.onPressed,
    this.icon = Icons.add,
    this.iconColor = Colors.green,
    this.focusedBackgroundColor = const Color.fromRGBO(0, 128, 0, 0.1),
    this.defaultBackgroundColor,
  });

  bool get isShiftPressed =>
      HardwareKeyboard.instance.logicalKeysPressed
          .contains(LogicalKeyboardKey.shiftLeft) ||
      HardwareKeyboard.instance.logicalKeysPressed
          .contains(LogicalKeyboardKey.shiftRight);

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: focusNode,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent) {
          // Ignore Shift+Tab
          if (event.logicalKey == LogicalKeyboardKey.tab && isShiftPressed) {
            return KeyEventResult.ignored;
          }

          if (event.logicalKey == LogicalKeyboardKey.tab ||
              event.logicalKey == LogicalKeyboardKey.enter) {
            if (onPressed != null) {
              onPressed!();
            }
            return KeyEventResult.handled;
          }
        }
        return KeyEventResult.ignored;
      },
      child: Builder(builder: (context) {
        final bool hasFocus = Focus.of(context).hasFocus;
        return IconButton(
          icon: Icon(icon, color: iconColor),
          style: IconButton.styleFrom(
            backgroundColor:
                hasFocus ? focusedBackgroundColor : defaultBackgroundColor,
          ),
          onPressed: onPressed,
        );
      }),
    );
  }
}
