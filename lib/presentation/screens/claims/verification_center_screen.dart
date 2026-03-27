import 'package:flutter/material.dart';

import '../../../data/models/claim_model.dart';
import '../../../data/models/item_model.dart';
import '../../../data/repositories/claim_repository.dart';
import '../../../data/repositories/item_repository.dart';
import '../../../data/repositories/notification_repository.dart';

class VerificationCenterScreen extends StatefulWidget {
  const VerificationCenterScreen({super.key});

  @override
  State<VerificationCenterScreen> createState() =>
      _VerificationCenterScreenState();
}

class _VerificationCenterScreenState extends State<VerificationCenterScreen> {
  final ClaimRepository _claimRepository = ClaimRepository();
  final ItemRepository _itemRepository = ItemRepository();
  final NotificationRepository _notificationRepository =
      NotificationRepository();

  List<ClaimModel> _claims = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadClaims();
  }

  Future<void> _loadClaims() async {
    final claims = await _claimRepository.getAllClaims();
    if (!mounted) {
      return;
    }
    setState(() {
      _claims = claims..sort((a, b) => b.claimedAt.compareTo(a.claimedAt));
      _loading = false;
    });
  }

  Future<void> _updateClaimStatus(ClaimModel claim, String nextStatus) async {
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _loading = true);

    final updatedClaim =
        await _claimRepository.updateClaimStatus(claim.id, nextStatus);

    if (updatedClaim != null && nextStatus == 'Approved') {
      await _itemRepository.updateItemStatus(claim.itemId, 'Claimed');
      await _notificationRepository.add(
        title: 'Claim Approved',
        message: 'Claim ${claim.id} was approved and item marked as Claimed.',
      );
    }

    if (updatedClaim != null && nextStatus == 'Rejected') {
      await _notificationRepository.add(
        title: 'Claim Rejected',
        message: 'Claim ${claim.id} was rejected after verification.',
      );
    }

    await _loadClaims();

    if (!mounted || updatedClaim == null) {
      return;
    }

    messenger.showSnackBar(
      SnackBar(content: Text('Claim updated to ${updatedClaim.status}')),
    );
  }

  Future<ItemModel?> _itemForClaim(ClaimModel claim) {
    return _itemRepository.getItemById(claim.itemId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification Center'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _claims.isEmpty
              ? const Center(child: Text('No claim requests available'))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _claims.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final claim = _claims[index];
                    final lower = claim.status.toLowerCase();
                    final isPending =
                        lower == 'pending' || lower == 'in review';

                    return FutureBuilder<ItemModel?>(
                      future: _itemForClaim(claim),
                      builder: (context, snapshot) {
                        final item = snapshot.data;

                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item?.name ?? 'Unknown Item',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 6),
                                Text('Claim ID: ${claim.id}'),
                                Text('Status: ${claim.status}'),
                                const SizedBox(height: 8),
                                Text('Proof: ${claim.proofOfOwnership}'),
                                if (claim.notes.trim().isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text('Notes: ${claim.notes}'),
                                ],
                                if (isPending) ...[
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () => _updateClaimStatus(
                                            claim,
                                            'Rejected',
                                          ),
                                          child: const Text('Reject'),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () => _updateClaimStatus(
                                            claim,
                                            'Approved',
                                          ),
                                          child: const Text('Approve'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
