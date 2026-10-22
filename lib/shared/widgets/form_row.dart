import 'package:imprest_cash/shared/widgets/texts.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class FormRowWidget extends StatelessWidget {
  const FormRowWidget({
    super.key,
    required this.label,
    required this.child,
    this.labelWidth,
    this.verticalPadding = 12,
    this.isRequired = false, // Default to false
    this.gapAfterLabel = 8,
  });

  final String label;
  final Widget child;
  final double? labelWidth;
  final double verticalPadding;
  final bool isRequired;
  final double gapAfterLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: labelWidth ?? 140,
            child: Row(
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (isRequired)
                  const Text(
                    ' *',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
          Gap(gapAfterLabel),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class FormColumnWidget extends StatelessWidget {
  const FormColumnWidget({
    super.key,
    required this.label,
    required this.child,
    this.labelWidth,
    this.verticalPadding,
    this.isRequired = false, // Default to false
  });

  final String label;
  final Widget child;
  final double? labelWidth;
  final bool isRequired;
  final double? verticalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding ?? 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SmallText(
                label,
                bold: false,
              ),
              if (isRequired)
                const Text(
                  ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const Gap(8),
          child,
        ],
      ),
    );
  }
}
