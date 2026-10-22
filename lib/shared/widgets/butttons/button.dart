import 'package:imprest_cash/theme/colors.dart';
import 'package:flutter/material.dart';

class AppPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final double? radius;
  final Color? backgroundColor;
  final Color? focusedColor;
  final Color? labelColor;
  final bool fullWidth;
  final FocusNode? focusNode;
  final bool autofocus;
  final Widget? child;
  final Widget? icon;

  const AppPrimaryButton({
    super.key,
    required this.label,
    this.focusNode,
    this.autofocus = false,
    this.focusedColor,
    this.radius,
    this.onPressed,
    this.width,
    this.height,
    this.backgroundColor,
    this.labelColor,
    this.fullWidth = false,
    this.child,
    this.icon,
  });

  /// Named constructor to create a button with an icon and label
  const AppPrimaryButton.icon({
    super.key,
    required this.label,
    required Widget this.icon,
    this.focusNode,
    this.autofocus = false,
    this.radius,
    this.focusedColor,
    this.onPressed,
    this.width,
    this.height,
    this.backgroundColor,
    this.labelColor,
    this.fullWidth = false,
  }) : child = null; // child must be null so build() can compose it

  const AppPrimaryButton.cancel({
    super.key,
    this.onPressed,
    this.focusNode,
    this.autofocus = false,
    this.width,
    this.height,
    this.radius,
    this.fullWidth = false,
  })  : label = "Cancel",
        backgroundColor = AppColors.cancelButtonBackgroundColor,
        labelColor = Colors.black,
        focusedColor = null,
        child = null,
        icon = null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultColor = backgroundColor ?? theme.colorScheme.primary;
    final defaultLabelColor = labelColor ?? theme.colorScheme.onPrimary;

    return SizedBox(
      width: fullWidth ? double.infinity : width,
      height: height ?? 42,
      child: ElevatedButton(
        focusNode: focusNode,
        autofocus: autofocus,
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.disabled)) {
                return defaultColor.withValues(alpha: 0.5);
              }
              if (states.contains(WidgetState.pressed)) {
                return defaultColor.withValues(alpha: 0.8);
              }
              if (states.contains(WidgetState.focused)) {
                // Focus color takes highest priority if provided
                return focusedColor ?? defaultColor.withValues(alpha: 0.9);
              }
              if (states.contains(WidgetState.hovered)) {
                // Hover color slightly lighter
                return (focusedColor ?? defaultColor).withValues(alpha: 0.85);
              }
              return defaultColor;
            },
          ),
          foregroundColor: WidgetStateProperty.all(defaultLabelColor),
          overlayColor: WidgetStateProperty.all(
            defaultLabelColor.withValues(alpha: 0.1),
          ),
          elevation: WidgetStateProperty.resolveWith<double>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.focused)) {
                return 4; // Focused elevation
              } else if (states.contains(WidgetState.hovered)) {
                return 4; // Focused elevation
              }
              return 0; // Default elevation
            },
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius ?? 6),
            ),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          textStyle: WidgetStateProperty.resolveWith<TextStyle?>(
            (Set<WidgetState> states) {
              return theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              );
            },
          ),
        ),
        child: child ??
            (icon != null
                ? FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        icon!,
                        const SizedBox(width: 4),
                        Text(
                          label,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : Text(
                    label,
                    textAlign: TextAlign.center,
                  )),
      ),
    );
  }
}

class AppOutlinedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final double? radius;
  final Color? backgroundColor;
  final Color? focusedColor;
  final Color? labelColor;
  final bool fullWidth;
  final FocusNode? focusNode;
  final Widget? child;
  final String? toolTip;
  final WidgetStateProperty<EdgeInsetsGeometry?>? padding;

  const AppOutlinedButton({
    super.key,
    required this.label,
    this.focusNode,
    this.toolTip,
    this.focusedColor = Colors.red,
    this.onPressed,
    this.width,
    this.height,
    this.radius,
    this.padding,
    this.backgroundColor,
    this.labelColor,
    this.fullWidth = false,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultLabelColor = labelColor ?? theme.colorScheme.primary;

    return SizedBox(
      width: fullWidth ? double.infinity : width,
      height: height ?? 38,
      child: OutlinedButton(
        focusNode: focusNode,
        onPressed: onPressed,
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(defaultLabelColor),
          overlayColor: WidgetStateProperty.all(
            defaultLabelColor.withValues(alpha: 0.1),
          ),
          elevation: WidgetStateProperty.all(0),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius ?? 30),
            ),
          ),
          padding: padding ??
              WidgetStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
          textStyle: WidgetStateProperty.all(
            theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        child: child ??
            Text(
              label,
              textAlign: TextAlign.center,
            ),
      ),
    );
  }
}
