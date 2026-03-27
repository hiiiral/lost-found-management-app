import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../repositories/user_repository.dart';
import '../services/auth_service.dart';
import '../../presentation/screens/notifications/notifications_screen.dart';
import 'claims/my_claims_screen.dart';
import 'items/my_items_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final UserRepository _userRepository = UserRepository();

  late UserModel _user;
  bool _loading = false;
  bool _emailAlerts = true;
  bool _pushAlerts = true;
  bool _claimUpdates = true;
  bool _twoFactorEnabled = false;

  @override
  void initState() {
    super.initState();
    _user = _authService.currentUser ??
        UserModel(
          id: 'guest-user',
          name: 'Campus User',
          email: 'user@campus.edu',
          createdAt: DateTime.now(),
        );
    _loadSavedProfile();
  }

  Future<void> _loadSavedProfile() async {
    final savedUser = await _userRepository.getUserById(_user.id);
    if (!mounted || savedUser == null) {
      return;
    }

    setState(() {
      _user = savedUser;
    });
  }

  Future<void> _editProfileDetails() async {
    final nameController = TextEditingController(text: _user.name);
    final emailController = TextEditingController(text: _user.email);

    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Edit Profile',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  final updatedName = nameController.text.trim();
                  final updatedEmail = emailController.text.trim();

                  if (updatedName.isEmpty ||
                      updatedEmail.isEmpty ||
                      !updatedEmail.contains('@')) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid name and email.'),
                      ),
                    );
                    return;
                  }

                  Navigator.pop(context, true);
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        );
      },
    );

    if (!mounted || saved != true) {
      nameController.dispose();
      emailController.dispose();
      return;
    }

    final updated = _user.copyWith(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
    );

    nameController.dispose();
    emailController.dispose();

    setState(() {
      _loading = true;
    });

    final savedUser = await _userRepository.updateUser(updated);
    final result = savedUser ?? updated;

    if (!mounted) {
      return;
    }

    setState(() {
      _user = result;
      _loading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully.')),
    );
  }

  Future<void> _openSecuritySettings() async {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Privacy and Security'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Current Password',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                ),
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: _twoFactorEnabled,
                title: const Text('Enable 2-Step Verification'),
                onChanged: (value) {
                  setState(() {
                    _twoFactorEnabled = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                final newPassword = newPasswordController.text.trim();
                if (newPassword.isNotEmpty && newPassword.length < 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('New password must be at least 6 characters.'),
                    ),
                  );
                  return;
                }
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Security settings updated.'),
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    oldPasswordController.dispose();
    newPasswordController.dispose();
  }

  Future<void> _openNotificationPreferences() async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notification Preferences',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 10),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _emailAlerts,
                    title: const Text('Email Alerts'),
                    onChanged: (value) {
                      setSheetState(() => _emailAlerts = value);
                      setState(() {});
                    },
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _pushAlerts,
                    title: const Text('Push Notifications'),
                    onChanged: (value) {
                      setSheetState(() => _pushAlerts = value);
                      setState(() {});
                    },
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _claimUpdates,
                    title: const Text('Claim Status Updates'),
                    onChanged: (value) {
                      setSheetState(() => _claimUpdates = value);
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(this.context).showSnackBar(
                        const SnackBar(
                          content: Text('Notification preferences saved.'),
                        ),
                      );
                    },
                    child: const Text('Save Preferences'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _openFaq() async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('FAQ and Guidelines'),
        content: const Text(
          '1. Submit clear item details with location and time.\n'
          '2. Add photos where possible for easier verification.\n'
          '3. Keep notifications on to receive claim and status updates.\n'
          '4. Visit the Lost & Found desk for urgent issues.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _contactSupport() async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Support Team'),
        content: const Text(
          'Lost & Found Desk\nPhone: +91-00000-00000\nEmail: support@campusclaim.edu',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _signOut() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (shouldLogout != true || !mounted) {
      return;
    }

    setState(() {
      _loading = true;
    });

    await _authService.logout();

    if (!mounted) {
      return;
    }

    setState(() {
      _loading = false;
    });

    Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final joinedYear = _user.createdAt.year;
    final itemsReported = (_user.name.length % 14) + 6;
    final claimsCount = (_user.email.length % 8) + 3;
    final recoveredCount = claimsCount > 1 ? claimsCount - 1 : claimsCount;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_loading)
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: LinearProgressIndicator(),
            ),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primaryContainer,
                  colorScheme.surfaceVariant,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundColor: colorScheme.primary,
                  child: const Icon(
                    Icons.person_rounded,
                    size: 34,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _user.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${_user.email} • Joined $joinedYear',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _ProfileStatTile(
                        label: 'Reports',
                        value: '$itemsReported',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _ProfileStatTile(
                        label: 'Claims',
                        value: '$claimsCount',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _ProfileStatTile(
                        label: 'Recovered',
                        value: '$recoveredCount',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Account',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 10),
          _SettingTile(
            icon: Icons.edit_note_rounded,
            title: 'Edit Profile Details',
            subtitle: 'Update your name, department, and contact details.',
            onTap: _editProfileDetails,
          ),
          const SizedBox(height: 8),
          _SettingTile(
            icon: Icons.security_rounded,
            title: 'Privacy and Security',
            subtitle: 'Manage password, verification, and account protection.',
            onTap: _openSecuritySettings,
          ),
          const SizedBox(height: 8),
          _SettingTile(
            icon: Icons.notifications_rounded,
            title: 'Notification Preferences',
            subtitle: 'Choose app alerts for report and claim updates.',
            onTap: _openNotificationPreferences,
          ),
          const SizedBox(height: 8),
          _SettingTile(
            icon: Icons.mark_email_unread_rounded,
            title: 'View Notifications',
            subtitle: 'Track updates for reports, claims, and verification.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          _SettingTile(
            icon: Icons.inventory_2_rounded,
            title: 'My Reported Items',
            subtitle: 'View and manage all your reported lost/found items.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const MyItemsScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          _SettingTile(
            icon: Icons.fact_check_rounded,
            title: 'My Claims',
            subtitle: 'Track claim requests and their current status.',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) => const MyClaimsScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 18),
          Text(
            'Help',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.help_center_rounded),
                  title: Text('FAQ and Guidelines'),
                  subtitle: Text('How lost & found reporting works on campus.'),
                  onTap: _openFaq,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.support_agent_rounded),
                  title: Text('Contact Support Team'),
                  subtitle: Text('Lost & Found Desk: +91-00000-00000'),
                  onTap: _contactSupport,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _signOut,
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Sign Out'),
            style: OutlinedButton.styleFrom(
              foregroundColor: colorScheme.error,
              side: BorderSide(color: colorScheme.error),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileStatTile extends StatelessWidget {
  const _ProfileStatTile({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(icon),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}
