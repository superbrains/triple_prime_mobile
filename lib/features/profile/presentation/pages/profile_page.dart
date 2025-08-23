import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:triple_prime_mobile/core/app_router.dart';
import 'package:triple_prime_mobile/core/theme/app_theme.dart';
import 'package:triple_prime_mobile/core/utils/custom_snackbar.dart';
import 'package:triple_prime_mobile/shared/widgets/custom_text_field.dart';
import '../../notifiers/profile_notifier.dart';
import 'dart:developer' as developer;

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileNotifier(),
      child: Consumer<ProfileNotifier>(
        builder: (context, profileNotifier, child) {
          return Scaffold(
            backgroundColor: AppTheme.backgroundColor,
            body: profileNotifier.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Profile',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 24,
                              ),
                            ),
                            IconButton(
                              onPressed: () =>
                                  _showLogoutDialog(context, profileNotifier),
                              icon:
                                  const Icon(Icons.logout, color: Colors.black),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: Column(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppTheme.primaryColor,
                                      AppTheme.primaryColor
                                          .withValues(alpha: 0.8),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.primaryColor
                                          .withValues(alpha: 0.3),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                profileNotifier.fullName,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                profileNotifier.status,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: profileNotifier.statusColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Personal Information',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                  ),
                                  if (!profileNotifier.isEditing)
                                    IconButton(
                                      onPressed: () =>
                                          profileNotifier.toggleEditMode(),
                                      icon: const Icon(Icons.edit,
                                          color: AppTheme.primaryColor),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              if (profileNotifier.isEditing)
                                _buildEditForm(context, profileNotifier)
                              else
                                _buildInfoGrid(context, profileNotifier),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        if (profileNotifier.isEditing) ...[
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => profileNotifier.cancelEdit(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey.shade300,
                                    foregroundColor: Colors.black87,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                  ),
                                  child: const Text(
                                    'Cancel',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => profileNotifier
                                      .saveProfileChanges(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppTheme.primaryColor,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                  ),
                                  child: const Text(
                                    'Save Changes',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                        ],
                        _buildSection(
                          context,
                          'Account Settings',
                          [
                            _buildSettingItem(
                                context, 'Change Password', Icons.lock_outline,
                                onTap: () => Navigator.of(context)
                                    .pushNamed(AppRouter.changePassword)),
                            _buildSettingItem(context, 'Privacy Policy',
                                Icons.privacy_tip_outlined,
                                onTap: () => _launchPrivacyPolicy(context)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildSection(
                          context,
                          'Support',
                          [
                            _buildSettingItem(
                                context, 'Help Center', Icons.help_outline,
                                onTap: () => _launchWhatsApp(context)),
                            _buildSettingItem(context, 'Contact Support',
                                Icons.support_agent_outlined,
                                onTap: () => _launchContactSupport(context)),
                            _buildSettingItem(
                                context, 'About App', Icons.info_outline,
                                onTap: () => _launchAboutPage(context)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildSection(
                          context,
                          'Account Management',
                          [
                            _buildSettingItem(
                              context,
                              'Delete Account',
                              Icons.delete_forever_outlined,
                              onTap: () => _showDeleteAccountDialog(
                                  context, profileNotifier),
                              isDestructive: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildEditForm(BuildContext context, ProfileNotifier profileNotifier) {
    return Form(
      key: profileNotifier.editProfileFormKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  label: 'First Name',
                  controller: profileNotifier.firstNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  label: 'Last Name',
                  controller: profileNotifier.lastNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Email Address',
            controller: profileNotifier.emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
              if (!emailRegex.hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Phone Number',
            controller: profileNotifier.phoneController,
            keyboardType: TextInputType.phone,
            validator: (value) {
              // Phone number is optional, so no validation required
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Address',
            controller: profileNotifier.addressController,
            maxLines: 3,
            validator: (value) {
              // Address is optional, so no validation required
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoGrid(BuildContext context, ProfileNotifier profileNotifier) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              _buildInfoItem(
                context,
                'Full Name',
                profileNotifier.fullName,
                Icons.person_outline,
              ),
              const SizedBox(height: 20),
              _buildInfoItem(
                context,
                'Phone Number',
                profileNotifier.phoneNumber,
                Icons.phone_outlined,
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            children: [
              _buildInfoItem(
                context,
                'Email Address',
                profileNotifier.email,
                Icons.email_outlined,
              ),
              const SizedBox(height: 20),
              _buildInfoItem(
                context,
                'Address',
                profileNotifier.address,
                Icons.location_on_outlined,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
        ),
      ],
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  item,
                  if (index < items.length - 1)
                    Divider(
                      height: 1,
                      color: Colors.grey.shade200,
                      indent: 16,
                      endIndent: 16,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem(
    BuildContext context,
    String title,
    IconData icon, {
    VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : Colors.grey.shade600,
        size: 24,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDestructive ? Colors.red : Colors.black87,
              fontWeight: isDestructive ? FontWeight.w600 : FontWeight.normal,
            ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey.shade400,
        size: 20,
      ),
      onTap: onTap ??
          () {
            CustomSnackBar.showInfo(
                context, '$title functionality coming soon');
          },
    );
  }

  Future<void> _launchContactSupport(BuildContext context) async {
    const url = 'https://tripleprime.com.ng/contact';
    try {
      developer.log('Attempting to launch URL: $url');
      final uri = Uri.parse(url);

      final canLaunch = await canLaunchUrl(uri);
      developer.log('Can launch URL: $canLaunch');

      if (canLaunch) {
        final result = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        developer.log('Launch result: $result');

        if (!result && context.mounted) {
          CustomSnackBar.showError(context, 'Could not open contact page');
        }
      } else {
        developer.log('Cannot launch URL: $url');
        if (context.mounted) {
          CustomSnackBar.showError(
              context, 'No app available to open contact page');
        }
      }
    } catch (e) {
      developer.log('Error launching URL: $e');
      if (context.mounted) {
        CustomSnackBar.showError(
            context, 'Error opening contact page: ${e.toString()}');
      }
    }
  }

  Future<void> _launchAboutPage(BuildContext context) async {
    const url = 'https://tripleprime.com.ng/about';
    try {
      developer.log('Attempting to launch URL: $url');
      final uri = Uri.parse(url);

      final canLaunch = await canLaunchUrl(uri);
      developer.log('Can launch URL: $canLaunch');

      if (canLaunch) {
        final result = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        developer.log('Launch result: $result');

        if (!result && context.mounted) {
          CustomSnackBar.showError(context, 'Could not open about page');
        }
      } else {
        developer.log('Cannot launch URL: $url');
        if (context.mounted) {
          CustomSnackBar.showError(
              context, 'No app available to open about page');
        }
      }
    } catch (e) {
      developer.log('Error launching URL: $e');
      if (context.mounted) {
        CustomSnackBar.showError(
            context, 'Error opening about page: ${e.toString()}');
      }
    }
  }

  Future<void> _launchPrivacyPolicy(BuildContext context) async {
    const url = 'https://tripleprime.com.ng/privacy';
    try {
      developer.log('Attempting to launch Privacy Policy URL: $url');
      final uri = Uri.parse(url);

      final canLaunch = await canLaunchUrl(uri);
      developer.log('Can launch Privacy Policy URL: $canLaunch');

      if (canLaunch) {
        final result = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        developer.log('Privacy Policy launch result: $result');

        if (!result && context.mounted) {
          CustomSnackBar.showError(context, 'Could not open Privacy Policy');
        }
      } else {
        developer.log('Cannot launch Privacy Policy URL: $url');
        if (context.mounted) {
          CustomSnackBar.showError(
              context, 'No app available to open Privacy Policy');
        }
      }
    } catch (e) {
      developer.log('Error launching Privacy Policy URL: $e');
      if (context.mounted) {
        CustomSnackBar.showError(
            context, 'Error opening Privacy Policy: ${e.toString()}');
      }
    }
  }

  Future<void> _launchWhatsApp(BuildContext context) async {
    const phoneNumber = '+2348087134262';
    const message = 'Hello, I need support with Triple Prime app.';

    final whatsappUrl =
        'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}';

    try {
      developer.log('Attempting to launch WhatsApp URL: $whatsappUrl');
      final uri = Uri.parse(whatsappUrl);

      final canLaunch = await canLaunchUrl(uri);
      developer.log('Can launch WhatsApp URL: $canLaunch');

      if (canLaunch) {
        final result = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        developer.log('WhatsApp launch result: $result');

        if (!result && context.mounted) {
          CustomSnackBar.showError(context, 'Could not open WhatsApp');
        }
      } else {
        developer.log('Cannot launch WhatsApp URL: $whatsappUrl');
        if (context.mounted) {
          CustomSnackBar.showError(
              context, 'WhatsApp is not installed on this device');
        }
      }
    } catch (e) {
      developer.log('Error launching WhatsApp URL: $e');
      if (context.mounted) {
        CustomSnackBar.showError(
            context, 'Error opening WhatsApp: ${e.toString()}');
      }
    }
  }

  void _showLogoutDialog(
      BuildContext context, ProfileNotifier profileNotifier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              profileNotifier.logout(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(
      BuildContext context, ProfileNotifier profileNotifier) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red.shade600,
                  size: 30,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Delete Account',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                'Are you sure you want to delete your account? This action cannot be undone and will permanently remove all your data.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black54,
                      height: 1.5,
                    ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: profileNotifier.isDeletingAccount
                          ? null
                          : () async {
                              Navigator.of(context).pop();
                              await profileNotifier.deleteAccount(context);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: profileNotifier.isDeletingAccount
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Delete Account',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
