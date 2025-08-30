class RegisterRequest {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? address;
  final String? referralCode;

  const RegisterRequest({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.address,
    this.referralCode,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) {
    return RegisterRequest(
      email: json['email'] as String,
      password: json['password'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      address: json['address'] as String?,
      referralCode: json['referralCode'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      if (phoneNumber != null && phoneNumber!.isNotEmpty)
        'phoneNumber': phoneNumber,
      if (address != null && address!.isNotEmpty) 'address': address,
      if (referralCode != null) 'referralCode': referralCode,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RegisterRequest &&
        other.email == email &&
        other.password == password &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.phoneNumber == phoneNumber &&
        other.address == address &&
        other.referralCode == referralCode;
  }

  @override
  int get hashCode {
    return Object.hash(
      email,
      password,
      firstName,
      lastName,
      phoneNumber,
      address,
      referralCode,
    );
  }

  @override
  String toString() {
    return 'RegisterRequest(email: $email, password: $password, firstName: $firstName, lastName: $lastName, phoneNumber: $phoneNumber, address: $address, referralCode: $referralCode)';
  }
}

class LoginRequest {
  final String email;
  final String password;

  const LoginRequest({
    required this.email,
    required this.password,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) {
    return LoginRequest(
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoginRequest &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode {
    return Object.hash(email, password);
  }

  @override
  String toString() {
    return 'LoginRequest(email: $email, password: $password)';
  }
}

class LoginResponse {
  final bool success;
  final String? message;
  final LoginData? data;
  final List<String>? errors;
  final String? timestamp;

  const LoginResponse({
    required this.success,
    this.message,
    this.data,
    this.errors,
    this.timestamp,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      data: json['data'] != null
          ? LoginData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      errors: json['errors'] != null
          ? List<String>.from(json['errors'] as List)
          : null,
      timestamp: json['timestamp'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      if (message != null) 'message': message,
      if (data != null) 'data': data!.toJson(),
      if (errors != null) 'errors': errors,
      if (timestamp != null) 'timestamp': timestamp,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoginResponse &&
        other.success == success &&
        other.message == message &&
        other.data == data &&
        other.errors == errors &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return Object.hash(
      success,
      message,
      data,
      errors,
      timestamp,
    );
  }

  @override
  String toString() {
    return 'LoginResponse(success: $success, message: $message, data: $data, errors: $errors, timestamp: $timestamp)';
  }
}

class LoginData {
  final bool success;
  final String? errorMessage;
  final UserData? user;
  final List<Claim>? claims;
  final List<String>? roles;

  const LoginData({
    required this.success,
    this.errorMessage,
    this.user,
    this.claims,
    this.roles,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      success: json['success'] as bool? ?? false,
      errorMessage: json['errorMessage'] as String?,
      user: json['user'] != null
          ? UserData.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      claims: json['claims'] != null
          ? List<Claim>.from(
              (json['claims'] as List).map((x) => Claim.fromJson(x)))
          : null,
      roles: json['roles'] != null
          ? List<String>.from(json['roles'] as List)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      if (errorMessage != null) 'errorMessage': errorMessage,
      if (user != null) 'user': user!.toJson(),
      if (claims != null) 'claims': claims!.map((x) => x.toJson()).toList(),
      if (roles != null) 'roles': roles,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoginData &&
        other.success == success &&
        other.errorMessage == errorMessage &&
        other.user == user &&
        other.claims == claims &&
        other.roles == roles;
  }

  @override
  int get hashCode {
    return Object.hash(
      success,
      errorMessage,
      user,
      claims,
      roles,
    );
  }

  @override
  String toString() {
    return 'LoginData(success: $success, errorMessage: $errorMessage, user: $user, claims: $claims, roles: $roles)';
  }
}

class Claim {
  final String issuer;
  final String originalIssuer;
  final Map<String, dynamic> properties;
  final String? subject;
  final String type;
  final String value;
  final String valueType;

  const Claim({
    required this.issuer,
    required this.originalIssuer,
    required this.properties,
    this.subject,
    required this.type,
    required this.value,
    required this.valueType,
  });

  factory Claim.fromJson(Map<String, dynamic> json) {
    return Claim(
      issuer: json['issuer']?.toString() ?? '',
      originalIssuer: json['originalIssuer']?.toString() ?? '',
      properties: json['properties'] != null
          ? Map<String, dynamic>.from(json['properties'] as Map)
          : <String, dynamic>{},
      subject: json['subject'] as String?,
      type: json['type']?.toString() ?? '',
      value: json['value']?.toString() ?? '',
      valueType: json['valueType']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'issuer': issuer,
      'originalIssuer': originalIssuer,
      'properties': properties,
      if (subject != null) 'subject': subject,
      'type': type,
      'value': value,
      'valueType': valueType,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Claim &&
        other.issuer == issuer &&
        other.originalIssuer == originalIssuer &&
        other.properties == properties &&
        other.subject == subject &&
        other.type == type &&
        other.value == value &&
        other.valueType == valueType;
  }

  @override
  int get hashCode {
    return Object.hash(
      issuer,
      originalIssuer,
      properties,
      subject,
      type,
      value,
      valueType,
    );
  }

  @override
  String toString() {
    return 'Claim(issuer: $issuer, originalIssuer: $originalIssuer, properties: $properties, subject: $subject, type: $type, value: $value, valueType: $valueType)';
  }
}

class ProfileUpdateRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String? phoneNumber;
  final String? address;

  const ProfileUpdateRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
    this.address,
  });

  factory ProfileUpdateRequest.fromJson(Map<String, dynamic> json) {
    return ProfileUpdateRequest(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      address: json['address'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      if (phoneNumber != null && phoneNumber!.isNotEmpty)
        'phoneNumber': phoneNumber,
      if (address != null && address!.isNotEmpty) 'address': address,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProfileUpdateRequest &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.address == address;
  }

  @override
  int get hashCode {
    return Object.hash(
      firstName,
      lastName,
      email,
      phoneNumber,
      address,
    );
  }

  @override
  String toString() {
    return 'ProfileUpdateRequest(firstName: $firstName, lastName: $lastName, email: $email, phoneNumber: $phoneNumber, address: $address)';
  }
}

class AuthResponse {
  final bool success;
  final String? message;
  final String? token;
  final UserData? user;
  final List<String>? errors;
  final String? timestamp;

  const AuthResponse({
    required this.success,
    this.message,
    this.token,
    this.user,
    this.errors,
    this.timestamp,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {

    UserData? user;
    String? token;

    if (json['data'] != null && json['data'] is Map<String, dynamic>) {
      final data = json['data'] as Map<String, dynamic>;

      if (data['user'] != null) {
        user = UserData.fromJson(data['user'] as Map<String, dynamic>);
      }

      token = data['token'] as String?;
    } else {
      if (json['user'] != null) {
        user = UserData.fromJson(json['user'] as Map<String, dynamic>);
      }
      token = json['token'] as String?;
    }

    return AuthResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      token: token,
      user: user,
      errors: json['errors'] != null
          ? List<String>.from(json['errors'] as List)
          : null,
      timestamp: json['timestamp'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      if (message != null) 'message': message,
      if (token != null) 'token': token,
      if (user != null) 'user': user!.toJson(),
      if (errors != null) 'errors': errors,
      if (timestamp != null) 'timestamp': timestamp,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthResponse &&
        other.success == success &&
        other.message == message &&
        other.token == token &&
        other.user == user &&
        other.errors == errors &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return Object.hash(
      success,
      message,
      token,
      user,
      errors,
      timestamp,
    );
  }

  @override
  String toString() {
    return 'AuthResponse(success: $success, message: $message, token: $token, user: $user, errors: $errors, timestamp: $timestamp)';
  }
}

class UserData {
  final String id;
  final String userName;
  final String normalizedUserName;
  final String email;
  final String normalizedEmail;
  final bool emailConfirmed;
  final String passwordHash;
  final String securityStamp;
  final String concurrencyStamp;
  final String? phoneNumber;
  final bool phoneNumberConfirmed;
  final bool twoFactorEnabled;
  final DateTime? lockoutEnd;
  final bool lockoutEnabled;
  final int accessFailedCount;
  final String firstName;
  final String lastName;
  final String? address;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final dynamic notificationPreferences;
  final dynamic deliveryPreferences;
  final dynamic languagePreference;
  final dynamic deliveryAddresses;
  final dynamic paymentMethods;
  final dynamic foodPacks;
  final dynamic payments;
  final dynamic referrals;
  final dynamic reports;
  final dynamic deliveries;
  final dynamic userRoles;
  final dynamic savingsPlans;

  const UserData({
    required this.id,
    required this.userName,
    required this.normalizedUserName,
    required this.email,
    required this.normalizedEmail,
    required this.emailConfirmed,
    required this.passwordHash,
    required this.securityStamp,
    required this.concurrencyStamp,
    this.phoneNumber,
    required this.phoneNumberConfirmed,
    required this.twoFactorEnabled,
    this.lockoutEnd,
    required this.lockoutEnabled,
    required this.accessFailedCount,
    required this.firstName,
    required this.lastName,
    this.address,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
    this.notificationPreferences,
    this.deliveryPreferences,
    this.languagePreference,
    this.deliveryAddresses,
    this.paymentMethods,
    this.foodPacks,
    this.payments,
    this.referrals,
    this.reports,
    this.deliveries,
    this.userRoles,
    this.savingsPlans,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id']?.toString() ?? '',
      userName: json['userName']?.toString() ?? '',
      normalizedUserName: json['normalizedUserName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      normalizedEmail: json['normalizedEmail']?.toString() ?? '',
      emailConfirmed: json['emailConfirmed'] as bool? ?? false,
      passwordHash: json['passwordHash']?.toString() ?? '',
      securityStamp: json['securityStamp']?.toString() ?? '',
      concurrencyStamp: json['concurrencyStamp']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString(),
      phoneNumberConfirmed: json['phoneNumberConfirmed'] as bool? ?? false,
      twoFactorEnabled: json['twoFactorEnabled'] as bool? ?? false,
      lockoutEnd: json['lockoutEnd'] != null
          ? DateTime.tryParse(json['lockoutEnd'].toString())
          : null,
      lockoutEnabled: json['lockoutEnabled'] as bool? ?? false,
      accessFailedCount: json['accessFailedCount'] as int? ?? 0,
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      address: json['address']?.toString(),
      isActive: json['isActive'] as bool? ?? false,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      notificationPreferences: json['notificationPreferences'],
      deliveryPreferences: json['deliveryPreferences'],
      languagePreference: json['languagePreference'],
      deliveryAddresses: json['deliveryAddresses'],
      paymentMethods: json['paymentMethods'],
      foodPacks: json['foodPacks'],
      payments: json['payments'],
      referrals: json['referrals'],
      reports: json['reports'],
      deliveries: json['deliveries'],
      userRoles: json['userRoles'],
      savingsPlans: json['savingsPlans'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'normalizedUserName': normalizedUserName,
      'email': email,
      'normalizedEmail': normalizedEmail,
      'emailConfirmed': emailConfirmed,
      'passwordHash': passwordHash,
      'securityStamp': securityStamp,
      'concurrencyStamp': concurrencyStamp,
      'phoneNumber': phoneNumber,
      'phoneNumberConfirmed': phoneNumberConfirmed,
      'twoFactorEnabled': twoFactorEnabled,
      if (lockoutEnd != null) 'lockoutEnd': lockoutEnd!.toIso8601String(),
      'lockoutEnabled': lockoutEnabled,
      'accessFailedCount': accessFailedCount,
      'firstName': firstName,
      'lastName': lastName,
      'address': address,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      'notificationPreferences': notificationPreferences,
      'deliveryPreferences': deliveryPreferences,
      'languagePreference': languagePreference,
      'deliveryAddresses': deliveryAddresses,
      'paymentMethods': paymentMethods,
      'foodPacks': foodPacks,
      'payments': payments,
      'referrals': referrals,
      'reports': reports,
      'deliveries': deliveries,
      'userRoles': userRoles,
      'savingsPlans': savingsPlans,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserData &&
        other.id == id &&
        other.userName == userName &&
        other.normalizedUserName == normalizedUserName &&
        other.email == email &&
        other.normalizedEmail == normalizedEmail &&
        other.emailConfirmed == emailConfirmed &&
        other.passwordHash == passwordHash &&
        other.securityStamp == securityStamp &&
        other.concurrencyStamp == concurrencyStamp &&
        other.phoneNumber == phoneNumber &&
        other.phoneNumberConfirmed == phoneNumberConfirmed &&
        other.twoFactorEnabled == twoFactorEnabled &&
        other.lockoutEnd == lockoutEnd &&
        other.lockoutEnabled == lockoutEnabled &&
        other.accessFailedCount == accessFailedCount &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.address == address &&
        other.isActive == isActive &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      userName,
      email,
      firstName,
      lastName,
      phoneNumber,
      address,
      isActive,
      createdAt,
      updatedAt,
    );
  }

  @override
  String toString() {
    return 'UserData(id: $id, userName: $userName, email: $email, firstName: $firstName, lastName: $lastName, phoneNumber: $phoneNumber, address: $address, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

class ApiError {
  final bool success;
  final String message;
  final List<String>? errors;
  final String? timestamp;

  const ApiError({
    required this.success,
    required this.message,
    this.errors,
    this.timestamp,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      success: json['success'] as bool? ?? false,
      message: json['message']?.toString() ?? 'An error occurred',
      errors: json['errors'] != null
          ? List<String>.from(json['errors'] as List)
          : null,
      timestamp: json['timestamp'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      if (errors != null) 'errors': errors,
      if (timestamp != null) 'timestamp': timestamp,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ApiError &&
        other.success == success &&
        other.message == message &&
        other.errors == errors &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return Object.hash(success, message, errors, timestamp);
  }

  @override
  String toString() {
    return 'ApiError(success: $success, message: $message, errors: $errors, timestamp: $timestamp)';
  }
}
