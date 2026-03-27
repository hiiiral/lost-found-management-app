import 'package:flutter/material.dart';
import 'package:lost_app_management/admin/screens/widgets/admin_bottom_nav.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F3D56),
        foregroundColor: Colors.white,
        title: const Text('Admin Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F3D56), Color(0xFF1D6F8C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 38,
                    backgroundColor: Color(0xFFFFB703),
                    child: Icon(
                      Icons.admin_panel_settings_rounded,
                      size: 40,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Campus Recovery Admin',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'admin@campuslostfound.com',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _ProfileSection(
              title: 'Account Details',
              children: const [
                _ProfileRow(label: 'Role', value: 'Super Admin'),
                _ProfileRow(label: 'Department', value: 'Campus Recovery Desk'),
                _ProfileRow(label: 'Contact', value: '+91 98765 43210'),
                _ProfileRow(label: 'Shift', value: '09:00 AM - 05:00 PM'),
              ],
            ),
            const SizedBox(height: 16),
            _ProfileSection(
              title: 'Activity Summary',
              children: const [
                _ProfileRow(label: 'Claims Reviewed', value: '96'),
                _ProfileRow(label: 'Items Managed', value: '248'),
                _ProfileRow(label: 'Verifications Completed', value: '57'),
                _ProfileRow(label: 'Alerts Sent', value: '14'),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 2),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF102A43),
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF6B7C93),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF102A43),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}




