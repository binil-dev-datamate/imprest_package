import 'package:imprest_cash/shared/widgets/texts.dart';
import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? textColor;
  final Color? keyTextColor;
  final Color? iconColor;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.textColor,
    this.iconColor,
    this.keyTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child:
                Icon(icon, color: iconColor ?? Colors.grey.shade500, size: 20),
          ),
          SizedBox(
            width: 100,
            child: SmallText(
              label,
              color: keyTextColor ?? Colors.grey,
            ),
          ),
          Expanded(
            child: FormLabelText(
              value,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
