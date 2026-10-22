import 'package:imprest_cash/core/api_error_type.dart';
import 'package:imprest_cash/shared/widgets/butttons/button.dart';
import 'package:imprest_cash/shared/widgets/texts.dart';
import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  final String message;
  final ApiErrorType? errorType;
  final VoidCallback? onRetry;
  final Color? messageColor;

  const CustomErrorWidget({
    super.key,
    required this.message,
    this.errorType,
    this.onRetry,
    this.messageColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color finalColor = messageColor ?? Colors.red;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            errorType?.icon ?? Icons.error_outline,
            size: 50,
            color: finalColor,
          ),
          const SizedBox(height: 10),
          FormLabelText(
            message,
            color: finalColor,
            align: TextAlign.center,
            maxLines: 4,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            AppPrimaryButton.icon(
              label: 'Retry',
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ],
      ),
    );
  }
}
