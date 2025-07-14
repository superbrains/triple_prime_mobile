import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:triple_prime_mobile/core/theme/app_theme.dart';

class CustomSnackBar {
  static void showSuccess(BuildContext context, String message) {
    Flushbar(
      message: message,
      messageColor: Colors.white,
      backgroundColor: Colors.green,
      icon: const Icon(
        Icons.check_circle,
        color: Colors.white,
        size: 28.0,
      ),
      leftBarIndicatorColor: Colors.green.shade300,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      isDismissible: true,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      positionOffset: 0,
      boxShadows: [
        BoxShadow(
          color: Colors.green.withOpacity(0.3),
          offset: const Offset(0, 4),
          blurRadius: 12,
        ),
      ],
    ).show(context);
  }

  static void showError(BuildContext context, String message) {
    Flushbar(
      message: message,
      messageColor: Colors.white,
      backgroundColor: Colors.red,
      icon: const Icon(
        Icons.error,
        color: Colors.white,
        size: 28.0,
      ),
      leftBarIndicatorColor: Colors.red.shade300,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      isDismissible: true,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      positionOffset: 0,
      boxShadows: [
        BoxShadow(
          color: Colors.red.withOpacity(0.3),
          offset: const Offset(0, 4),
          blurRadius: 12,
        ),
      ],
    ).show(context);
  }

  static void showWarning(BuildContext context, String message) {
    Flushbar(
      message: message,
      messageColor: Colors.white,
      backgroundColor: Colors.orange,
      icon: const Icon(
        Icons.warning,
        color: Colors.white,
        size: 28.0,
      ),
      leftBarIndicatorColor: Colors.orange.shade300,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      isDismissible: true,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      positionOffset: 0,
      boxShadows: [
        BoxShadow(
          color: Colors.orange.withOpacity(0.3),
          offset: const Offset(0, 4),
          blurRadius: 12,
        ),
      ],
    ).show(context);
  }

  static void showInfo(BuildContext context, String message) {
    Flushbar(
      message: message,
      messageColor: Colors.white,
      backgroundColor: Colors.blue,
      icon: const Icon(
        Icons.info,
        color: Colors.white,
        size: 28.0,
      ),
      leftBarIndicatorColor: Colors.blue.shade300,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      isDismissible: true,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      positionOffset: 0,
      boxShadows: [
        BoxShadow(
          color: Colors.blue.withOpacity(0.3),
          offset: const Offset(0, 4),
          blurRadius: 12,
        ),
      ],
    ).show(context);
  }

  static void showCustom(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    required IconData icon,
    Duration? duration,
    bool showProgressIndicator = false,
    VoidCallback? onTap,
  }) {
    Flushbar(
      message: message,
      messageColor: Colors.white,
      backgroundColor: backgroundColor,
      icon: Icon(
        icon,
        color: Colors.white,
        size: 28.0,
      ),
      leftBarIndicatorColor: backgroundColor.withOpacity(0.7),
      duration: duration ?? const Duration(seconds: 3),
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      isDismissible: true,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      positionOffset: 0,
      showProgressIndicator: showProgressIndicator,
      onTap: onTap != null ? (_) => onTap() : null,
      boxShadows: [
        BoxShadow(
          color: backgroundColor.withOpacity(0.3),
          offset: const Offset(0, 4),
          blurRadius: 12,
        ),
      ],
    ).show(context);
  }

  // Loading snackbar with progress indicator
  static void showLoading(BuildContext context, String message) {
    Flushbar(
      message: message,
      messageColor: Colors.white,
      backgroundColor: AppTheme.primaryColor,
      icon: const Icon(
        Icons.hourglass_empty,
        color: Colors.white,
        size: 28.0,
      ),
      leftBarIndicatorColor: AppTheme.primaryColor.withOpacity(0.7),
      duration: const Duration(seconds: 10), // Longer duration for loading
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      isDismissible: false, // Don't allow dismissal during loading
      positionOffset: 0,
      showProgressIndicator: true,
      progressIndicatorBackgroundColor: Colors.white.withOpacity(0.3),
      progressIndicatorValueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      boxShadows: [
        BoxShadow(
          color: AppTheme.primaryColor.withOpacity(0.3),
          offset: const Offset(0, 4),
          blurRadius: 12,
        ),
      ],
    ).show(context);
  }

  // Dismiss all snackbars
  static void dismissAll(BuildContext context) {}
}
