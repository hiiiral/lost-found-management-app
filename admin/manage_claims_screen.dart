import 'package:flutter/material.dart';
import 'package:lost_app_management/admin/screens/widgets/admin_bottom_nav.dart';
import 'package:lost_app_management/admin/screens/widgets/approval_buttons.dart';

class ManageClaimsScreen extends StatefulWidget {
  const ManageClaimsScreen({super.key});

  @override
  State<ManageClaimsScreen> createState() => _ManageClaimsScreenState();
}

class _ManageClaimsScreenState extends State<ManageClaimsScreen> {
  final List<_ClaimEntry> _claims = [
    _ClaimEntry(
      claimant: 'Rahul Sharma',
      itemName: 'Samsung Phone',
      proof: 'Matched lock screen and IMEI details',
      requestTime: 'Today, 10:15 AM',
      status: 'Pending',
      statusColor: const Color(0xFFF4A261),
    ),
    _ClaimEntry(
      claimant: 'Anjali Verma',
      itemName: 'College ID Card',
      proof: 'Verified registration number and photo',
      requestTime: 'Today, 9:00 AM',
      status: 'Approved',
      statusColor: const Color(0xFF2A9D8F),
    ),
    _ClaimEntry(
      claimant: 'Mohit Kumar',
      itemName: 'Bluetooth Earbuds',
      proof: 'Description mismatch with stored item',
      requestTime: 'Yesterday, 4:40 PM',
      status: 'Rejected',
      statusColor: const Color(0xFFD62828),
    ),
    _ClaimEntry(
      claimant: 'Sneha Patel',
      itemName: 'Laptop Charger',
      proof: 'Waiting for additional purchase proof',
      requestTime: 'Yesterday, 1:20 PM',
      status: 'Review',
      statusColor: const Color(0xFF0F3D56),
    ),
  ];

  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'All';

  int get _pendingCount => _claims.where((claim) => claim.status == 'Pending').length;

  int get _approvedCount => _claims.where((claim) => claim.status == 'Approved').length;

  int get _rejectedCount => _claims.where((claim) => claim.status == 'Rejected').length;

  int get _reviewCount => _claims.where((claim) => claim.status == 'Review').length;

  List<int> get _filteredClaimIndexes {
    final query = _searchController.text.trim().toLowerCase();

    return List<int>.generate(_claims.length, (index) => index).where((index) {
      final claim = _claims[index];
      final matchesSearch =
          query.isEmpty ||
          claim.claimant.toLowerCase().contains(query) ||
          claim.itemName.toLowerCase().contains(query) ||
          claim.proof.toLowerCase().contains(query);
      final matchesStatus = _selectedStatus == 'All' || claim.status == _selectedStatus;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showMessage(String message, Color backgroundColor) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _approveClaim(int index) {
    final claim = _claims[index];

    setState(() {
      _claims[index] = _claims[index].copyWith(
        status: 'Approved',
        statusColor: const Color(0xFF2A9D8F),
      );
    });

    _showMessage(
      '${claim.itemName} approved for ${claim.claimant}',
      const Color(0xFF2A9D8F),
    );
  }

  void _rejectClaim(int index) {
    final claim = _claims[index];

    setState(() {
      _claims.removeAt(index);
    });

    _showMessage(
      '${claim.itemName} rejected and removed from the list',
      const Color(0xFFD62828),
    );
  }

  Future<void> _showClaimReview(int index) async {
    if (!mounted) {
      return;
    }

    final claim = _claims[index];

    setState(() {
      _claims[index] = _claims[index].copyWith(
        status: 'Review',
        statusColor: const Color(0xFF0F3D56),
      );
    });

    _showMessage('Opened review for ${claim.itemName}', const Color(0xFF0F3D56));

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Review Claim'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ReviewRow(label: 'Claimant', value: claim.claimant),
              _ReviewRow(label: 'Item', value: claim.itemName),
              _ReviewRow(label: 'Request Time', value: claim.requestTime),
              _ReviewRow(label: 'Status', value: 'Review'),
              const SizedBox(height: 12),
              Text(
                'Proof Details',
                style: Theme.of(dialogContext).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF102A43),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                claim.proof,
                style: Theme.of(dialogContext).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF486581),
                  height: 1.35,
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
                _approveClaim(index);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F3D56),
                foregroundColor: Colors.white,
              ),
              child: const Text('Approve Now'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredClaimIndexes = _filteredClaimIndexes;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F3D56),
        foregroundColor: Colors.white,
        title: const Text('Manage Claims'),
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
                    'Claim Requests',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Review ownership requests, verify proofs, and approve or reject claims for reported campus items.',
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
                  child: _ClaimSummaryCard(
                    title: 'Pending Claims',
                    value: _pendingCount.toString(),
                    color: const Color(0xFFF4A261),
                    icon: Icons.pending_actions_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ClaimSummaryCard(
                    title: 'Approved',
                    value: _approvedCount.toString(),
                    color: const Color(0xFF2A9D8F),
                    icon: Icons.verified_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _ClaimSummaryCard(
                    title: 'Rejected',
                    value: _rejectedCount.toString(),
                    color: const Color(0xFFD62828),
                    icon: Icons.cancel_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ClaimSummaryCard(
                    title: 'Under Review',
                    value: _reviewCount.toString(),
                    color: const Color(0xFF0F3D56),
                    icon: Icons.fact_check_outlined,
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
                      hintText: 'Search by claimant, item, or proof',
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
                      DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                      DropdownMenuItem(value: 'Approved', child: Text('Approved')),
                      DropdownMenuItem(value: 'Rejected', child: Text('Rejected')),
                      DropdownMenuItem(value: 'Review', child: Text('Review')),
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
              'Latest Requests',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF102A43),
              ),
            ),
            const SizedBox(height: 12),
            if (_claims.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  'No claim requests left in the list.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF6B7C93),
                  ),
                ),
              )
            else if (filteredClaimIndexes.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  'No matching claim requests found.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF6B7C93),
                  ),
                ),
              )
            else
              ...filteredClaimIndexes.map(
                (index) => _ClaimTile(
                  claimant: _claims[index].claimant,
                  itemName: _claims[index].itemName,
                  proof: _claims[index].proof,
                  requestTime: _claims[index].requestTime,
                  status: _claims[index].status,
                  statusColor: _claims[index].statusColor,
                  onApprove: () => _approveClaim(index),
                  onReject: () => _rejectClaim(index),
                  onReview: () => _showClaimReview(index),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 0),
    );
  }
}

class _ClaimSummaryCard extends StatefulWidget {
  const _ClaimSummaryCard({
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
  State<_ClaimSummaryCard> createState() => _ClaimSummaryCardState();
}

class _ClaimSummaryCardState extends State<_ClaimSummaryCard> {
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

class _ClaimTile extends StatefulWidget {
  const _ClaimTile({
    required this.claimant,
    required this.itemName,
    required this.proof,
    required this.requestTime,
    required this.status,
    required this.statusColor,
    required this.onApprove,
    required this.onReject,
    required this.onReview,
  });

  final String claimant;
  final String itemName;
  final String proof;
  final String requestTime;
  final String status;
  final Color statusColor;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onReview;

  @override
  State<_ClaimTile> createState() => _ClaimTileState();
}

class _ClaimTileState extends State<_ClaimTile> {
  @override
  Widget build(BuildContext context) {
    final showReview = widget.status == 'Pending' || widget.status == 'Review';

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
                  Icons.person_outline_rounded,
                  color: widget.statusColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.claimant,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF102A43),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Requested: ${widget.itemName}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF486581),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
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
            widget.proof,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF6B7C93),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.requestTime,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF829AB1),
                  ),
                ),
              ),
              SizedBox(
                width: 240,
                child: ApprovalButtons(
                  isCompact: true,
                  showReview: showReview,
                  onReview: widget.onReview,
                  onReject: widget.onReject,
                  onApprove: widget.onApprove,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({required this.label, required this.value});

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

class _ClaimEntry {
  const _ClaimEntry({
    required this.claimant,
    required this.itemName,
    required this.proof,
    required this.requestTime,
    required this.status,
    required this.statusColor,
  });

  final String claimant;
  final String itemName;
  final String proof;
  final String requestTime;
  final String status;
  final Color statusColor;

  _ClaimEntry copyWith({
    String? claimant,
    String? itemName,
    String? proof,
    String? requestTime,
    String? status,
    Color? statusColor,
  }) {
    return _ClaimEntry(
      claimant: claimant ?? this.claimant,
      itemName: itemName ?? this.itemName,
      proof: proof ?? this.proof,
      requestTime: requestTime ?? this.requestTime,
      status: status ?? this.status,
      statusColor: statusColor ?? this.statusColor,
    );
  }
}
