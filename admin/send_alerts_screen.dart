import 'package:flutter/material.dart';
import 'package:lost_app_management/admin/screens/widgets/admin_bottom_nav.dart';

class SendAlertsScreen extends StatefulWidget {
  const SendAlertsScreen({super.key});

  @override
  State<SendAlertsScreen> createState() => _SendAlertsScreenState();
}

class _SendAlertsScreenState extends State<SendAlertsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  String _audience = 'All Users';

  final List<_AlertEntry> _alerts = [
    const _AlertEntry(
      title: 'High-value item recovered',
      message: 'A laptop and ID bundle has been secured at the admin office.',
      audience: 'All Users',
      time: 'Today, 11:30 AM',
    ),
    const _AlertEntry(
      title: 'Claim proof reminder',
      message: 'Students with pending phone claims must upload proof before 5 PM.',
      audience: 'Claimants',
      time: 'Today, 9:15 AM',
    ),
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _sendAlert() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    final alert = _AlertEntry(
      title: _titleController.text.trim(),
      message: _messageController.text.trim(),
      audience: _audience,
      time: 'Just now',
    );

    setState(() {
      _alerts.insert(0, alert);
      _titleController.clear();
      _messageController.clear();
      _audience = 'All Users';
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Alert sent successfully'),
          backgroundColor: Color(0xFF2A9D8F),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F3D56),
        foregroundColor: Colors.white,
        title: const Text('Send Alerts'),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Broadcast Campus Alerts',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Send static alerts to users about found items, pending proofs, pickup reminders, and urgent updates.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
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
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create Alert',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF102A43),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Alert Title',
                        hintText: 'Enter alert title',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Alert title is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _messageController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Alert Message',
                        hintText: 'Write the alert message',
                        alignLabelWithHint: true,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Alert message is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _audience,
                      decoration: const InputDecoration(labelText: 'Audience'),
                      items: const [
                        DropdownMenuItem(
                          value: 'All Users',
                          child: Text('All Users'),
                        ),
                        DropdownMenuItem(
                          value: 'Claimants',
                          child: Text('Claimants'),
                        ),
                        DropdownMenuItem(
                          value: 'Item Owners',
                          child: Text('Item Owners'),
                        ),
                        DropdownMenuItem(
                          value: 'Security Team',
                          child: Text('Security Team'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          _audience = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _sendAlert,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0F3D56),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        icon: const Icon(Icons.campaign_outlined),
                        label: const Text('Send Alert'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Recent Alerts',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF102A43),
              ),
            ),
            const SizedBox(height: 12),
            ..._alerts.map(
              (alert) => Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x10000000),
                      blurRadius: 14,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Color(0xFFE6F4F1),
                          child: Icon(
                            Icons.notifications_active_outlined,
                            color: Color(0xFF0F3D56),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                alert.title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF102A43),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${alert.audience} | ${alert.time}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: const Color(0xFF829AB1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      alert.message,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF486581),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 0),
    );
  }
}

class _AlertEntry {
  const _AlertEntry({
    required this.title,
    required this.message,
    required this.audience,
    required this.time,
  });

  final String title;
  final String message;
  final String audience;
  final String time;
}




