import 'package:flutter/material.dart';
import '../../../data/models/claim_model.dart';
import '../../../data/repositories/claim_repository.dart';
import '../../../data/repositories/notification_repository.dart';
import '../../screens/claims/claim_form.dart';

class ClaimRequestScreen extends StatefulWidget {
  const ClaimRequestScreen({
    super.key,
    required this.itemId,
    required this.itemName,
  });

  final String itemId;
  final String itemName;

  @override
  State<ClaimRequestScreen> createState() => _ClaimRequestScreenState();
}

class _ClaimRequestScreenState extends State<ClaimRequestScreen> {
  final ClaimRepository _claimRepository = ClaimRepository();
  final NotificationRepository _notificationRepository =
      NotificationRepository();

  void _submitClaim(Map<String, String> claimData) {
    final claim = ClaimModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      itemId: widget.itemId,
      claimedBy: 'user1',
      proofOfOwnership: claimData['proof'] ?? '',
      notes: claimData['notes'] ?? '',
      status: 'Pending',
      claimedAt: DateTime.now(),
    );

    _claimRepository.createClaim(claim).then((result) async {
      if (!mounted || result == null) {
        return;
      }

      await _notificationRepository.add(
        title: 'Claim Submitted',
        message: 'Claim for ${widget.itemName} has been submitted for review.',
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Claim request submitted for ${widget.itemName}'),
        ),
      );
      Navigator.pop(context, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Claim'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Claim Item',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Provide details about the item you want to claim.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ClaimForm(
              onSubmit: _submitClaim,
              itemName: widget.itemName,
            ),
          ],
        ),
      ),
    );
  }
}
