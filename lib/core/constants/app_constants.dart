class AppConstants {
  static const String appName = 'Triple Prime';
  static const String appDescription = 'Food Saving Scheme';

  // API URLs
  static const String baseUrl = 'https://api.tripleprime.com.ng';
  static const String apiVersion = 'v1';

  // API Endpoints
  static const String authLogin = '/Authentication/login';
  static const String authRegister = '/Authentication/register';
  static const String authLogout = '/Authentication/logout';
  static const String authRefreshToken = '/Authentication/refresh-token';
  static const String authForgotPassword = '/Authentication/forgot-password';
  static const String authResetPassword = '/Authentication/reset-password';
  static const String userProfileUpdate = '/User/profile';
  static const String userDeviceToken = '/User/device-token';
  static const String userChangePassword = '/User/change-password';
  static const String userDelete = '/Authentication/users';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'app_theme';

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);

  // Validation
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String phonePattern = r'^\+234[0-9]{10}$';
  static const String passwordMinLength = '6';

  // Error Messages
  static const String networkError =
      'Network error occurred. Please try again.';
  static const String unknownError =
      'An unknown error occurred. Please try again.';
  static const String invalidEmail = 'Please enter a valid email address';
  static const String invalidPhone =
      'Please enter a valid Nigerian phone number';
  static const String invalidPassword =
      'Password must be at least 6 characters long';

  // Success Messages
  static const String loginSuccess = 'Login successful';
  static const String registerSuccess = 'Registration successful';
  static const String paymentSuccess = 'Payment successful';
  static const String savingsPlanCreated = 'Savings plan created successfully';

  // Currency
  static const String currencySymbol = '₦';
  static const String currencyCode = 'NGN';

  // Date Formats
  static const String dateFormat = 'MMM d, yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'MMM d, yyyy HH:mm';
}
