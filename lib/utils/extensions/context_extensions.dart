import 'package:imprest_cash/shared/widgets/snackbar.dart';
import 'package:flutter/material.dart';

extension ScreenDimension on BuildContext {
  double get width => MediaQuery.sizeOf(this).width;
  double get height => MediaQuery.sizeOf(this).height;
}

extension ThemeExtension on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  // Text theme shortcuts
  TextStyle? get bodySmall => Theme.of(this).textTheme.bodySmall;
  TextStyle? get bodyMedium => Theme.of(this).textTheme.bodyMedium;
  TextStyle? get bodyLarge => Theme.of(this).textTheme.bodyLarge;

  TextStyle? get labelSmall => Theme.of(this).textTheme.labelSmall;
  TextStyle? get labelMedium => Theme.of(this).textTheme.labelMedium;
  TextStyle? get labelLarge => Theme.of(this).textTheme.labelLarge;

  TextStyle? get titleSmall => Theme.of(this).textTheme.titleSmall;
  TextStyle? get titleMedium => Theme.of(this).textTheme.titleMedium;
  TextStyle? get titleLarge => Theme.of(this).textTheme.titleLarge;

  TextStyle? get headlineSmall => Theme.of(this).textTheme.headlineSmall;
  TextStyle? get headlineMedium => Theme.of(this).textTheme.headlineMedium;
  TextStyle? get headlineLarge => Theme.of(this).textTheme.headlineLarge;
}

extension SnackbarExtension on BuildContext {
  void showSuccessSnackBar(
      {required String message, bool autoDismiss = true, int duration = 4000}) {
    showCustomSnackBar(
        context: this,
        message: message,
        autoDismiss: autoDismiss,
        duration: duration,
        type: SnackBarType.success);
  }

  void showAlertSnackBar(
      {required String message,
      bool autoDismiss = false,
      int duration = 4000}) {
    showCustomSnackBar(
        context: this,
        message: message,
        autoDismiss: autoDismiss,
        duration: duration,
        type: SnackBarType.alert);
  }

  void showFailureSnackBar(
      {required String message,
      bool autoDismiss = false,
      int duration = 4000}) {
    showCustomSnackBar(
        context: this,
        message: message,
        autoDismiss: autoDismiss,
        duration: duration,
        type: SnackBarType.failure);
  }

  void showNormalSnackBar(
      {required String message, bool autoDismiss = true, int duration = 4000}) {
    showCustomSnackBar(
        context: this,
        message: message,
        autoDismiss: autoDismiss,
        duration: duration);
  }
}
