import 'package:flutter/material.dart';
import 'package:lost_found_management_app/admin/screens/admin_profile_screen.dart';
import 'package:lost_found_management_app/admin/screens/admin_settings_screen.dart';
import 'package:lost_found_management_app/admin/screens/manage_claims_screen.dart';
import 'package:lost_found_management_app/admin/screens/manage_items_screen.dart';
import 'package:lost_found_management_app/admin/screens/send_alerts_screen.dart';
import 'package:lost_found_management_app/admin/screens/verification_screen.dart';
import 'package:lost_found_management_app/admin/widgets/admin_item_card.dart';
import 'package:lost_found_management_app/admin/widgets/admin_bottom_nav.dart';
import 'package:lost_found_management_app/admin/widgets/approval_buttons.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final List<_DashboardNotification> _notifications = [
    const _DashboardNotification(
      title: 'New claim request received',
      subtitle: 'A phone claim is waiting for admin approval.',
      time: '10 mins ago',
    ),
    const _DashboardNotification(
      title: 'Verification reminder',
      subtitle: 'One ownership check still needs review content.',
      time: '25 mins ago',
    ),
    const _DashboardNotification(
      title: 'Urgent item alert',
      subtitle: 'High-value electronics were added to the inventory queue.',
      time: '1 hour ago',
    ),
  ];

  void _openItems(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ManageItemsScreen()),
    );
  }

  void _openClaims(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ManageClaimsScreen()),
    );
  }

  void _openAlerts(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SendAlertsScreen()),
    );
  }

  void _openVerification(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const VerificationScreen()),
    );
  }

  void _openProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AdminProfileScreen()),
    );
  }

  void _openSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AdminSettingsScreen()),
    );
  }

  Future<void> _showNotifications() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF4F7FB),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        final sheetHeight = MediaQuery.of(sheetContext).size.height * 0.72;

        return SafeArea(
          child: SizedBox(
            height: sheetHeight,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Notifications',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF102A43),
                            ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _notifications.clear();
                          });
                          Navigator.of(sheetContext).pop();
                        },
                        child: const Text('Clear All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: _notifications.isEmpty
                        ? Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'No new notifications.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: const Color(0xFF6B7C93)),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _notifications.length,
                            itemBuilder: (context, index) {
                              final notification = _notifications[index];
                              return Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      notification.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF102A43),
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      notification.subtitle,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: const Color(0xFF486581),
                                          ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      notification.time,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: const Color(0xFF829AB1),
                                          ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0F3D56),
        foregroundColor: Colors.white,
        title: const Text('Campus Lost & Found Admin'),
        actions: [
          IconButton(
            onPressed: _showNotifications,
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_none_rounded),
                if (_notifications.isNotEmpty)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD62828),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFF0F3D56),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        _notifications.length > 9
                            ? '9+'
                            : _notifications.length.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _openProfile(context),
            child: const Padding(
              padding: EdgeInsets.only(right: 16),
              child: CircleAvatar(
                backgroundColor: Color(0xFFFFB703),
                child: Icon(
                  Icons.admin_panel_settings_rounded,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                      'Welcome back, Admin',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Track reported items, approve claim requests, and manage campus recovery operations from one place.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _QuickInfoChip(
                          icon: Icons.inventory_2_outlined,
                          label: '248 Items Reported',
                        ),
                        _QuickInfoChip(
                          icon: Icons.assignment_turned_in_outlined,
                          label: '96 Claims Resolved',
                        ),
                        _QuickInfoChip(
                          icon: Icons.warning_amber_rounded,
                          label: '12 Urgent Cases',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.1,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  _StatCard(
                    title: 'Lost Reports',
                    value: '128',
                    icon: Icons.search_off_rounded,
                    color: Color(0xFFD62828),
                  ),
                  _StatCard(
                    title: 'Found Reports',
                    value: '120',
                    icon: Icons.find_in_page_rounded,
                    color: Color(0xFF2A9D8F),
                  ),
                  _StatCard(
                    title: 'Pending Approval',
                    value: '34',
                    icon: Icons.pending_actions_rounded,
                    color: Color(0xFFF4A261),
                  ),
                  _StatCard(
                    title: 'Returned Items',
                    value: '89',
                    icon: Icons.volunteer_activism_rounded,
                    color: Color(0xFF264653),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Quick Actions',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF102A43),
                ),
              ),
              const SizedBox(height: 12),
              GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.7,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _ActionCard(
                    icon: Icons.playlist_add_check_circle_outlined,
                    title: 'Review Claims',
                    onTap: () => _openClaims(context),
                  ),
                  _ActionCard(
                    icon: Icons.campaign_outlined,
                    title: 'Send Alerts',
                    onTap: () => _openAlerts(context),
                  ),
                  _ActionCard(
                    icon: Icons.verified_user_outlined,
                    title: 'Verification',
                    onTap: () => _openVerification(context),
                  ),
                  _ActionCard(
                    icon: Icons.analytics_outlined,
                    title: 'View Reports',
                    onTap: () => _openItems(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Recent Activity',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF102A43),
                ),
              ),
              const SizedBox(height: 12),
              const AdminItemCard(
                title: 'Laptop bag matched with owner',
                subtitle: 'Recovered item update',
                location: 'Engineering Block',
                time: '10 mins ago',
                status: 'Resolved',
                statusColor: Color(0xFF2A9D8F),
                icon: Icons.inventory_2_rounded,
              ),
              const AdminItemCard(
                title: 'New lost ID card submitted',
                subtitle: 'Incoming report',
                location: 'Library Counter',
                time: '25 mins ago',
                status: 'New',
                statusColor: Color(0xFFD62828),
                icon: Icons.badge_rounded,
              ),
              const AdminItemCard(
                title: 'Phone claim request awaiting approval',
                subtitle: 'Claim workflow',
                location: 'Admin Office',
                time: '1 hour ago',
                status: 'Pending',
                statusColor: Color(0xFFF4A261),
                icon: Icons.pending_actions_rounded,
              ),
              const SizedBox(height: 18),
              Text(
                'Approval Panel',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF102A43),
                ),
              ),
              const SizedBox(height: 12),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Phone claim request',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF102A43),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Review the latest ownership request and take action directly from the dashboard.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF6B7C93),
                      ),
                    ),
                    const SizedBox(height: 14),
                    ApprovalButtons(
                      showReview: true,
                      onReview: () => _openClaims(context),
                      onReject: () {},
                      onApprove: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 0),
    );
  }
}

class _StatCard extends StatefulWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: widget.color.withOpacity(0.12),
            child: Icon(widget.icon, color: widget.color),
          ),
          Text(
            widget.value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF102A43),
                ),
          ),
          Text(
            widget.title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF486581),
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatefulWidget {
  const _ActionCard({required this.icon, required this.title, this.onTap});

  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  @override
  State<_ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<_ActionCard> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE4E7EB)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFE6F4F1),
                child: Icon(widget.icon, color: const Color(0xFF0F3D56)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF102A43),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickInfoChip extends StatefulWidget {
  const _QuickInfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  State<_QuickInfoChip> createState() => _QuickInfoChipState();
}

class _QuickInfoChipState extends State<_QuickInfoChip> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(widget.icon, size: 18, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            widget.label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardNotification {
  const _DashboardNotification({
    required this.title,
    required this.subtitle,
    required this.time,
  });

  final String title;
  final String subtitle;
  final String time;
}
