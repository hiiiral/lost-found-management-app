import '../models/claim_model.dart';

/// Claim repository for managing claim data operations
class ClaimRepository {
  // Singleton instance
  static final ClaimRepository _instance = ClaimRepository._internal();

  factory ClaimRepository() {
    return _instance;
  }

  ClaimRepository._internal();

  // Mock claim storage
  final Map<String, ClaimModel> _claims = {
    '1': ClaimModel(
      id: '1',
      itemId: '1',
      claimedBy: 'user2',
      proofOfOwnership: 'Has university ID sticker on the backpack',
      notes: 'This is my backpack, has my name inside',
      status: 'Pending',
      claimedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  };

  /// Get all claims
  Future<List<ClaimModel>> getAllClaims() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return _claims.values.toList();
    } catch (e) {
      print('Error fetching claims: $e');
      return [];
    }
  }

  /// Get claim by ID
  Future<ClaimModel?> getClaimById(String claimId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return _claims[claimId];
    } catch (e) {
      print('Error fetching claim: $e');
      return null;
    }
  }

  /// Create new claim
  Future<ClaimModel?> createClaim(ClaimModel claim) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      _claims[claim.id] = claim;
      return claim;
    } catch (e) {
      print('Error creating claim: $e');
      return null;
    }
  }

  /// Get all claims for a specific item
  Future<List<ClaimModel>> getClaimsByItemId(String itemId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 250));
      return _claims.values.where((claim) => claim.itemId == itemId).toList();
    } catch (e) {
      print('Error fetching claims by item id: $e');
      return [];
    }
  }

  /// Get claims by status
  Future<List<ClaimModel>> getClaimsByStatus(String status) async {
    try {
      await Future.delayed(const Duration(milliseconds: 250));
      return _claims.values
          .where((claim) => claim.status.toLowerCase() == status.toLowerCase())
          .toList();
    } catch (e) {
      print('Error fetching claims by status: $e');
      return [];
    }
  }

  /// Update claim status
  Future<ClaimModel?> updateClaimStatus(String claimId, String status) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      final claim = _claims[claimId];
      if (claim != null) {
        _claims[claimId] = claim.copyWith(status: status);
        return _claims[claimId];
      }
      return null;
    } catch (e) {
      print('Error updating claim status: $e');
      return null;
    }
  }

  /// Get claims for item
  Future<List<ClaimModel>> getClaimsForItem(String itemId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return _claims.values.where((claim) => claim.itemId == itemId).toList();
    } catch (e) {
      print('Error fetching claims for item: $e');
      return [];
    }
  }

  /// Get claims by user
  Future<List<ClaimModel>> getClaimsByUser(String userId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return _claims.values
          .where((claim) => claim.claimedBy == userId)
          .toList();
    } catch (e) {
      print('Error fetching claims by user: $e');
      return [];
    }
  }
}
