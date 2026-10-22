import 'package:imprest_cash/shared/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormCheckboxRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final FocusNode? focusNode;
  final VoidCallback? onFieldSubmitted;
  final double height;

  const FormCheckboxRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.focusNode,
    this.onFieldSubmitted,
    this.height = 46,
  });

  void _onRowTap() {
    focusNode?.requestFocus();
    onChanged?.call(!value);
  }

  Widget _buildContainer(BuildContext context,
      {required Color borderColor,
      required double borderWidth,
      VoidCallback? onTap}) {
    final container = Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: borderWidth),
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: SmallText(label)),
          Checkbox(
            onChanged: onChanged,
            value: value,
          ),
        ],
      ),
    );
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: container,
      );
    }
    return container;
  }

  @override
  Widget build(BuildContext context) {
    if (focusNode != null) {
      return Focus(
        focusNode: focusNode,
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.enter) {
              onFieldSubmitted?.call();
              return KeyEventResult.handled;
            }
            if (event.logicalKey == LogicalKeyboardKey.space) {
              onChanged?.call(!value);
              return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
        child: ListenableBuilder(
          listenable: focusNode!,
          builder: (context, _) {
            final theme = Theme.of(context);
            final borderColor = focusNode!.hasFocus
                ? theme.colorScheme.primary
                : Colors.grey.shade300;
            final borderWidth = focusNode!.hasFocus ? 1.5 : 1.0;
            final isInteractive = onChanged != null || focusNode != null;
            return _buildContainer(
              context,
              borderColor: borderColor,
              borderWidth: borderWidth,
              onTap: isInteractive ? _onRowTap : null,
            );
          },
        ),
      );
    }
    final isInteractive = onChanged != null || focusNode != null;
    return _buildContainer(
      context,
      borderColor: Colors.grey.shade300,
      borderWidth: 1.0,
      onTap: isInteractive ? _onRowTap : null,
    );
  }
}
