import 'package:intl/intl.dart';
import 'package:triple_prime_mobile/core/constants/app_constants.dart';

class AppUtils {
  static String formatCurrency(num amount) {
    final formatter = NumberFormat.currency(
      symbol: AppConstants.currencySymbol,
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  static String formatCurrencyWithCommas(num amount) {
    final formatter = NumberFormat.currency(
      symbol: AppConstants.currencySymbol,
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  static String formatAmount(num amount) {
    // Ensure all amounts are formatted with currency symbol
    return formatCurrency(amount);
  }

  static String formatAmountWithoutSymbol(num amount) {
    // Format amount without currency symbol but with commas
    final formatter = NumberFormat('#,###');
    return formatter.format(amount);
  }

  static String formatAmountWithSymbol(num amount) {
    // Format amount with currency symbol and commas
    return '${AppConstants.currencySymbol}${formatAmountWithoutSymbol(amount)}';
  }

  static String formatDate(DateTime date) {
    return DateFormat(AppConstants.dateFormat).format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat(AppConstants.dateTimeFormat).format(date);
  }

  static String formatPhoneNumber(String phone) {
    if (phone.startsWith('+234')) {
      return phone;
    }
    if (phone.startsWith('0')) {
      return '+234${phone.substring(1)}';
    }
    return '+234$phone';
  }

  static bool isValidEmail(String email) {
    return RegExp(AppConstants.emailPattern).hasMatch(email);
  }

  static bool isValidPhone(String phone) {
    return RegExp(AppConstants.phonePattern).hasMatch(phone);
  }

  static bool isValidPassword(String password) {
    return password.length >= int.parse(AppConstants.passwordMinLength);
  }

  static String getInitials(String name) {
    if (name.isEmpty) return '';

    final nameParts = name.split(' ');
    if (nameParts.length == 1) {
      return nameParts[0][0].toUpperCase();
    }

    return '${nameParts[0][0]}${nameParts[nameParts.length - 1][0]}'
        .toUpperCase();
  }

  static String calculateDailyAmount(num totalAmount, int durationInMonths) {
    final daysInDuration = durationInMonths * 30;
    return formatCurrency(totalAmount / daysInDuration);
  }

  static String calculateProgress(num amountPaid, num totalAmount) {
    final progress = (amountPaid / totalAmount * 100).toStringAsFixed(0);
    return '$progress%';
  }

  static String getTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return formatDate(date);
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  static String maskCardNumber(String cardNumber) {
    if (cardNumber.length < 4) return cardNumber;
    return '•••• ${cardNumber.substring(cardNumber.length - 4)}';
  }

  static String getMonthYear(DateTime date) {
    return DateFormat('MM/yy').format(date);
  }
}
