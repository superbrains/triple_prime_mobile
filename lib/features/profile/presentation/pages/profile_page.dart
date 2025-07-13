import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildTabs(context),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPersonalDetails(context),
                  _buildPaymentMethods(context),
                  _buildSettings(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(
              Icons.person_outline,
              size: 32,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'John Doe',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'john@example.com',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // TODO: Implement logout
            },
            icon: const Icon(Icons.logout),
            color: Colors.red,
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.2, end: 0);
  }

  Widget _buildTabs(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: Theme.of(context).colorScheme.primary,
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: Theme.of(context).colorScheme.primary,
        tabs: const [
          Tab(text: 'Personal'),
          Tab(text: 'Payment'),
          Tab(text: 'Settings'),
        ],
      ),
    );
  }

  Widget _buildPersonalDetails(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'Personal Information'),
          const SizedBox(height: 16),
          _buildInfoCard(
            context,
            [
              {
                'icon': Icons.person_outline,
                'label': 'Full Name',
                'value': 'John Doe',
              },
              {
                'icon': Icons.email_outlined,
                'label': 'Email',
                'value': 'john@example.com',
              },
              {
                'icon': Icons.phone_outlined,
                'label': 'Phone',
                'value': '+234 800 000 0000',
              },
              {
                'icon': Icons.location_on_outlined,
                'label': 'Address',
                'value': 'No address provided',
              },
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildPaymentMethods(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'Payment Methods'),
          const SizedBox(height: 16),
          _buildPaymentMethodCard(
            context,
            'Visa ending in 1234',
            'Expires 12/24',
            Icons.credit_card,
          ),
          const SizedBox(height: 16),
          _buildPaymentMethodCard(
            context,
            'Mastercard ending in 5678',
            'Expires 03/25',
            Icons.credit_card,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Add Payment Method'),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildSettings(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, 'Preferences'),
          const SizedBox(height: 16),
          _buildSettingItem(
            context,
            'Notifications',
            'Receive payment reminders and updates',
            true,
            (value) {},
          ),
          _buildSettingItem(
            context,
            'Dark Mode',
            'Switch between light and dark theme',
            false,
            (value) {},
          ),
          const SizedBox(height: 32),
          _buildSectionTitle(context, 'Support'),
          const SizedBox(height: 16),
          _buildSupportItem(
            context,
            'Help Center',
            'Get help with your account',
            Icons.help_outline,
          ),
          _buildSupportItem(
            context,
            'Contact Support',
            'Reach out to our support team',
            Icons.support_agent_outlined,
          ),
          _buildSupportItem(
            context,
            'Terms & Conditions',
            'Read our terms of service',
            Icons.description_outlined,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0);
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildInfoCard(BuildContext context, List<Map<String, dynamic>> items) {
    return Card(
      child: Column(
        children: items.map((item) {
          return ListTile(
            leading: Icon(
              item['icon'] as IconData,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(
              item['label'] as String,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            subtitle: Text(
              item['value'] as String,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () {},
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPaymentMethodCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
  ) {
    return Card(
      child: ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 32,
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {},
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context,
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey[600]),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSupportItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey[600]),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }
} 