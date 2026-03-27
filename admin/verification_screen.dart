import 'package:flutter/material.dart';
import 'package:lost_app_management/admin/screens/widgets/admin_bottom_nav.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final List<_VerificationEntry> _entries = [
    const _VerificationEntry(
      studentName: 'Aman Gupta',
      itemName: 'Dell Laptop',
      method: 'Student ID + purchase invoice checked',
      location: 'Admin Office',
      status: 'Ready',
      statusColor: Color(0xFF2A9D8F),
      notes: 'Serial number matches the stored device and handover can proceed.',
    ),
    const _VerificationEntry(
      studentName: 'Priya Nair',
      itemName: 'Silver Watch',
      method: 'Description matched, photo proof pending',
      location: 'Security Desk',
      status: 'Pending',
      statusColor: Color(0xFFF4A261),
      notes: 'Need a close-up wrist photo or purchase receipt for final confirmation.',
    ),
    const _VerificationEntry(
      studentName: 'Rohit Das',
      itemName: 'Headphones',
      method: 'Serial number mismatch detected',
      location: 'Verification Room',
      status: 'Issue',
      statusColor: Color(0xFFD62828),
      notes: 'Reported serial number does not match the inventory record.',
    ),
  ];

  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'All';

  int get _pendingChecks => _entries.where((entry) => entry.status == 'Pending').length;

  int get _verifiedToday => _entries.where((entry) => entry.status == 'Verified').length;

  int get _needReview =>
      _entries.where((entry) => entry.status == 'Issue' || entry.status == 'Review').length;

  int get _completed => _entries.where((entry) => entry.status == 'Verified').length;

  List<int> get _filteredEntryIndexes {
    final query = _searchController.text.trim().toLowerCase();

    return List<int>.generate(_entries.length, (index) => index).where((index) {
      final entry = _entries[index];
      final matchesSearch =
          query.isEmpty ||
          entry.studentName.toLowerCase().contains(query) ||
          entry.itemName.toLowerCase().contains(query) ||
          entry.location.toLowerCase().contains(query) ||
          entry.method.toLowerCase().contains(query);
      final matchesStatus = _selectedStatus == 'All' || entry.status == _selectedStatus;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showMessage(String message, Color color) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _verifyEntry(int index) {
    final entry = _entries[index];

    setState(() {
      _entries[index] = _entries[index].copyWith(
        status: 'Verified',
        statusColor: const Color(0xFF2A9D8F),
        method: '${entry.method} | Verification completed',
      );
    });

    _showMessage(
      '${entry.itemName} verified for ${entry.studentName}',
      const Color(0xFF2A9D8F),
    );
  }

  Future<void> _requestMore(int index) async {
    final entry = _entries[index];

    setState(() {
      _entries[index] = _entries[index].copyWith(
        status: 'Review',
        statusColor: const Color(0xFF0F3D56),
      );
    });

    _showMessage(
      'Opened request details for ${entry.itemName}',
      const Color(0xFF0F3D56),
    );

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Request More Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DetailRow(label: 'Student', value: entry.studentName),
              _DetailRow(label: 'Item', value: entry.itemName),
              _DetailRow(label: 'Location', value: entry.location),
              const SizedBox(height: 12),
              Text(
                'Required Content',
                style: Theme.of(dialogContext).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF102A43),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                entry.notes,
                style: Theme.of(dialogContext).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF486581),
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Ask the claimant to upload one more proof image, receipt, or serial number snapshot before final verification.',
                style: Theme.of(dialogContext).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF6B7C93),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _showMessage(
                  'More details requested from ${entry.studentName}',
                  const Color(0xFF0F3D56),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F3D56),
                foregroundColor: Colors.white,
              ),
              child: const Text('Send Request'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredEntryIndexes = _filteredEntryIndexes;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F3D56),
        foregroundColor: Colors.white,
        title: const Text('Verification Center'),
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
                    'Ownership Verification',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Validate claimant identity, review submitted proofs, and confirm item handover before approval.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _VerificationSummaryCard(
                    title: 'Pending Checks',
                    value: _pendingChecks.toString(),
                    color: const Color(0xFFF4A261),
                    icon: Icons.fact_check_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _VerificationSummaryCard(
                    title: 'Verified Today',
                    value: _verifiedToday.toString(),
                    color: const Color(0xFF2A9D8F),
                    icon: Icons.verified_user_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _VerificationSummaryCard(
                    title: 'Need Review',
                    value: _needReview.toString(),
                    color: const Color(0xFFD62828),
                    icon: Icons.error_outline_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _VerificationSummaryCard(
                    title: 'Completed',
                    value: _completed.toString(),
                    color: const Color(0xFF0F3D56),
                    icon: Icons.task_alt_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x10000000),
                    blurRadius: 14,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Search by student, item, location, or method',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: _searchController.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                              icon: const Icon(Icons.close_rounded),
                            ),
                      filled: true,
                      fillColor: const Color(0xFFF4F7FB),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _selectedStatus,
                    decoration: InputDecoration(
                      labelText: 'Filter by status',
                      filled: true,
                      fillColor: const Color(0xFFF4F7FB),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'All', child: Text('All Statuses')),
                      DropdownMenuItem(value: 'Ready', child: Text('Ready')),
                      DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                      DropdownMenuItem(value: 'Issue', child: Text('Issue')),
                      DropdownMenuItem(value: 'Review', child: Text('Review')),
                      DropdownMenuItem(value: 'Verified', child: Text('Verified')),
                    ],
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _selectedStatus = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Verification Queue',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF102A43),
              ),
            ),
            const SizedBox(height: 12),
            if (filteredEntryIndexes.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  'No matching verification cases found.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF6B7C93),
                  ),
                ),
              )
            else
              ...filteredEntryIndexes.map(
                (index) => _VerificationTile(
                  studentName: _entries[index].studentName,
                  itemName: _entries[index].itemName,
                  method: _entries[index].method,
                  location: _entries[index].location,
                  status: _entries[index].status,
                  statusColor: _entries[index].statusColor,
                  onRequestMore: () => _requestMore(index),
                  onVerify: () => _verifyEntry(index),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 0),
    );
  }
}

class _VerificationSummaryCard extends StatefulWidget {
  const _VerificationSummaryCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String title;
  final String value;
  final Color color;
  final IconData icon;

  @override
  State<_VerificationSummaryCard> createState() =>
      _VerificationSummaryCardState();
}

class _VerificationSummaryCardState extends State<_VerificationSummaryCard> {
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
        children: [
          CircleAvatar(
            backgroundColor: widget.color.withOpacity(0.12),
            child: Icon(widget.icon, color: widget.color),
          ),
          const SizedBox(height: 14),
          Text(
            widget.value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: const Color(0xFF102A43),
            ),
          ),
          const SizedBox(height: 4),
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

class _VerificationTile extends StatefulWidget {
  const _VerificationTile({
    required this.studentName,
    required this.itemName,
    required this.method,
    required this.location,
    required this.status,
    required this.statusColor,
    required this.onRequestMore,
    required this.onVerify,
  });

  final String studentName;
  final String itemName;
  final String method;
  final String location;
  final String status;
  final Color statusColor;
  final VoidCallback onRequestMore;
  final VoidCallback onVerify;

  @override
  State<_VerificationTile> createState() => _VerificationTileState();
}

class _VerificationTileState extends State<_VerificationTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
              CircleAvatar(
                radius: 22,
                backgroundColor: widget.statusColor.withOpacity(0.12),
                child: Icon(
                  Icons.verified_user_outlined,
                  color: widget.statusColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.studentName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF102A43),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Item: ${widget.itemName}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF486581),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: widget.statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.status,
                  style: TextStyle(
                    color: widget.statusColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.method,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF6B7C93),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Location: ${widget.location}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: const Color(0xFF829AB1),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: widget.onRequestMore,
                child: const Text('Request More'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: widget.onVerify,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F3D56),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Verify'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF486581),
          ),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}

class _VerificationEntry {
  const _VerificationEntry({
    required this.studentName,
    required this.itemName,
    required this.method,
    required this.location,
    required this.status,
    required this.statusColor,
    required this.notes,
  });

  final String studentName;
  final String itemName;
  final String method;
  final String location;
  final String status;
  final Color statusColor;
  final String notes;

  _VerificationEntry copyWith({
    String? studentName,
    String? itemName,
    String? method,
    String? location,
    String? status,
    Color? statusColor,
    String? notes,
  }) {
    return _VerificationEntry(
      studentName: studentName ?? this.studentName,
      itemName: itemName ?? this.itemName,
      method: method ?? this.method,
      location: location ?? this.location,
      status: status ?? this.status,
      statusColor: statusColor ?? this.statusColor,
      notes: notes ?? this.notes,
    );
  }
}
